import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { SlidersHorizontalIcon, XIcon } from 'lucide-react';
import { useProductFilters } from '../hooks/useProductFilters';
import { FilterPanel } from '../components/shop/FilterPanel';
import { SortSelect } from '../components/shop/SortSelect';
import { Pagination } from '../components/shop/Pagination';
import { ProductCard } from '../components/ProductCard';
import { Drawer } from '../components/Drawer';
import { Button } from '../components/Button';
import { collections } from '../data/products';

export function Shop() {
  const { filters, toggle, clearAll, sort, setSort, page, setPage, pageCount, results, paged, activeCount, collection } = useProductFilters();
  const [drawerOpen, setDrawerOpen] = useState(false);
  const activeCollection = collections.find((c) => c.id === collection);

  const chips = [
  ...filters.categories.map((v) => ({ key: 'categories' as const, v })),
  ...filters.sizes.map((v) => ({ key: 'sizes' as const, v })),
  ...filters.colors.map((v) => ({ key: 'colors' as const, v })),
  ...filters.prices.map((v) => ({ key: 'prices' as const, v }))];

  const priceLabel: Record<string, string> = { 'under-50': 'Under $50', '50-100': '$50 – $100', 'over-100': 'Over $100' };

  return (
    <div className="bg-white">
      <header className="border-b border-hairline bg-cream">
        <div className="mx-auto max-w-site px-5 py-12 md:px-8 md:py-16">
          <nav aria-label="Breadcrumb" className="text-[12px] text-stone">
            <Link to="/" className="hover:text-ink">Home</Link> / {activeCollection ? <Link to="/collections" className="hover:text-ink">Collections</Link> : 'Shop'}
          </nav>
          <h1 className="mt-4 font-serif text-[36px] uppercase leading-tight tracking-[0.06em] md:text-[52px]">
            {activeCollection ? activeCollection.name : 'Shop All'}
          </h1>
          <p className="mt-3 max-w-xl text-[15px] text-ink/65">
            {activeCollection ? activeCollection.description : 'Heavyweight essentials, made to be worn for years. Every piece carries a quiet reminder.'}
          </p>
        </div>
      </header>

      <div className="mx-auto max-w-site px-5 pb-20 pt-8 md:px-8">
        <div className="flex items-center justify-between gap-4 border-b border-hairline pb-5">
          <div className="flex items-center gap-4">
            <button
              onClick={() => setDrawerOpen(true)}
              className="flex h-10 items-center gap-2 border border-hairline px-4 text-[13px] transition-colors hover:border-ink lg:hidden">
              
              <SlidersHorizontalIcon className="h-4 w-4" /> Filter{activeCount > 0 && ` (${activeCount})`}
            </button>
            <p className="text-[13px] text-stone" aria-live="polite">
              {results.length} {results.length === 1 ? 'product' : 'products'}
            </p>
          </div>
          <SortSelect value={sort} onChange={setSort} />
        </div>

        {chips.length > 0 &&
        <div className="flex flex-wrap items-center gap-2 pt-5">
            {chips.map(({ key, v }) =>
          <button key={`${key}-${v}`} onClick={() => toggle(key, v as never)} className="flex h-8 items-center gap-1.5 bg-cream px-3 text-[12px] transition-colors hover:bg-hairline">
                {key === 'prices' ? priceLabel[v] : v}
                <XIcon className="h-3 w-3" aria-label="Remove filter" />
              </button>
          )}
            <button onClick={clearAll} className="ml-1 text-[12px] underline underline-offset-4 text-stone hover:text-ink">
              Clear all
            </button>
          </div>
        }

        <div className="mt-8 grid gap-10 lg:grid-cols-[240px_1fr] lg:gap-12">
          <aside className="hidden lg:block" aria-label="Filters">
            <div className="sticky top-28">
              <FilterPanel filters={filters} toggle={toggle} />
            </div>
          </aside>

          <section aria-label="Products">
            {paged.length === 0 ?
            <div className="flex flex-col items-center bg-cream px-6 py-20 text-center">
                <p className="font-serif text-[26px]">Nothing matches just yet</p>
                <p className="mt-2 max-w-sm text-[14px] text-ink/65">Try removing a filter or two — or browse everything we make.</p>
                <Button variant="outline" className="mt-8" onClick={clearAll}>
                  Clear filters
                </Button>
              </div> :

            <div className="grid grid-cols-2 gap-x-3 gap-y-10 md:grid-cols-3 md:gap-x-6">
                {paged.map((p) =>
              <ProductCard key={p.id} product={p} />
              )}
              </div>
            }
            <Pagination page={page} pageCount={pageCount} onChange={setPage} />
          </section>
        </div>
      </div>

      <Drawer open={drawerOpen} onClose={() => setDrawerOpen(false)} side="bottom" label="Filters">
        <div className="flex items-center justify-between border-b border-hairline px-5 py-4">
          <h2 className="font-serif text-xl uppercase tracking-[0.08em]">Filter</h2>
          <button onClick={() => setDrawerOpen(false)} aria-label="Close filters" className="-mr-2 p-2">
            <XIcon className="h-5 w-5" />
          </button>
        </div>
        <div className="flex-1 overflow-y-auto px-5 pt-6">
          <FilterPanel filters={filters} toggle={toggle} />
        </div>
        <div className="grid grid-cols-2 gap-3 border-t border-hairline px-5 py-4">
          <Button variant="outline" onClick={clearAll}>
            Clear
          </Button>
          <Button onClick={() => setDrawerOpen(false)}>Show {results.length}</Button>
        </div>
      </Drawer>
    </div>);

}