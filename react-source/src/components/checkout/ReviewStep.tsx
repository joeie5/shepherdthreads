import React from 'react';
import { deliveryOptions, paymentMethods } from '../../data/account';
import type { CheckoutData } from '../../hooks/useCheckout';

interface ReviewStepProps {
  data: CheckoutData;
  onEdit: (step: number) => void;
}

function Row({ title, onEdit, children }: {title: string;onEdit: () => void;children: React.ReactNode;}) {
  return (
    <div className="flex items-start justify-between gap-6 py-5">
      <div>
        <h3 className="text-[12px] font-medium uppercase tracking-[0.12em] text-stone">{title}</h3>
        <div className="mt-2 text-[14px] leading-relaxed">{children}</div>
      </div>
      <button type="button" onClick={onEdit} className="text-[13px] underline underline-offset-4">
        Edit
      </button>
    </div>);

}

export function ReviewStep({ data, onEdit }: ReviewStepProps) {
  const delivery = deliveryOptions.find((d) => d.id === data.delivery);
  const saved = paymentMethods.find((p) => p.isDefault);
  const payLabel =
  data.payMethod === 'saved' ?
  `${saved?.brand} ending ${saved?.last4}` :
  data.payMethod === 'card' ?
  `Card ending ${data.cardNumber.replace(/\s/g, '').slice(-4)}` :
  data.payMethod === 'paypal' ?
  'PayPal' :
  'Apple Pay';

  return (
    <section>
      <h2 className="font-serif text-[22px]">Review your order</h2>
      <div className="mt-3 divide-y divide-hairline border-y border-hairline">
        <Row title="Contact" onEdit={() => onEdit(0)}>
          {data.email}
          <br />
          {data.phone}
        </Row>
        <Row title="Ship to" onEdit={() => onEdit(0)}>
          {data.firstName} {data.lastName}
          <br />
          {data.address1}
          {data.address2 ? `, ${data.address2}` : ''}
          <br />
          {data.city}, {data.state} {data.zip}
        </Row>
        <Row title="Delivery" onEdit={() => onEdit(1)}>
          {delivery?.name} · {delivery?.eta}
        </Row>
        <Row title="Payment" onEdit={() => onEdit(2)}>
          {payLabel}
          <br />
          <span className="text-stone">{data.billingSame ? 'Billing same as shipping' : 'Separate billing address'}</span>
        </Row>
      </div>
      <p className="mt-5 text-[13px] text-stone">
        By placing your order you agree to our Terms and Privacy Policy. 10% of this order will support clean water and youth mentorship.
      </p>
    </section>);

}