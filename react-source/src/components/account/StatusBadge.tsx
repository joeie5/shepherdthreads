import React from 'react';
import type { OrderStatus } from '../../types/commerce';

const styles: Record<OrderStatus, string> = {
  Processing: 'border border-stone/60 text-ink',
  Shipped: 'bg-ink text-white',
  Delivered: 'bg-cream text-ink'
};

export function StatusBadge({ status }: {status: OrderStatus;}) {
  return (
    <span className={`inline-flex h-6 items-center gap-1.5 px-2.5 text-[11px] font-medium uppercase tracking-[0.1em] ${styles[status]}`}>
      <span className={`h-1.5 w-1.5 rounded-full ${status === 'Delivered' ? 'bg-brass' : status === 'Shipped' ? 'bg-white' : 'bg-stone'}`} aria-hidden="true" />
      {status}
    </span>);

}