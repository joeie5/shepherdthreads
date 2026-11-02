import React from 'react';
import { CreditCardIcon, PlusIcon } from 'lucide-react';
import { paymentMethods } from '../../data/account';

export function PaymentsPanel() {
  return (
    <section>
      <h2 className="font-serif text-[24px]">Payment methods</h2>
      <ul className="mt-6 divide-y divide-hairline border-y border-hairline">
        {paymentMethods.map((m) =>
        <li key={m.id} className="flex items-center gap-4 py-5">
            <span className="flex h-10 w-14 items-center justify-center border border-hairline">
              <CreditCardIcon className="h-5 w-5" strokeWidth={1.5} />
            </span>
            <div className="flex-1">
              <p className="text-[14px] font-medium">
                {m.brand} ending {m.last4}
                {m.isDefault && <span className="ml-3 text-[11px] font-normal uppercase tracking-[0.12em] text-brass">Default</span>}
              </p>
              <p className="text-[13px] text-stone">Expires {m.expires}</p>
            </div>
            <button className="text-[13px] text-stone underline underline-offset-4 hover:text-ink">Remove</button>
          </li>
        )}
      </ul>
      <button className="mt-6 flex h-12 items-center gap-2 border border-ink px-6 text-[12px] font-medium uppercase tracking-[0.12em] transition-colors hover:bg-ink hover:text-white">
        <PlusIcon className="h-4 w-4" /> Add payment method
      </button>
      <p className="mt-4 text-[13px] text-stone">Card details are stored securely by our payment partner. We never see your full card number.</p>
    </section>);

}