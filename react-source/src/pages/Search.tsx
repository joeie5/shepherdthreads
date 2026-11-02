import React, { useEffect, useRef, useState } from 'react';
import { Link, useSearchParams } from 'react-router-dom';
import { HistoryIcon, SearchIcon, TrendingUpIcon, XIcon } from 'lucide-react';
import { useStore } from '../contexts/StoreContext';
import { ProductCard } from '../components/ProductCard';
import { products } from '../data/products';
import { searchProducts } from '../utils/products';

const trending = ['Good Shepherd Hoodie', 'Psalm 23', 'Crewneck', 'Cap', 'Bone', 'Gift for pastor'];
const suggestedCategories = [
{ label: 'Hoodies', to: '/shop?category=Hoodies' },
{ label: 'Crewnecks', to: '/shop?category=Crewnecks' },
{ label: 'Tees', to: '/shop?category=Tees' },
{ label: 'Headwear', to: '/shop?category=Headwear' },
{ label: 'The Psalm 23 Collection', to: '/shop?collection=psalm-23' }];


export function Search() {
  const [params, setParams] = useSearchParams();
  const q = params.get('q') ?? '';
  const [input, setInput] = useState(q);
  const { recentSearches, addRecentSearch, clearRecentSearches } = useStore();
  const inputRef = useRef<HTMLInputElement>(null);
  const results = searchProducts(q);
  const popular = products.filter((p) => !p.soldOut).slice(0, 4);

  useEffect(() => {
    inputRef.current?.focus();
  }, []);

  const run = (value: string) => {
    setInput(value);
    if (value.trim()) addRecentSearch(value);
    setParams(value.trim() ? { q: value.trim() } : {});
  };

  return (
    <div className="bg-white">
      <div className="border-b border-hairline bg-cream">
        <div className="mx-auto max-w-3xl px-5 py-10 md:py-16">
          <h1 className="sr-only">Search</h1>
          <form
            role="search"
            onSubmit={(e) => {
              e.preventDefault();
              run(input);
            }}
            className="flex items-center gap-3 border-b border-ink pb-3">
            
            <SearchIcon className="h-5 w-5 shrink-0" strokeWidth={1.5} />
            <label htmlFor="site-search" className="sr-only">Search products</label>
            <input
              ref={inputRef}
              id="site-search"
              type="search"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              placeholder="Search hoodies, verses, colors…"
              className="min-w-0 flex-1 bg-transparent font-serif text-[24px] outline-none placeholder:text-stone md:text-[32px] [&::-webkit-search-cancel-button]:hidden" />
            
            {input &&
            <button type="button" onClick={() => run('')} aria-label="Clear search" className="p-1 text-stone hover:text-ink">
                <XIcon className="h-5 w-5" />
              </button>
            }
          </form>

          {!q &&
          <div className="mt-8 grid gap-8 sm:grid-cols-2">
              <div>
                <div className="flex items-center justify-between">
                  <h2 className="flex items-center gap-2 text-[12px] font-medium uppercase tracking-[0.14em]">
                    <HistoryIcon className="h-4 w-4" /> Recent
                  </h2>
                  {recentSearches.length > 0 &&
                <button onClick={clearRecentSearches} className="text-[12px] text-stone underline underline-offset-4 hover:text-ink">
                      Clear
                    </button>
                }
                </div>
                {recentSearches.length ?
              <ul className="mt-3 space-y-1">
                    {recentSearches.map((s) =>
                <li key={s}>
                        <button onClick={() => run(s)} className="py-1 text-[15px] capitalize text-ink/75 hover:text-ink">
                          {s}
                        </button>
                      </li>
                )}
                  </ul> :

              <p className="mt-3 text-[14px] text-stone">No recent searches.</p>
              }
              </div>
              <div>
                <h2 className="flex items-center gap-2 text-[12px] font-medium uppercase tracking-[0.14em]">
                  <TrendingUpIcon className="h-4 w-4" /> Trending
                </h2>
                <div className="mt-3 flex flex-wrap gap-2">
                  {trending.map((t) =>
                <button key={t} onClick={() => run(t)} className="h-9 border border-hairline bg-white px-3.5 text-[13px] transition-colors hover:border-ink">
                      {t}
                    </button>
                )}
                </div>
              </div>
            </div>
          }
        </div>
      </div>

      <div className="mx-auto max-w-site px-5 py-12 md:px-8 md:py-16">
        {!q ?
        <>
            <h2 className="font-serif text-[24px] uppercase tracking-[0.06em]">Popular right now</h2>
            <div className="mt-8 grid grid-cols-2 gap-x-3 gap-y-10 md:grid-cols-4 md:gap-x-6">
              {popular.map((p) => <ProductCard key={p.id} product={p} />)}
            </div>
          </> :
        results.length > 0 ?
        <>
            <p className="text-[14px] text-stone" aria-live="polite">
              {results.length} {results.length === 1 ? 'result' : 'results'} for <span className="text-ink">“{q}”</span>
            </p>
            <div className="mt-8 grid grid-cols-2 gap-x-3 gap-y-10 md:grid-cols-3 md:gap-x-6 lg:grid-cols-4">
              {results.map((p) => <ProductCard key={p.id} product={p} />)}
            </div>
          </> :

        <div className="mx-auto max-w-xl py-8 text-center">
            <h2 className="font-serif text-[30px]">No results for “{q}”</h2>
            <p className="mt-3 text-[15px] text-ink/65">Check the spelling, try a broader word, or start from one of these.</p>
            <ul className="mt-8 flex flex-wrap justify-center gap-2">
              {suggestedCategories.map((c) =>
            <li key={c.to}>
                  <Link to={c.to} className="flex h-10 items-center border border-hairline px-4 text-[13px] transition-colors hover:border-ink">
                    {c.label}
                  </Link>
                </li>
            )}
            </ul>
          </div>
        }
      </div>
    </div>);

}