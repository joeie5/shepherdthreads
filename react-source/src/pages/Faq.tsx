import React, { useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import { AccordionItem } from '../components/Accordion';
import { ButtonLink } from '../components/Button';
import { faqGroups } from '../data/faq';

export function Faq() {
  const { hash } = useLocation();

  useEffect(() => {
    if (!hash) return;
    const el = document.getElementById(hash.slice(1));
    if (el) window.setTimeout(() => el.scrollIntoView({ behavior: 'smooth', block: 'start' }), 50);
  }, [hash]);

  return (
    <div className="bg-white">
      <header className="bg-ink text-white">
        <div className="mx-auto max-w-site px-5 py-14 md:px-8 md:py-20">
          <h1 className="font-serif text-[40px] uppercase tracking-[0.06em] md:text-[56px]">FAQ</h1>
          <p className="mt-3 max-w-lg text-[15px] text-white/65">Answers on shipping, returns, fit — and the faith behind what we make.</p>
        </div>
      </header>

      <div className="mx-auto grid max-w-site gap-10 px-5 py-12 md:px-8 md:py-20 lg:grid-cols-[220px_1fr] lg:gap-20">
        <nav aria-label="FAQ topics" className="-mx-5 px-5 lg:mx-0 lg:px-0">
          <ul className="scrollbar-none flex gap-2 overflow-x-auto lg:sticky lg:top-28 lg:flex-col lg:gap-1">
            {faqGroups.map((g) =>
            <li key={g.id} className="shrink-0">
                <a href={`#${g.id}`} className="block whitespace-nowrap border border-hairline px-4 py-2 text-[13px] transition-colors hover:border-ink lg:border-0 lg:px-0 lg:py-2 lg:text-[14px] lg:text-ink/70 lg:hover:text-ink">
                  {g.title}
                </a>
              </li>
            )}
          </ul>
        </nav>

        <div className="max-w-3xl space-y-16">
          {faqGroups.map((g) =>
          <section key={g.id} id={g.id} className="scroll-mt-28" aria-labelledby={`${g.id}-title`}>
              <h2 id={`${g.id}-title`} className="font-serif text-[26px] uppercase tracking-[0.06em]">{g.title}</h2>
              <div className="mt-4 border-t border-ink">
                {g.items.map((item) =>
              <AccordionItem key={item.q} title={item.q}>
                    <p>{item.a}</p>
                  </AccordionItem>
              )}
              </div>
            </section>
          )}

          <section className="bg-cream p-8 md:p-10">
            <h2 className="font-serif text-[26px]">Still have a question?</h2>
            <p className="mt-2 text-[15px] text-ink/65">Our team replies within one business day.</p>
            <ButtonLink to="/contact" className="mt-6">Contact us</ButtonLink>
          </section>
        </div>
      </div>
    </div>);

}