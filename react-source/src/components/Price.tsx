import React from 'react';
import { formatPrice } from '../utils/currency';

interface PriceProps {
  price: number;
  compareAt?: number;
  className?: string;
}

export function Price({ price, compareAt, className = '' }: PriceProps) {
  if (compareAt) {
    return (
      <span className={`inline-flex items-baseline gap-2 ${className}`}>
        <span className="text-brass">{formatPrice(price)}</span>
        <span className="text-stone line-through">
          <span className="sr-only">Was </span>
          {formatPrice(compareAt)}
        </span>
      </span>);

  }
  return <span className={className}>{formatPrice(price)}</span>;
}