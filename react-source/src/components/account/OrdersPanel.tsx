import React from 'react';
import { Link } from 'react-router-dom';
import { ChevronRightIcon } from 'lucide-react';
import { StatusBadge } from './StatusBadge';
import { orders } from '../../data/account';
import { formatPrice } from '../../utils/currency';
import { getColor, getProduct } from '../../utils/products';

export function OrdersPanel() {
  return (
    <section>
      <h2 className="font-serif text-[24px]">Order history</h2>
      <ul className="mt-6 divide-y divide-hairline border-y border-hairline">
        {orders.map((o) => {
          const total = o.items.reduce((s, i) => s + i.price * i.qty, 0) + o.shipping + o.tax - o.discount;
          const count = o.items.reduce((n, i) => n + i.qty, 0);
          return (
            <li key={o.id}>
              <Link to={`/account/orders/${o.id}`} className="group flex flex-col gap-4 py-6 transition-colors sm:flex-row sm:items-center sm:gap-6">
                <div className="flex -space-x-3">
                  {o.items.map((i) => {
                    const p = getProduct(i.productId);
                    if (!p) return null;
                    return (
                      <img key={i.productId} src={getColor(p, i.color).images[0]} alt={p.name} className="h-20 w-16 border-2 border-white bg-cream object-cover" />);

                  })}
                </div>
                <div className="flex-1">
                  <div className="flex flex-wrap items-center gap-3">
                    <p className="text-[15px] font-medium">{o.id}</p>
                    <StatusBadge status={o.status} />
                  </div>
                  <p className="mt-1.5 text-[13px] text-stone">
                    Placed {o.placedOn} · {count} {count === 1 ? 'item' : 'items'} · {formatPrice(Math.round(total * 100) / 100)}
                  </p>
                  <p className="mt-1 text-[13px] text-ink/75">
                    {o.status === 'Delivered' ? `Delivered ${o.estimatedDelivery}` : `Arrives by ${o.estimatedDelivery}`}
                  </p>
                </div>
                <span className="flex items-center gap-1 text-[13px] underline-offset-4 group-hover:underline">
                  View order <ChevronRightIcon className="h-4 w-4" />
                </span>
              </Link>
            </li>);

        })}
      </ul>
    </section>);

}