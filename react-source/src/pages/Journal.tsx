import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { ArrowRightIcon } from 'lucide-react';
import { JournalCard } from '../components/JournalCard';
import { journalPosts } from '../data/journal';
import type { JournalCategory } from '../types/content';

const filters: ('All' | JournalCategory)[] = ['All', 'Devotional', 'Style', 'Behind the Seams', 'Community'];

export function Journal() {
  const [active, setActive] = useState<'All' | JournalCategory>('All');
  const featured = journalPosts.find((p) => p.featured) ?? journalPosts[0];
  const rest = journalPosts.filter((p) => p.slug !== featured.slug && (active === 'All' || p.category === active));

  return (
    <div className="bg-white">
      <header className="mx-auto max-w-site px-5 pb-10 pt-12 md:px-8 md:pt-16">
        <h1 className="font-serif text-[44px] uppercase tracking-[0.06em] md:text-[64px]">Journal</h1>
        <p className="mt-3 max-w-lg text-[15px] text-ink/65">Devotionals, style notes, and stories from the people behind the thread.</p>
      </header>

      {/* Featured */}
      <section className="bg-ink text-white">
        <Link to={`/journal/${featured.slug}`} className="group mx-auto grid max-w-site md:grid-cols-2">
          <div className="aspect-[4/3] overflow-hidden md:aspect-auto md:min-h-[520px]">
            <img src={featured.image} alt="" className="h-full w-full object-cover" />
          </div>
          <div className="flex flex-col justify-center px-5 py-12 md:px-14">
            <p className="text-[12px] text-white/55">Featured · {featured.category} · {featured.readTime}</p>
            <h2 className="mt-4 font-serif text-[32px] leading-tight md:text-[48px]">{featured.title}</h2>
            <p className="mt-5 max-w-md text-[16px] leading-relaxed text-white/70">{featured.excerpt}</p>
            <span className="mt-8 inline-flex items-center gap-2 text-[12px] font-medium uppercase tracking-[0.14em]">
              <span className="underline underline-offset-[6px]">Read the story</span>
              <ArrowRightIcon className="h-4 w-4 transition-transform duration-200 ease-out group-hover:translate-x-1" />
            </span>
          </div>
        </Link>
      </section>

      <section className="mx-auto max-w-site px-5 py-14 md:px-8 md:py-20">
        <div className="scrollbar-none -mx-5 flex gap-2 overflow-x-auto px-5 md:mx-0 md:px-0" role="tablist" aria-label="Filter articles">
          {filters.map((f) =>
          <button
            key={f}
            role="tab"
            aria-selected={active === f}
            onClick={() => setActive(f)}
            className={`h-9 shrink-0 whitespace-nowrap px-4 text-[13px] transition-colors ${active === f ? 'bg-ink text-white' : 'border border-hairline hover:border-ink'}`}>
            
              {f}
            </button>
          )}
        </div>
        {rest.length === 0 ?
        <p className="mt-12 text-[15px] text-stone">No other stories in this category yet — check back soon.</p> :

        <div className="mt-10 grid gap-x-6 gap-y-14 sm:grid-cols-2 lg:grid-cols-3">
            {rest.map((p) => <JournalCard key={p.slug} post={p} />)}
          </div>
        }
      </section>
    </div>);

}