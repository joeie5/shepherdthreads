import { useEffect, useMemo, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { products } from '../data/products';
import type { Category, CollectionId, Product } from '../types/product';

export type SortKey = 'bestselling' | 'newest' | 'price-asc' | 'price-desc';
export type PriceBucket = 'under-50' | '50-100' | 'over-100';

export interface Filters {
  categories: Category[];
  sizes: string[];
  colors: string[];
  prices: PriceBucket[];
}

export const PAGE_SIZE = 9;

const emptyFilters: Filters = { categories: [], sizes: [], colors: [], prices: [] };

const inBucket = (price: number, b: PriceBucket) =>
b === 'under-50' ? price < 50 : b === '50-100' ? price >= 50 && price <= 100 : price > 100;

export function useProductFilters() {
  const [params, setParams] = useSearchParams();
  const initialCategory = params.get('category') as Category | null;
  const collection = params.get('collection') as CollectionId | null;

  const [filters, setFilters] = useState<Filters>({
    ...emptyFilters,
    categories: initialCategory ? [initialCategory] : []
  });
  const [sort, setSort] = useState<SortKey>('bestselling');
  const [page, setPage] = useState(1);

  useEffect(() => {
    setFilters({ ...emptyFilters, categories: initialCategory ? [initialCategory] : [] });
    setPage(1);
  }, [initialCategory, collection]);

  const toggle = <K extends keyof Filters,>(key: K, value: Filters[K][number]) => {
    setFilters((prev) => {
      const list = prev[key] as string[];
      const next = list.includes(value as string) ? list.filter((v) => v !== value) : [...list, value as string];
      return { ...prev, [key]: next };
    });
    setPage(1);
  };

  const clearAll = () => {
    setFilters(emptyFilters);
    setPage(1);
    if (params.get('category')) {
      params.delete('category');
      setParams(params, { replace: true });
    }
  };

  const results = useMemo(() => {
    let list: Product[] = products.filter((p) => {
      if (collection && p.collection !== collection) return false;
      if (filters.categories.length && !filters.categories.includes(p.category)) return false;
      if (filters.sizes.length && !p.sizes.some((s) => filters.sizes.includes(s))) return false;
      if (filters.colors.length && !p.colors.some((c) => filters.colors.includes(c.name))) return false;
      if (filters.prices.length && !filters.prices.some((b) => inBucket(p.price, b))) return false;
      return true;
    });
    list = [...list].sort((a, b) => {
      if (sort === 'newest') return b.addedOn.localeCompare(a.addedOn);
      if (sort === 'price-asc') return a.price - b.price;
      if (sort === 'price-desc') return b.price - a.price;
      return a.bestsellerRank - b.bestsellerRank;
    });
    return list;
  }, [filters, sort, collection]);

  const pageCount = Math.max(1, Math.ceil(results.length / PAGE_SIZE));
  const paged = results.slice((page - 1) * PAGE_SIZE, page * PAGE_SIZE);
  const activeCount = filters.categories.length + filters.sizes.length + filters.colors.length + filters.prices.length;

  return { filters, toggle, clearAll, sort, setSort, page, setPage, pageCount, results, paged, activeCount, collection };
}