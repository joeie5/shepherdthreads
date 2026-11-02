import React from 'react';
import { Link, NavLink } from 'react-router-dom';
import { MenuIcon, SearchIcon, ShoppingBagIcon, UserIcon } from 'lucide-react';
import { useStore } from '../contexts/StoreContext';
import { Logo } from './Logo';
import { primaryNav } from '../data/navigation';

interface HeaderProps {
  onOpenMenu: () => void;
}

export function Header({ onOpenMenu }: HeaderProps) {
  const { cartCount, openCart, isSignedIn } = useStore();

  return (
    <header className="sticky top-0 z-40 border-b border-white/10 bg-ink text-white">
      <div className="mx-auto grid h-16 max-w-site grid-cols-[1fr_auto_1fr] items-center px-4 md:h-[72px] md:px-8">
        <div className="flex items-center">
          <button onClick={onOpenMenu} aria-label="Open menu" className="-ml-2 p-2 md:hidden">
            <MenuIcon className="h-5 w-5" strokeWidth={1.5} />
          </button>
          <nav aria-label="Primary" className="hidden items-center gap-8 md:flex">
            {primaryNav.map((item) =>
            <NavLink
              key={item.to}
              to={item.to}
              className={({ isActive }) =>
              `text-[12px] uppercase tracking-[0.14em] transition-colors duration-150 ${
              isActive ? 'text-white underline decoration-brass decoration-1 underline-offset-[10px]' : 'text-white/65 hover:text-white'}`

              }>
              
                {item.label}
              </NavLink>
            )}
          </nav>
        </div>

        <Link to="/" aria-label="Shepherds Thread home" className="justify-self-center">
          <Logo />
        </Link>

        <div className="flex items-center justify-end gap-1 md:gap-2">
          <Link to="/search" aria-label="Search" className="hidden p-2 text-white/80 transition-colors hover:text-white md:block">
            <SearchIcon className="h-5 w-5" strokeWidth={1.5} />
          </Link>
          <Link
            to={isSignedIn ? '/account' : '/login'}
            aria-label="Account"
            className="hidden p-2 text-white/80 transition-colors hover:text-white md:block">
            
            <UserIcon className="h-5 w-5" strokeWidth={1.5} />
          </Link>
          <button onClick={openCart} aria-label={`Open bag, ${cartCount} items`} className="relative -mr-2 p-2 text-white/80 transition-colors hover:text-white">
            <ShoppingBagIcon className="h-5 w-5" strokeWidth={1.5} />
            {cartCount > 0 &&
            <span className="absolute right-0.5 top-0.5 flex h-4 min-w-4 items-center justify-center rounded-full bg-white px-1 text-[10px] font-semibold text-ink">
                {cartCount}
              </span>
            }
          </button>
        </div>
      </div>
    </header>);

}