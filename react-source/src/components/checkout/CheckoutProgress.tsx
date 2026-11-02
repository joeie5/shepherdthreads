import React from 'react';
import { CheckIcon } from 'lucide-react';
import { checkoutSteps } from '../../hooks/useCheckout';

interface CheckoutProgressProps {
  step: number;
  onStepClick: (i: number) => void;
}

export function CheckoutProgress({ step, onStepClick }: CheckoutProgressProps) {
  return (
    <nav aria-label="Checkout progress">
      <ol className="grid grid-cols-4 gap-2">
        {checkoutSteps.map((label, i) => {
          const done = i < step;
          const current = i === step;
          return (
            <li key={label}>
              <button
                type="button"
                onClick={() => onStepClick(i)}
                disabled={!done}
                aria-current={current ? 'step' : undefined}
                className="group flex w-full flex-col items-start gap-2 text-left disabled:cursor-default">
                
                <span className={`h-[2px] w-full transition-colors duration-200 ${done || current ? 'bg-ink' : 'bg-hairline'}`} />
                <span className={`flex items-center gap-1.5 text-[12px] sm:text-[13px] ${current ? 'font-medium text-ink' : done ? 'text-ink group-hover:underline' : 'text-stone'}`}>
                  {done && <CheckIcon className="h-3.5 w-3.5" />}
                  {label}
                </span>
              </button>
            </li>);

        })}
      </ol>
    </nav>);

}