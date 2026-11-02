import React from 'react';
import { Link } from 'react-router-dom';
import { LockIcon, ShoppingBagIcon } from 'lucide-react';
import { useStore } from '../contexts/StoreContext';
import { CartLineItem } from '../components/CartLineItem';
import { ButtonLink } from '../components/Button';
import { FreeShippingMeter } from '../components/FreeShippingMeter';
import { PromoField, Totals } from '../components/OrderSummary';
import { PaymentRow } from '../components/BrandIcons';
import { ProductCarousel } from '../components/product/ProductCarousel';
import { products } from '../data/products';

export function Cart() {
  const { cart, cartCount, subtotal } = useStore();
  const suggestions = products.filter((p) => !cart.some((i) => i.productId === p.id) && !p.soldOut).slice(0, 6);

  if (cart.length === 0) {
    return (
      <div className="bg-white">
        <div className="mx-auto flex max-w-xl flex-col items-center px-5 py-24 text-center md:py-32">
          <ShoppingBagIcon className="h-10 w-10 text-stone" strokeWidth={1.25} />
          <h1 className="mt-6 font-serif text-[36px] md:text-[44px]">Your bag is empty</h1>
          <p className="mt-3 text-[15px] text-ink/65">Nothing here yet. Start with our most-loved pieces — made heavy, made to last.</p>
          <div className="mt-10 flex flex-col gap-3 sm:flex-row">
            <ButtonLink to="/shop">Continue shopping</ButtonLink>
            <ButtonLink to="/account/wishlist" variant="outline">View wishlist</ButtonLink>
          </div>
        </div>
        <div className="border-t border-hairline">
          <ProductCarousel title="Most loved" products={products.filter((p) => !p.soldOut).slice(0, 6)} />
        </div>
      </div>);

  }

  return (
    <div className="bg-white">
      <div className="mx-auto max-w-site px-5 py-10 md:px-8 md:py-16">
        <h1 className="font-serif text-[36px] uppercase tracking-[0.06em] md:text-[48px]">
          Your Bag <span className="font-sans text-[16px] normal-case tracking-normal text-stone">({cartCount} {cartCount === 1 ? 'item' : 'items'})</span>
        </h1>

        <div className="mt-8 grid gap-10 lg:grid-cols-[1fr_400px] lg:gap-16">
          <section aria-label="Items in bag">
            <div className="border-y border-hairline py-4">
              <FreeShippingMeter subtotal={subtotal} />
            </div>
            <ul className="divide-y divide-hairline border-b border-hairline">
              {cart.map((item) =>
              <CartLineItem key={item.key} item={item} size="full" />
              )}
            </ul>
            <Link to="/shop" className="mt-6 inline-block text-[12px] uppercase tracking-[0.12em] underline underline-offset-4">
              Continue shopping
            </Link>
          </section>

          <aside aria-label="Order summary" className="lg:sticky lg:top-28 lg:self-start">
            <div className="bg-cream p-6 md:p-8">
              <h2 className="font-serif text-[22px] uppercase tracking-[0.06em]">Summary</h2>
              <div className="mt-6">
                <PromoField id="cart-promo" />
              </div>
              <div className="mt-6 border-t border-hairline pt-6">
                <Totals />
              </div>
              <ButtonLink to="/checkout" full size="lg" className="mt-8">
                <LockIcon className="h-4 w-4" /> Checkout
              </ButtonLink>
              <p className="mt-4 text-center text-[12px] text-stone">Guest checkout available. Secure payment.</p>
              <div className="mt-6 flex justify-center">
                <PaymentRow tone="light" />
              </div>
            </div>
          </aside>
        </div>
      </div>
      {suggestions.length > 0 &&
      <div className="border-t border-hairline">
          <ProductCarousel title="Complete the look" products={suggestions} />
        </div>
      }
    </div>);

}