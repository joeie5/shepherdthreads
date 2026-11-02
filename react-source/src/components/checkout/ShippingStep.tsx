import React from 'react';
import { Link } from 'react-router-dom';
import { CheckIcon } from 'lucide-react';
import { FormField } from '../FormField';
import { addresses, user } from '../../data/account';
import type { CheckoutData, CheckoutErrors } from '../../hooks/useCheckout';

interface ShippingStepProps {
  mode: 'guest' | 'member';
  setMode: (m: 'guest' | 'member') => void;
  data: CheckoutData;
  set: <K extends keyof CheckoutData>(k: K, v: CheckoutData[K]) => void;
  errors: CheckoutErrors;
  applyAddress: (id: string) => void;
}

export function ShippingStep({ mode, setMode, data, set, errors, applyAddress }: ShippingStepProps) {
  const modes = [
  { id: 'member' as const, title: 'Member checkout', text: 'Use saved addresses & cards' },
  { id: 'guest' as const, title: 'Guest checkout', text: 'No account needed' }];


  return (
    <div className="space-y-10">
      <div className="grid grid-cols-2 gap-3" role="radiogroup" aria-label="Checkout type">
        {modes.map((m) => {
          const active = mode === m.id;
          return (
            <button
              key={m.id}
              type="button"
              role="radio"
              aria-checked={active}
              onClick={() => setMode(m.id)}
              className={`border p-4 text-left transition-colors ${active ? 'border-ink' : 'border-hairline hover:border-stone'}`}>
              
              <span className="flex items-center justify-between text-[14px] font-medium">
                {m.title}
                {active && <CheckIcon className="h-4 w-4" />}
              </span>
              <span className="mt-1 block text-[12px] text-stone">{m.text}</span>
            </button>);

        })}
      </div>

      <section>
        <h2 className="font-serif text-[22px]">Contact</h2>
        {mode === 'member' ?
        <p className="mt-4 text-[14px] text-ink/75">
            Signed in as <span className="font-medium text-ink">{user.firstName} {user.lastName}</span> · {user.email}
          </p> :

        <div className="mt-4 space-y-3">
            <FormField id="email" label="Email" type="email" autoComplete="email" value={data.email} onChange={(e) => set('email', e.target.value)} error={errors.email} placeholder="you@email.com" />
            <label className="flex items-center gap-2.5 text-[13px] text-ink/75">
              <input type="checkbox" checked={data.newsletter} onChange={(e) => set('newsletter', e.target.checked)} className="h-4 w-4 accent-ink" />
              Email me about new releases and devotionals
            </label>
            <p className="text-[13px] text-stone">
              Have an account? <Link to="/login" className="text-ink underline underline-offset-4">Sign in</Link>
            </p>
          </div>
        }
      </section>

      <section>
        <h2 className="font-serif text-[22px]">Shipping address</h2>
        {mode === 'member' &&
        <div className="mt-4 grid gap-3 sm:grid-cols-2" role="radiogroup" aria-label="Saved addresses">
            {addresses.map((a) => {
            const active = data.address1 === a.line1;
            return (
              <button
                key={a.id}
                type="button"
                role="radio"
                aria-checked={active}
                onClick={() => applyAddress(a.id)}
                className={`border p-4 text-left text-[13px] transition-colors ${active ? 'border-ink' : 'border-hairline hover:border-stone'}`}>
                
                  <span className="flex items-center justify-between font-medium">
                    {a.label}
                    {active && <CheckIcon className="h-4 w-4" />}
                  </span>
                  <span className="mt-1 block text-ink/70">
                    {a.line1}
                    {a.line2 ? `, ${a.line2}` : ''}
                    <br />
                    {a.city}, {a.state} {a.zip}
                  </span>
                </button>);

          })}
          </div>
        }
        <div className="mt-5 grid grid-cols-2 gap-4">
          <FormField id="firstName" label="First name" autoComplete="given-name" value={data.firstName} onChange={(e) => set('firstName', e.target.value)} error={errors.firstName} />
          <FormField id="lastName" label="Last name" autoComplete="family-name" value={data.lastName} onChange={(e) => set('lastName', e.target.value)} error={errors.lastName} />
          <FormField id="address1" className="col-span-2" label="Address" autoComplete="address-line1" value={data.address1} onChange={(e) => set('address1', e.target.value)} error={errors.address1} />
          <FormField id="address2" className="col-span-2" label="Apartment, suite (optional)" autoComplete="address-line2" value={data.address2} onChange={(e) => set('address2', e.target.value)} />
          <FormField id="city" className="col-span-2 sm:col-span-1" label="City" autoComplete="address-level2" value={data.city} onChange={(e) => set('city', e.target.value)} error={errors.city} />
          <div className="col-span-2 grid grid-cols-2 gap-4 sm:col-span-1">
            <FormField id="state" label="State" autoComplete="address-level1" value={data.state} onChange={(e) => set('state', e.target.value)} error={errors.state} />
            <FormField id="zip" label="ZIP" inputMode="numeric" autoComplete="postal-code" value={data.zip} onChange={(e) => set('zip', e.target.value)} error={errors.zip} />
          </div>
          <FormField id="phone" className="col-span-2" label="Phone" type="tel" autoComplete="tel" value={data.phone} onChange={(e) => set('phone', e.target.value)} error={errors.phone} hint="For delivery updates only" />
        </div>
      </section>
    </div>);

}