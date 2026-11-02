import React from 'react';
import { Link } from 'react-router-dom';
import { Logo } from './Logo';
import { NewsletterForm } from './NewsletterForm';
import { InstagramGlyph, PaymentRow, TiktokGlyph, YoutubeGlyph } from './BrandIcons';
import { footerBrandLinks, footerShopLinks, verseOfTheMonth } from '../data/navigation';

const socials = [
{ label: 'Instagram', href: 'https://instagram.com', Icon: InstagramGlyph },
{ label: 'TikTok', href: 'https://tiktok.com', Icon: TiktokGlyph },
{ label: 'YouTube', href: 'https://youtube.com', Icon: YoutubeGlyph }];


export function Footer() {
  return (
    <footer className="border-t border-white/10 bg-ink text-white">
      <div className="mx-auto max-w-site px-5 pb-10 pt-16 md:px-8 md:pt-20">
        <div className="grid gap-12 lg:grid-cols-12">
          <div className="lg:col-span-4">
            <Logo />
            <figure className="mt-10 max-w-sm">
              <figcaption className="text-[11px] uppercase tracking-[0.18em] text-stone">Verse of the month · {verseOfTheMonth.month}</figcaption>
              <blockquote className="mt-3 font-serif text-[22px] italic leading-snug text-white/90">“{verseOfTheMonth.text}”</blockquote>
              <p className="mt-3 text-[13px] text-white/60">{verseOfTheMonth.reference}</p>
            </figure>
          </div>

          <div className="grid grid-cols-2 gap-8 lg:col-span-4">
            <div>
              <h2 className="text-[11px] uppercase tracking-[0.18em] text-stone">Shop</h2>
              <ul className="mt-4 space-y-3">
                {footerShopLinks.map((l) =>
                <li key={l.to}>
                    <Link to={l.to} className="text-[14px] text-white/75 transition-colors hover:text-white">
                      {l.label}
                    </Link>
                  </li>
                )}
              </ul>
            </div>
            <div>
              <h2 className="text-[11px] uppercase tracking-[0.18em] text-stone">Shepherds Thread</h2>
              <ul className="mt-4 space-y-3">
                {footerBrandLinks.map((l) =>
                <li key={l.to}>
                    <Link to={l.to} className="text-[14px] text-white/75 transition-colors hover:text-white">
                      {l.label}
                    </Link>
                  </li>
                )}
              </ul>
            </div>
          </div>

          <div className="lg:col-span-4">
            <h2 className="font-serif text-[22px]">Letters from the studio</h2>
            <p className="mt-2 text-[14px] text-white/60">New releases, devotionals, and the stories behind each piece. Once a month, never more.</p>
            <div className="mt-6">
              <NewsletterForm id="footer-newsletter" />
            </div>
            <ul className="mt-8 flex gap-2">
              {socials.map(({ label, href, Icon }) =>
              <li key={label}>
                  <a href={href} target="_blank" rel="noreferrer" aria-label={label} className="flex h-10 w-10 items-center justify-center border border-white/20 text-white/75 transition-colors hover:border-white hover:text-white">
                    <Icon className="h-[18px] w-[18px]" />
                  </a>
                </li>
              )}
            </ul>
          </div>
        </div>

        <div className="mt-16 flex flex-col gap-6 border-t border-white/10 pt-8 md:flex-row md:items-center md:justify-between">
          <PaymentRow />
          <p className="text-[12px] text-white/50">© 2026 Shepherds Thread. 10% of every order supports clean water and youth mentorship.</p>
        </div>
      </div>
    </footer>);

}