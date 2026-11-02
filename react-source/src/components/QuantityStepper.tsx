import React from 'react';
import { MinusIcon, PlusIcon } from 'lucide-react';

interface QuantityStepperProps {
  value: number;
  onChange: (v: number) => void;
  label: string;
  min?: number;
  max?: number;
}

export function QuantityStepper({ value, onChange, label, min = 1, max = 10 }: QuantityStepperProps) {
  return (
    <div className="inline-flex h-9 items-center border border-hairline" role="group" aria-label={`Quantity for ${label}`}>
      <button
        type="button"
        onClick={() => onChange(value - 1)}
        disabled={value <= min}
        aria-label="Decrease quantity"
        className="flex h-full w-9 items-center justify-center text-ink transition-colors hover:bg-cream disabled:text-stone/50 disabled:hover:bg-transparent">
        
        <MinusIcon className="h-3.5 w-3.5" />
      </button>
      <span className="w-8 text-center text-[13px] tabular-nums" aria-live="polite">
        {value}
      </span>
      <button
        type="button"
        onClick={() => onChange(value + 1)}
        disabled={value >= max}
        aria-label="Increase quantity"
        className="flex h-full w-9 items-center justify-center text-ink transition-colors hover:bg-cream disabled:text-stone/50 disabled:hover:bg-transparent">
        
        <PlusIcon className="h-3.5 w-3.5" />
      </button>
    </div>);

}