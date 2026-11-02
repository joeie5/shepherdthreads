import React from 'react';
import { CheckIcon } from 'lucide-react';
import type { Filters, PriceBucket } from '../../hooks/useProductFilters';
import type { Category } from '../../types/product';
import { isLightColor } from '../../utils/products';

const categories: Category[] = ['Hoodies', 'Crewnecks', 'Tees', 'Headwear', 'Bottoms', 'Accessories'];
const sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'One Size'];
const colors = [
{ name: 'Black', hex: '#0A0A0A' },
{ name: 'Bone', hex: '#ECE7DC' },
{ name: 'Cream', hex: '#F1EBDD' },
{ name: 'Ecru', hex: '#E8E0CF' },
{ name: 'Stone', hex: '#9A9893' },
{ name: 'Natural', hex: '#E9E1CF' }];

const prices: {id: PriceBucket;label: string;}[] = [
{ id: 'under-50', label: 'Under $50' },
{ id: '50-100', label: '$50 – $100' },
{ id: 'over-100', label: 'Over $100' }];


interface FilterPanelProps {
  filters: Filters;
  toggle: <K extends keyof Filters>(key: K, value: Filters[K][number]) => void;
}

function Group({ title, children }: {title: string;children: React.ReactNode;}) {
  return (
    <fieldset className="border-b border-hairline py-6 first:pt-0">
      <legend className="mb-4 text-[12px] font-medium uppercase tracking-[0.14em]">{title}</legend>
      {children}
    </fieldset>);

}

function CheckRow({ checked, onChange, label }: {checked: boolean;onChange: () => void;label: string;}) {
  return (
    <label className="flex cursor-pointer items-center gap-3 py-1.5 text-[14px]">
      <input type="checkbox" checked={checked} onChange={onChange} className="peer sr-only" />
      <span className={`flex h-4 w-4 items-center justify-center border transition-colors peer-focus-visible:outline peer-focus-visible:outline-2 peer-focus-visible:outline-offset-2 ${checked ? 'border-ink bg-ink text-white' : 'border-stone/60'}`}>
        {checked && <CheckIcon className="h-3 w-3" strokeWidth={2.5} />}
      </span>
      <span className={checked ? 'text-ink' : 'text-ink/75'}>{label}</span>
    </label>);

}

export function FilterPanel({ filters, toggle }: FilterPanelProps) {
  return (
    <div>
      <Group title="Category">
        {categories.map((c) =>
        <CheckRow key={c} label={c} checked={filters.categories.includes(c)} onChange={() => toggle('categories', c)} />
        )}
      </Group>
      <Group title="Size">
        <div className="grid grid-cols-4 gap-2">
          {sizes.map((s) => {
            const active = filters.sizes.includes(s);
            return (
              <button
                key={s}
                type="button"
                aria-pressed={active}
                onClick={() => toggle('sizes', s)}
                className={`h-9 border text-[12px] transition-colors ${s === 'One Size' ? 'col-span-2' : ''} ${active ? 'border-ink bg-ink text-white' : 'border-hairline hover:border-ink'}`}>
                
                {s}
              </button>);

          })}
        </div>
      </Group>
      <Group title="Color">
        <div className="grid grid-cols-2 gap-y-1">
          {colors.map((c) => {
            const active = filters.colors.includes(c.name);
            return (
              <button key={c.name} type="button" aria-pressed={active} onClick={() => toggle('colors', c.name)} className="flex items-center gap-3 py-1.5 text-left text-[14px]">
                <span className={`rounded-full p-[2px] ring-1 ${active ? 'ring-ink' : 'ring-transparent'}`}>
                  <span className={`block h-5 w-5 rounded-full ${isLightColor(c.hex) ? 'ring-1 ring-inset ring-ink/15' : ''}`} style={{ backgroundColor: c.hex }} />
                </span>
                <span className={active ? 'text-ink' : 'text-ink/75'}>{c.name}</span>
              </button>);

          })}
        </div>
      </Group>
      <Group title="Price">
        {prices.map((p) =>
        <CheckRow key={p.id} label={p.label} checked={filters.prices.includes(p.id)} onChange={() => toggle('prices', p.id)} />
        )}
      </Group>
    </div>);

}