import React, { useState } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { ChevronDownIcon } from 'lucide-react';
import { useStore } from '../../contexts/StoreContext';
import { PromoField, Totals } from '../OrderSummary';
import { calcTotals, formatPrice } from '../../utils/currency';
import { getColor, getProduct } from '../../utils/products';

interface CheckoutSummaryProps {
  shippingPrice: number;
  shippingLabel: string;
}

function SummaryBody({ shippingPrice, shippingLabel }: CheckoutSummaryProps) {
  const { cart } = useStore();
  return (
    <>
      <ul className="space-y-4">
        {cart.map((item) => {
          const p = getProduct(item.productId);
          if (!p) return null;
          const c = getColor(p, item.color);
          return (
            <li key={item.key} className="flex items-center gap-4">
              <div className="relative h-20 w-16 shrink-0 bg-white">
                <img src={c.images[0]} alt="" className="h-full w-full object-cover" />
                <span className="absolute -right-2 -top-2 flex h-5 min-w-5 items-center justify-center rounded-full bg-ink px-1 text-[10px] font-semibold text-white">{item.qty}</span>
              </div>
              <div className="min-w-0 flex-1">
                <p className="truncate text-[14px] font-medium">{p.name}</p>
                <p className="text-[12px] text-stone">{c.name} · {item.size}</p>
              </div>
              <p className="text-[14px] tabular-nums">{formatPrice(p.price * item.qty)}</p>
            </li>);

        })}
      </ul>
      <div className="mt-6 border-t border-hairline pt-6">
        <PromoField id="checkout-promo" />
      </div>
      <div className="mt-6 border-t border-hairline pt-6">
        <Totals shippingPrice={shippingPrice} shippingLabel={shippingLabel} />
      </div>
    </>);

}

export function CheckoutSummary({ variant, ...props }: CheckoutSummaryProps & {variant: 'mobile' | 'desktop';}) {
  const [open, setOpen] = useState(false);
  const { subtotal, promo } = useStore();
  const { total } = calcTotals(subtotal, promo?.percentOff ?? 0, props.shippingPrice);

  if (variant === 'desktop') {
    return (
      <aside aria-label="Order summary" className="hidden lg:block">
        <div className="sticky top-28 bg-cream p-8">
          <h2 className="mb-6 font-serif text-[22px] uppercase tracking-[0.06em]">Order Summary</h2>
          <SummaryBody {...props} />
        </div>
      </aside>);

  }

  return (
    <>
      {/* Mobile collapsible */}
      <div className="border-b border-hairline bg-cream lg:hidden">
        <button onClick={() => setOpen((o) => !o)} aria-expanded={open} className="flex w-full items-center justify-between px-5 py-4 text-[14px]">
          <span className="flex items-center gap-2 underline underline-offset-4">
            {open ? 'Hide' : 'Show'} order summary
            <ChevronDownIcon className={`h-4 w-4 transition-transform duration-200 ${open ? 'rotate-180' : ''}`} />
          </span>
          <span className="font-medium tabular-nums">{formatPrice(total)}</span>
        </button>
        <AnimatePresence initial={false}>
          {open &&
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: 'auto', opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            transition={{ duration: 0.25, ease: [0.23, 1, 0.32, 1] }}
            className="overflow-hidden">
            
              <div className="px-5 pb-6 pt-2">
                <SummaryBody {...props} />
              </div>
            </motion.div>
          }
        </AnimatePresence>
      </div>
    </>);

}