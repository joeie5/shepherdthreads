import React from 'react';
import { LockIcon } from 'lucide-react';
import { FormField } from '../FormField';
import { paymentMethods } from '../../data/account';
import type { CheckoutData, CheckoutErrors } from '../../hooks/useCheckout';

interface PaymentStepProps {
  mode: 'guest' | 'member';
  data: CheckoutData;
  set: <K extends keyof CheckoutData>(k: K, v: CheckoutData[K]) => void;
  errors: CheckoutErrors;
}

const formatCard = (v: string) =>
v.replace(/\D/g, '').slice(0, 16).replace(/(.{4})/g, '$1 ').trim();
const formatExpiry = (v: string) => {
  const d = v.replace(/\D/g, '').slice(0, 4);
  return d.length > 2 ? `${d.slice(0, 2)}/${d.slice(2)}` : d;
};

export function PaymentStep({ mode, data, set, errors }: PaymentStepProps) {
  const saved = paymentMethods.find((p) => p.isDefault);
  const options = [
  ...(mode === 'member' && saved ? [{ id: 'saved' as const, label: `${saved.brand} ending ${saved.last4}`, sub: `Expires ${saved.expires}` }] : []),
  { id: 'card' as const, label: 'Credit or debit card', sub: 'Visa, Mastercard, Amex' },
  { id: 'paypal' as const, label: 'PayPal', sub: 'You’ll be redirected to complete payment' },
  { id: 'applepay' as const, label: 'Apple Pay', sub: 'Confirm with Face ID or Touch ID' }];


  return (
    <section>
      <h2 className="flex items-center gap-2 font-serif text-[22px]">
        Payment <LockIcon className="h-4 w-4 text-stone" aria-label="Secure" />
      </h2>
      <p className="mt-1 text-[13px] text-stone">All transactions are encrypted and secure.</p>
      <div className="mt-5 divide-y divide-hairline border border-hairline" role="radiogroup" aria-label="Payment method">
        {options.map((o) => {
          const active = data.payMethod === o.id;
          return (
            <div key={o.id} className={active ? 'bg-cream' : ''}>
              <label className="flex cursor-pointer items-center gap-4 p-5">
                <input type="radio" name="pay" checked={active} onChange={() => set('payMethod', o.id)} className="h-4 w-4 accent-ink" />
                <span>
                  <span className="block text-[14px] font-medium">{o.label}</span>
                  <span className="block text-[13px] text-stone">{o.sub}</span>
                </span>
              </label>
              {active && o.id === 'card' &&
              <div className="grid grid-cols-2 gap-4 px-5 pb-5">
                  <FormField id="cardNumber" className="col-span-2" label="Card number" inputMode="numeric" autoComplete="cc-number" placeholder="1234 5678 9012 3456" value={data.cardNumber} onChange={(e) => set('cardNumber', formatCard(e.target.value))} error={errors.cardNumber} />
                  <FormField id="cardName" className="col-span-2" label="Name on card" autoComplete="cc-name" value={data.cardName} onChange={(e) => set('cardName', e.target.value)} error={errors.cardName} />
                  <FormField id="expiry" label="Expiry" placeholder="MM/YY" inputMode="numeric" autoComplete="cc-exp" value={data.expiry} onChange={(e) => set('expiry', formatExpiry(e.target.value))} error={errors.expiry} />
                  <FormField id="cvc" label="Security code" inputMode="numeric" autoComplete="cc-csc" value={data.cvc} onChange={(e) => set('cvc', e.target.value.replace(/\D/g, '').slice(0, 4))} error={errors.cvc} />
                </div>
              }
            </div>);

        })}
      </div>
      <label className="mt-5 flex items-center gap-2.5 text-[14px]">
        <input type="checkbox" checked={data.billingSame} onChange={(e) => set('billingSame', e.target.checked)} className="h-4 w-4 accent-ink" />
        Billing address same as shipping
      </label>
    </section>);

}