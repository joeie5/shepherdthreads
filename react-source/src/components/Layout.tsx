import React, { useEffect, useState } from 'react';
import { Outlet, useLocation } from 'react-router-dom';
import { Header } from './Header';
import { Footer } from './Footer';
import { MobileTabBar } from './MobileTabBar';
import { MobileMenu } from './MobileMenu';
import { CartDrawer } from './CartDrawer';

export function Layout() {
  const [menuOpen, setMenuOpen] = useState(false);
  const { pathname } = useLocation();
  const minimal = pathname.startsWith('/checkout');

  useEffect(() => {
    window.scrollTo(0, 0);
    setMenuOpen(false);
  }, [pathname]);

  return (
    <div className="flex min-h-screen w-full flex-col bg-white text-ink">
      <a href="#main" className="sr-only focus:not-sr-only focus:fixed focus:left-4 focus:top-4 focus:z-[80] focus:bg-white focus:px-4 focus:py-2">
        Skip to content
      </a>
      {!minimal &&
      <div className="bg-cream py-2 text-center text-[11px] tracking-[0.08em] text-ink sm:text-[12px]">
          Free U.S. shipping over $150 · Free 30-day returns
        </div>
      }
      <Header onOpenMenu={() => setMenuOpen(true)} />
      <main id="main" className="flex-1 pb-16 md:pb-0">
        <Outlet />
      </main>
      {!minimal &&
      <div className="pb-16 md:pb-0 bg-ink">
          <Footer />
        </div>
      }
      <MobileTabBar />
      <MobileMenu open={menuOpen} onClose={() => setMenuOpen(false)} />
      <CartDrawer />
    </div>);

}