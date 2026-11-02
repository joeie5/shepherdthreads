import React from 'react';
import { Link } from 'react-router-dom';
import { XIcon } from 'lucide-react';
import { Drawer } from './Drawer';
import { Logo } from './Logo';
import { primaryNav, footerBrandLinks, verseOfTheMonth } from '../data/navigation';

interface MobileMenuProps {
  open: boolean;
  onClose: () => void;
}

export function MobileMenu({ open, onClose }: MobileMenuProps) {
  return (
    <Drawer open={open} onClose={onClose} side="left" label="Menu" tone="dark">
      <div className="flex items-center justify-between px-5 py-4">
        <Logo showTagline={false} />
        <button onClick={onClose} aria-label="Close menu" className="-mr-2 p-2 text-white/70 hover:text-white">
          <XIcon className="h-5 w-5" />
        </button>
      </div>
      <nav aria-label="Mobile primary" className="flex-1 overflow-y-auto px-5 pt-6">
        <ul className="space-y-1">
          {primaryNav.map((item) =>
          <li key={item.to}>
              <Link to={item.to} onClick={onClose} className="block py-2 font-serif text-[32px] leading-tight">
                {item.label}
              </Link>
            </li>
          )}
        </ul>
        <ul className="mt-10 space-y-3 border-t border-white/15 pt-8">
          {footerBrandLinks.slice(2).map((item) =>
          <li key={item.to}>
              <Link to={item.to} onClick={onClose} className="text-[14px] text-white/70 hover:text-white">
                {item.label}
              </Link>
            </li>
          )}
        </ul>
      </nav>
      <div className="border-t border-white/15 px-5 py-6">
        <p className="font-serif text-[15px] italic leading-snug text-white/80">“{verseOfTheMonth.text}”</p>
        <p className="mt-2 text-[11px] uppercase tracking-[0.16em] text-stone">{verseOfTheMonth.reference}</p>
      </div>
    </Drawer>);

}