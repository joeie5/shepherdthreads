import { products } from '../data/products';
import type { ColorVariant, Product } from '../types/product';

export function getProduct(id: string): Product | undefined {
  return products.find((p) => p.id === id);
}

export function getColor(product: Product, colorName?: string | null): ColorVariant {
  return product.colors.find((c) => c.name === colorName) ?? product.colors[0];
}

export function isLightColor(hex: string): boolean {
  const h = hex.replace('#', '');
  const r = parseInt(h.slice(0, 2), 16);
  const g = parseInt(h.slice(2, 4), 16);
  const b = parseInt(h.slice(4, 6), 16);
  return (r * 299 + g * 587 + b * 114) / 1000 > 200;
}

export function searchProducts(query: string): Product[] {
  const q = query.trim().toLowerCase();
  if (!q) return [];
  return products.filter((p) =>
  [p.name, p.subtitle, p.category, p.description, p.verse?.reference ?? '', ...p.colors.map((c) => c.name)].
  join(' ').
  toLowerCase().
  includes(q)
  );
}

export function relatedProducts(product: Product, count = 6): Product[] {
  const same = products.filter((p) => p.id !== product.id && p.category === product.category);
  const rest = products.filter((p) => p.id !== product.id && p.category !== product.category);
  return [...same, ...rest].slice(0, count);
}