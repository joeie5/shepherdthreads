import React from 'react';
import { Link } from 'react-router-dom';
import { ArrowRightIcon } from 'lucide-react';

interface SectionHeadingProps {
  title: string;
  description?: string;
  linkLabel?: string;
  linkTo?: string;
  tone?: 'light' | 'dark';
}

export function SectionHeading({ title, description, linkLabel, linkTo, tone = 'light' }: SectionHeadingProps) {
  return (
    <div className="flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
      <div className="max-w-xl">
        <h2 className="font-serif text-[28px] uppercase leading-tight tracking-[0.06em] md:text-[36px]">{title}</h2>
        {description && <p className={`mt-3 text-[15px] ${tone === 'dark' ? 'text-white/65' : 'text-ink/65'}`}>{description}</p>}
      </div>
      {linkLabel && linkTo &&
      <Link to={linkTo} className="group inline-flex items-center gap-2 text-[12px] font-medium uppercase tracking-[0.14em]">
          <span className="underline decoration-1 underline-offset-[6px]">{linkLabel}</span>
          <ArrowRightIcon className="h-4 w-4 transition-transform duration-200 ease-out group-hover:translate-x-1" />
        </Link>
      }
    </div>);

}