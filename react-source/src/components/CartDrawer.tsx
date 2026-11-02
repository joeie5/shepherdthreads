import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { CheckIcon, ShoppingBagIcon, XIcon } from 'lucide-react';
import { useStore } from '../contexts/StoreContext';
import { Drawer } from './Drawer';
import { Button, ButtonLink } from './Button';
import { CartLineItem } from './CartLineItem';
import { FreeShippingMeter } from './FreeShippingMeter';
import { formatPrice } from '../utils/currency';
import { getProduct } from '../utils/products';

export function CartDrawer() {
  const { cart, cartCount, subtotal, isCartOpen, closeCart, lastAddedKey } = useStore();
  const navigate = useNavigate();
  const lastAdded = cart.find((i) => i.key === lastAddedKey);
  const lastProduct = lastAdded ? getProduct(lastAdded.productId) : undefined;

  return (
    <Drawer open={isCartOpen} onClose={closeCart} label="Shopping bag">
      <div className="flex items-center justify-between border-b border-hairline px-6 py-5">
        <h2 className="font-serif text-xl uppercase tracking-[0.08em]">
          Your Bag <span className="font-sans text-[14px] normal-case tracking-normal text-stone">({cartCount})</span>
        </h2>
        <button onClick={closeCart} aria-label="Close bag" className="-mr-2 p-2 text-ink/70 transition-colors hover:text-ink">
          <XIcon className="h-5 w-5" />
        </button>
      </div>

      {cart.length === 0 ?
      <div className="flex flex-1 flex-col items-center justify-center px-8 text-center">
          <ShoppingBagIcon className="h-8 w-8 text-stone" strokeWidth={1.25} />
          <p className="mt-5 font-serif text-2xl">Your bag is empty</p>
          <p className="mt-2 max-w-[260px] text-[14px] text-stone">Start with our signature Good Shepherd Hoodie, or browse the full collection.</p>
          <ButtonLink to="/shop" onClick={closeCart} className="mt-8">
            Continue shopping
          </ButtonLink>
        </div> :

      <>
          {lastProduct &&
        <div className="flex items-center gap-2 bg-cream px-6 py-3 text-[13px]">
              <CheckIcon className="h-4 w-4" />
              <span>
                <span className="font-medium">{lastProduct.name}</span> added to your bag
              </span>
            </div>
        }
          <div className="border-b border-hairline px-6 py-4">
            <FreeShippingMeter subtotal={subtotal} />
          </div>
          <ul className="flex-1 divide-y divide-hairline overflow-y-auto px-6">
            {cart.map((item) =>
          <CartLineItem key={item.key} item={item} onNavigate={closeCart} />
          )}
          </ul>
          <div className="border-t border-hairline px-6 pb-6 pt-5">
            <div className="flex items-baseline justify-between">
              <span className="text-[14px]">Subtotal</span>
              <span className="text-[16px] font-medium tabular-nums">{formatPrice(subtotal)}</span>
            </div>
            <p className="mt-1 text-[12px] text-stone">Shipping, taxes and promo codes calculated at checkout.</p>
            <Button
            full
            className="mt-5"
            onClick={() => {
              closeCart();
              navigate('/checkout');
            }}>
            
              Checkout
            </Button>
            <Link
            to="/cart"
            onClick={closeCart}
            className="mt-3 block text-center text-[12px] uppercase tracking-[0.12em] underline underline-offset-4">
            
              View full bag
            </Link>
          </div>
        </>
      }
    </Drawer>);

}