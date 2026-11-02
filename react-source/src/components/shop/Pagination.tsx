import React from 'react';
import { ChevronLeftIcon, ChevronRightIcon } from 'lucide-react';

interface PaginationProps {
  page: number;
  pageCount: number;
  onChange: (p: number) => void;
}

export function Pagination({ page, pageCount, onChange }: PaginationProps) {
  if (pageCount <= 1) return null;
  const go = (p: number) => {
    onChange(p);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };
  return (
    <nav aria-label="Pagination" className="mt-16 flex items-center justify-center gap-1">
      <button onClick={() => go(page - 1)} disabled={page === 1} aria-label="Previous page" className="flex h-10 w-10 items-center justify-center transition-colors hover:bg-cream disabled:text-stone/50 disabled:hover:bg-transparent">
        <ChevronLeftIcon className="h-4 w-4" />
      </button>
      {Array.from({ length: pageCount }, (_, i) => i + 1).map((p) =>
      <button
        key={p}
        onClick={() => go(p)}
        aria-current={p === page ? 'page' : undefined}
        className={`h-10 w-10 text-[13px] transition-colors ${p === page ? 'bg-ink text-white' : 'hover:bg-cream'}`}>
        
          {p}
        </button>
      )}
      <button onClick={() => go(page + 1)} disabled={page === pageCount} aria-label="Next page" className="flex h-10 w-10 items-center justify-center transition-colors hover:bg-cream disabled:text-stone/50 disabled:hover:bg-transparent">
        <ChevronRightIcon className="h-4 w-4" />
      </button>
    </nav>);

}