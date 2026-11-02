import React, { useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { ArrowLeftIcon, CheckIcon, ExternalLinkIcon } from 'lucide-react';
import { useStore } from '../contexts/StoreContext';
import { AccountShell } from '../components/account/AccountShell';
import { StatusBadge } from '../components/account/StatusBadge';
import { Button } from '../components/Button';
import { NotFound } from './NotFound';
import { orders } from '../data/account';
import { formatPrice } from '../utils/currency';
import { getColor, getProduct } from '../utils/products';

export function OrderDetail() {
  const { orderId } = useParams();
  const order = orders.find((o) => o.id === orderId);
  const { addToCart } = useStore();
  const [reordered, setReordered] = useState(false);
  if (!order) return <NotFound />;

  const subtotal = order.items.reduce((s, i) => s + i.price * i.qty, 0);
  const total = Math.round((subtotal + order.shipping + order.tax - order.discount) * 100) / 100;

  return (
    <AccountShell active="orders">
      <Link to="/account/orders" className="inline-flex items-center gap-2 text-[13px] text-stone hover:text-ink">
        <ArrowLeftIcon className="h-4 w-4" /> All orders
      </Link>
      <div className="mt-4 flex flex-wrap items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-3">
            <h2 className="font-serif text-[28px]">Order {order.id}</h2>
            <StatusBadge status={order.status} />
          </div>
          <p className="mt-1 text-[13px] text-stone">Placed {order.placedOn}</p>
        </div>
        <div className="flex gap-3">
          <Button
            variant={reordered ? 'outline' : 'primary'}
            onClick={() => {
              order.items.forEach((i) => addToCart(i.productId, i.color, i.size, i.qty));
              setReordered(true);
            }}>
            
            {reordered ? <><CheckIcon className="h-4 w-4" /> Added to bag</> : 'Reorder'}
          </Button>
        </div>
      </div>

      {/* Progress */}
      <section aria-label="Delivery progress" className="mt-10 bg-cream p-6 md:p-8">
        <div className="flex flex-wrap items-baseline justify-between gap-2">
          <p className="text-[15px] font-medium">
            {order.status === 'Delivered' ? `Delivered ${order.estimatedDelivery}` : `Estimated delivery ${order.estimatedDelivery}`}
          </p>
          {order.trackingNumber &&
          <a href="https://www.ups.com/track" target="_blank" rel="noreferrer" className="inline-flex items-center gap-1.5 text-[13px] underline underline-offset-4">
              Track with {order.carrier} <ExternalLinkIcon className="h-3.5 w-3.5" />
            </a>
          }
        </div>
        <ol className="mt-6 grid grid-cols-4 gap-2">
          {order.timeline.map((t) =>
          <li key={t.label}>
              <span className={`block h-[2px] ${t.done ? 'bg-ink' : 'bg-hairline'}`} />
              <p className={`mt-3 text-[12px] sm:text-[13px] ${t.done ? 'text-ink' : 'text-stone'}`}>{t.label}</p>
              {t.date && <p className="text-[12px] text-stone">{t.date}</p>}
            </li>
          )}
        </ol>
        {order.trackingNumber && <p className="mt-6 text-[12px] text-stone">Tracking number: {order.trackingNumber}</p>}
      </section>

      <div className="mt-10 grid gap-10 xl:grid-cols-[1fr_300px]">
        <section aria-label="Items">
          <h3 className="text-[12px] font-medium uppercase tracking-[0.14em]">Items</h3>
          <ul className="mt-3 divide-y divide-hairline border-y border-hairline">
            {order.items.map((i) => {
              const p = getProduct(i.productId);
              if (!p) return null;
              const c = getColor(p, i.color);
              return (
                <li key={`${i.productId}-${i.size}`} className="flex gap-4 py-5">
                  <Link to={`/product/${p.id}`} className="h-[120px] w-24 shrink-0 bg-cream">
                    <img src={c.images[0]} alt={p.name} className="h-full w-full object-cover" />
                  </Link>
                  <div className="flex flex-1 justify-between gap-4">
                    <div>
                      <Link to={`/product/${p.id}`} className="text-[14px] font-medium hover:underline">{p.name}</Link>
                      <p className="mt-1 text-[13px] text-stone">{c.name} · {i.size} · Qty {i.qty}</p>
                      {order.status === 'Delivered' &&
                      <Link to="/contact" className="mt-3 inline-block text-[13px] underline underline-offset-4">Start a return</Link>
                      }
                    </div>
                    <p className="text-[14px] tabular-nums">{formatPrice(i.price * i.qty)}</p>
                  </div>
                </li>);

            })}
          </ul>
        </section>

        <div className="space-y-8 text-[14px]">
          <section>
            <h3 className="text-[12px] font-medium uppercase tracking-[0.14em]">Shipping address</h3>
            <address className="mt-3 not-italic leading-relaxed text-ink/75">
              {order.address.name}
              <br />
              {order.address.line1}{order.address.line2 ? `, ${order.address.line2}` : ''}
              <br />
              {order.address.city}, {order.address.state} {order.address.zip}
            </address>
          </section>
          <section>
            <h3 className="text-[12px] font-medium uppercase tracking-[0.14em]">Payment</h3>
            <p className="mt-3 text-ink/75">{order.payment}</p>
          </section>
          <section>
            <h3 className="text-[12px] font-medium uppercase tracking-[0.14em]">Summary</h3>
            <dl className="mt-3 space-y-2">
              <div className="flex justify-between"><dt className="text-ink/70">Subtotal</dt><dd>{formatPrice(subtotal)}</dd></div>
              {order.discount > 0 && <div className="flex justify-between"><dt className="text-ink/70">Discount</dt><dd className="text-brass">−{formatPrice(order.discount)}</dd></div>}
              <div className="flex justify-between"><dt className="text-ink/70">Shipping</dt><dd>{order.shipping ? formatPrice(order.shipping) : 'Free'}</dd></div>
              <div className="flex justify-between"><dt className="text-ink/70">Tax</dt><dd>{formatPrice(order.tax)}</dd></div>
              <div className="flex justify-between border-t border-hairline pt-3 font-medium"><dt>Total</dt><dd>{formatPrice(total)}</dd></div>
            </dl>
          </section>
          <p className="text-[13px] text-stone">
            Need help with this order? <Link to="/contact" className="text-ink underline underline-offset-4">Contact us</Link>
          </p>
        </div>
      </div>
    </AccountShell>);

}