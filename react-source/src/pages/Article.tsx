import React from 'react';
import { Link, useParams } from 'react-router-dom';
import { ArrowLeftIcon } from 'lucide-react';
import { JournalCard } from '../components/JournalCard';
import { ProductCard } from '../components/ProductCard';
import { NotFound } from './NotFound';
import { journalPosts } from '../data/journal';
import { products } from '../data/products';

export function Article() {
  const { slug } = useParams();
  const post = journalPosts.find((p) => p.slug === slug);
  if (!post) return <NotFound />;
  const related = journalPosts.filter((p) => p.slug !== post.slug).slice(0, 3);
  const shopTheStory = products.filter((p) => !p.soldOut).slice(0, 2);
  const [first, ...remaining] = post.body;

  return (
    <article className="bg-white">
      <header className="mx-auto max-w-3xl px-5 pb-10 pt-10 text-center md:pt-16">
        <Link to="/journal" className="inline-flex items-center gap-2 text-[13px] text-stone hover:text-ink">
          <ArrowLeftIcon className="h-4 w-4" /> Journal
        </Link>
        <p className="mt-8 text-[12px] text-stone">{post.category}</p>
        <h1 className="mt-3 font-serif text-[36px] leading-[1.1] md:text-[56px]">{post.title}</h1>
        <p className="mt-6 text-[13px] text-stone">
          By <span className="text-ink">{post.author}</span> · {post.date} · {post.readTime}
        </p>
      </header>

      <img src={post.image} alt="" className="aspect-[16/9] w-full object-cover md:aspect-[21/9]" />

      <div className="mx-auto max-w-[680px] px-5 py-14 md:py-20">
        <p className="font-serif text-[22px] leading-[1.6] md:text-[24px]">{first}</p>
        {remaining.slice(0, 1).map((para) =>
        <p key={para} className="mt-7 font-serif text-[19px] leading-[1.75] text-ink/85">{para}</p>
        )}
        {post.pullQuote &&
        <figure className="my-12 border-y border-ink py-10 text-center">
            <blockquote className="font-serif text-[28px] italic leading-snug md:text-[34px]">“{post.pullQuote.text}”</blockquote>
            <figcaption className="mt-4 text-[12px] uppercase tracking-[0.2em] text-stone">{post.pullQuote.reference}</figcaption>
          </figure>
        }
        {remaining.slice(1).map((para) =>
        <p key={para} className="mt-7 font-serif text-[19px] leading-[1.75] text-ink/85">{para}</p>
        )}
      </div>

      <section className="bg-cream">
        <div className="mx-auto grid max-w-site gap-10 px-5 py-16 md:grid-cols-[1fr_2fr] md:items-center md:px-8">
          <div>
            <h2 className="font-serif text-[28px] uppercase tracking-[0.06em]">Shop the story</h2>
            <p className="mt-3 text-[15px] text-ink/65">The pieces featured in this article.</p>
          </div>
          <div className="grid grid-cols-2 gap-3 md:gap-6">
            {shopTheStory.map((p) => <ProductCard key={p.id} product={p} />)}
          </div>
        </div>
      </section>

      <section className="mx-auto max-w-site px-5 py-16 md:px-8 md:py-24">
        <h2 className="font-serif text-[28px] uppercase tracking-[0.06em] md:text-[36px]">Keep reading</h2>
        <div className="mt-10 grid gap-x-6 gap-y-14 sm:grid-cols-2 lg:grid-cols-3">
          {related.map((p) => <JournalCard key={p.slug} post={p} />)}
        </div>
      </section>
    </article>);

}