import React from 'react';
import { ChevronDownIcon } from 'lucide-react';
import type { SortKey } from '../../hooks/useProductFilters';

const options: {value: SortKey;label: string;}[] = [
{ value: 'bestselling', label: 'Bestselling' },
{ value: 'newest', label: 'Newest' },
{ value: 'price-asc', label: 'Price: Low to High' },
{ value: 'price-desc', label: 'Price: High to Low' }];


interface SortSelectProps {
  value: SortKey;
  onChange: (v: SortKey) => void;
}

export function SortSelect({ value, onChange }: SortSelectProps) {
  return (
    <label className="relative flex items-center gap-2 text-[13px]">
      <span className="hidden text-stone sm:inline">Sort by</span>
      <select
        value={value}
        onChange={(e) => onChange(e.target.value as SortKey)}
        className="h-10 cursor-pointer appearance-none border border-hairline bg-white pl-3 pr-9 text-[13px] outline-none transition-colors hover:border-ink focus:border-ink"
        aria-label="Sort products">
        
        {options.map((o) =>
        <option key={o.value} value={o.value}>
            {o.label}
          </option>
        )}
      </select>
      <ChevronDownIcon className="pointer-events-none absolute right-3 h-4 w-4" />
    </label>);

}