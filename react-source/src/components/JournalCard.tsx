import React from 'react';
import { Link } from 'react-router-dom';
import type { JournalPost } from '../types/content';

export function JournalCard({ post }: {post: JournalPost;}) {
  return (
    <article className="group flex flex-col">
      <Link to={`/journal/${post.slug}`} className="block aspect-[4/3] overflow-hidden bg-cream">
        <img src={post.image} alt="" loading="lazy" className="h-full w-full object-cover transition-transform duration-300 ease-out group-hover:scale-[1.02]" />
      </Link>
      <p className="mt-5 text-[12px] text-stone">
        {post.category} · {post.readTime}
      </p>
      <h3 className="mt-2 font-serif text-[22px] leading-snug">
        <Link to={`/journal/${post.slug}`} className="hover:underline hover:decoration-1 hover:underline-offset-4">
          {post.title}
        </Link>
      </h3>
      <p className="mt-2 line-clamp-2 text-[14px] text-ink/65">{post.excerpt}</p>
    </article>);

}