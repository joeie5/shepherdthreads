import React from 'react';
import { NavLink } from 'react-router-dom';
import { HouseIcon, SearchIcon, ShoppingBagIcon, StoreIcon, UserIcon } from 'lucide-react';
import { useStore } from '../contexts/StoreContext';

const tabs = [
{ label: 'Home', to: '/', icon: HouseIcon, end: true },
{ label: 'Shop', to: '/shop', icon: StoreIcon, end: false },
{ label: 'Search', to: '/search', icon: SearchIcon, end: false },
{ label: 'Cart', to: '/cart', icon: ShoppingBagIcon, end: false },
{ label: 'Account', to: '/account', icon: UserIcon, end: false }];


export function MobileTabBar() {
  const { cartCount } = useStore();
  return (
    <nav
      aria-label="Tab bar"
      className="fixed inset-x-0 bottom-0 z-40 border-t border-white/10 bg-ink text-white md:hidden"
      style={{ paddingBottom: 'env(safe-area-inset-bottom)' }}>
      
      <ul className="grid h-16 grid-cols-5">
        {tabs.map(({ label, to, icon: Icon, end }) =>
        <li key={to}>
            <NavLink
            to={to}
            end={end}
            className={({ isActive }) =>
            `relative flex h-full flex-col items-center justify-center gap-1 text-[10px] tracking-[0.06em] transition-colors ${
            isActive ? 'text-white' : 'text-white/50'}`

            }>
            
              {({ isActive }) =>
            <>
                  <span className="relative">
                    <Icon className="h-5 w-5" strokeWidth={isActive ? 1.9 : 1.5} />
                    {label === 'Cart' && cartCount > 0 &&
                <span className="absolute -right-2 -top-1.5 flex h-4 min-w-4 items-center justify-center rounded-full bg-white px-1 text-[9px] font-semibold text-ink">
                        {cartCount}
                      </span>
                }
                  </span>
                  <span>{label}</span>
                  {isActive && <span className="absolute top-0 h-[2px] w-6 bg-brass" aria-hidden="true" />}
                </>
            }
            </NavLink>
          </li>
        )}
      </ul>
    </nav>);

}