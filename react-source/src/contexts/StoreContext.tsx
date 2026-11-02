import React, { createContext, useCallback, useContext, useMemo, useState } from 'react';
import { getProduct } from '../utils/products';
import type { CartItem, Promo } from '../types/commerce';

interface StoreContextValue {
  cart: CartItem[];
  cartCount: number;
  subtotal: number;
  addToCart: (productId: string, color: string, size: string, qty?: number) => void;
  updateQty: (key: string, qty: number) => void;
  removeItem: (key: string) => void;
  clearCart: () => void;
  isCartOpen: boolean;
  openCart: () => void;
  closeCart: () => void;
  lastAddedKey: string | null;
  wishlist: string[];
  toggleWishlist: (productId: string) => void;
  isWishlisted: (productId: string) => boolean;
  promo: Promo | null;
  applyPromo: (code: string) => boolean;
  removePromo: () => void;
  recentSearches: string[];
  addRecentSearch: (q: string) => void;
  clearRecentSearches: () => void;
  isSignedIn: boolean;
  setSignedIn: (v: boolean) => void;
}

const PROMOS: Promo[] = [
{ code: 'SHEPHERD10', percentOff: 10, label: '10% off your order' },
{ code: 'WELCOME15', percentOff: 15, label: '15% off your first order' }];


const StoreContext = createContext<StoreContextValue | null>(null);

const makeKey = (productId: string, color: string, size: string) => `${productId}__${color}__${size}`;

export function StoreProvider({ children }: {children: React.ReactNode;}) {
  const [cart, setCart] = useState<CartItem[]>([
  { key: makeKey('good-shepherd-hoodie', 'Black', 'M'), productId: 'good-shepherd-hoodie', color: 'Black', size: 'M', qty: 1 },
  { key: makeKey('psalm-23-tee', 'Cream', 'L'), productId: 'psalm-23-tee', color: 'Cream', size: 'L', qty: 1 }]
  );
  const [isCartOpen, setCartOpen] = useState(false);
  const [lastAddedKey, setLastAddedKey] = useState<string | null>(null);
  const [wishlist, setWishlist] = useState<string[]>(['still-waters-crewneck', 'threaded-crook-cap', 'cornerstone-crewneck', 'selah-beanie']);
  const [promo, setPromo] = useState<Promo | null>(null);
  const [recentSearches, setRecent] = useState<string[]>(['hoodie', 'psalm 23', 'cap']);
  const [isSignedIn, setSignedIn] = useState(true);

  const addToCart = useCallback((productId: string, color: string, size: string, qty = 1) => {
    const key = makeKey(productId, color, size);
    setCart((prev) => {
      const existing = prev.find((i) => i.key === key);
      if (existing) return prev.map((i) => i.key === key ? { ...i, qty: Math.min(10, i.qty + qty) } : i);
      return [{ key, productId, color, size, qty }, ...prev];
    });
    setLastAddedKey(key);
    setCartOpen(true);
  }, []);

  const updateQty = useCallback((key: string, qty: number) => {
    setCart((prev) => prev.map((i) => i.key === key ? { ...i, qty: Math.max(1, Math.min(10, qty)) } : i));
  }, []);

  const removeItem = useCallback((key: string) => {
    setCart((prev) => prev.filter((i) => i.key !== key));
  }, []);

  const toggleWishlist = useCallback((productId: string) => {
    setWishlist((prev) => prev.includes(productId) ? prev.filter((id) => id !== productId) : [...prev, productId]);
  }, []);

  const applyPromo = useCallback((code: string) => {
    const match = PROMOS.find((p) => p.code === code.trim().toUpperCase());
    if (match) setPromo(match);
    return Boolean(match);
  }, []);

  const addRecentSearch = useCallback((q: string) => {
    const v = q.trim().toLowerCase();
    if (!v) return;
    setRecent((prev) => [v, ...prev.filter((s) => s !== v)].slice(0, 5));
  }, []);

  const value = useMemo<StoreContextValue>(() => {
    const cartCount = cart.reduce((n, i) => n + i.qty, 0);
    const subtotal = cart.reduce((sum, i) => sum + (getProduct(i.productId)?.price ?? 0) * i.qty, 0);
    return {
      cart,
      cartCount,
      subtotal,
      addToCart,
      updateQty,
      removeItem,
      clearCart: () => setCart([]),
      isCartOpen,
      openCart: () => {
        setLastAddedKey(null);
        setCartOpen(true);
      },
      closeCart: () => setCartOpen(false),
      lastAddedKey,
      wishlist,
      toggleWishlist,
      isWishlisted: (id: string) => wishlist.includes(id),
      promo,
      applyPromo,
      removePromo: () => setPromo(null),
      recentSearches,
      addRecentSearch,
      clearRecentSearches: () => setRecent([]),
      isSignedIn,
      setSignedIn
    };
  }, [cart, addToCart, updateQty, removeItem, isCartOpen, lastAddedKey, wishlist, toggleWishlist, promo, applyPromo, recentSearches, addRecentSearch, isSignedIn]);

  return <StoreContext.Provider value={value}>{children}</StoreContext.Provider>;
}

export function useStore(): StoreContextValue {
  const ctx = useContext(StoreContext);
  if (!ctx) throw new Error('useStore must be used inside StoreProvider');
  return ctx;
}