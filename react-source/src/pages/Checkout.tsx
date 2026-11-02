import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { ArrowLeftIcon, CheckIcon, LockIcon } from 'lucide-react';
import { useStore } from '../contexts/StoreContext';
import { useCheckout } from '../hooks/useCheckout';
import { CheckoutProgress } from '../components/checkout/CheckoutProgress';
import { CheckoutSummary } from '../components/checkout/CheckoutSummary';
import { ShippingStep } from '../components/checkout/ShippingStep';
import { DeliveryStep } from '../components/checkout/DeliveryStep';
import { PaymentStep } from '../components/checkout/PaymentStep';
import { ReviewStep } from '../components/checkout/ReviewStep';
import { Button, ButtonLink } from '../components/Button';
import { deliveryOptions } from '../data/account';
import { calcTotals, FREE_SHIPPING_THRESHOLD, formatPrice } from '../utils/currency';

export function Checkout() {
  const store = useStore();
  const { step, next, back, goTo, mode, setMode, data, set, errors, applyAddress } = useCheckout();
  const [placing, setPlacing] = useState(false);
  const [placed, setPlaced] = useState<{id: string;total: number;email: string;} | null>(null);

  const discounted = store.subtotal * (1 - (store.promo?.percentOff ?? 0) / 100);
  const freeStandard = discounted >= FREE_SHIPPING_THRESHOLD;
  const delivery = deliveryOptions.find((d) => d.id === data.delivery) ?? deliveryOptions[0];
  const shippingPrice = delivery.id === 'standard' && !freeStandard ? 8 : delivery.price;
  const { total } = calcTotals(store.subtotal, store.promo?.percentOff ?? 0, shippingPrice);

  const placeOrder = () => {
    setPlacing(true);
    window.setTimeout(() => {
      setPlaced({ id: 'ST-10541', total, email: data.email });
      store.clearCart();
      store.removePromo();
      setPlacing(false);
      window.scrollTo({ top: 0 });
    }, 900);
  };

  if (placed) {
    return (
      <div className="bg-white">
        <div className="mx-auto max-w-xl px-5 py-20 text-center md:py-28">
          <span className="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-ink text-white">
            <CheckIcon className="h-6 w-6" />
          </span>
          <h1 className="mt-8 font-serif text-[36px] md:text-[48px]">Thank you, {data.firstName || 'friend'}.</h1>
          <p className="mt-4 text-[15px] text-ink/70">
            Order <span className="font-medium text-ink">{placed.id}</span> is confirmed. A receipt for {formatPrice(placed.total)} is on its way to {placed.email}.
          </p>
          <p className="mx-auto mt-10 max-w-md border-y border-hairline py-6 font-serif text-[18px] italic text-ink/80">
            “The Lord bless you and keep you.” <span className="font-sans text-[12px] not-italic text-stone">— Numbers 6:24</span>
          </p>
          <div className="mt-10 flex flex-col justify-center gap-3 sm:flex-row">
            <ButtonLink to="/account/orders">Track your order</ButtonLink>
            <ButtonLink to="/shop" variant="outline">Continue shopping</ButtonLink>
          </div>
        </div>
      </div>);

  }

  if (store.cart.length === 0) {
    return (
      <div className="mx-auto max-w-xl px-5 py-24 text-center">
        <h1 className="font-serif text-[36px]">Your bag is empty</h1>
        <p className="mt-3 text-[15px] text-ink/65">Add something to your bag to check out.</p>
        <ButtonLink to="/shop" className="mt-8">Continue shopping</ButtonLink>
      </div>);

  }

  return (
    <div className="bg-white">
      <CheckoutSummary variant="mobile" shippingPrice={shippingPrice} shippingLabel={delivery.name} />
      <div className="mx-auto grid max-w-site gap-12 px-5 py-8 md:px-8 md:py-12 lg:grid-cols-[1fr_440px] lg:gap-20">
        <div className="max-w-2xl">
          <div className="flex items-center justify-between">
            <h1 className="font-serif text-[28px] uppercase tracking-[0.06em] md:text-[36px]">Checkout</h1>
            <span className="flex items-center gap-1.5 text-[12px] text-stone">
              <LockIcon className="h-3.5 w-3.5" /> Secure
            </span>
          </div>
          <div className="mt-6">
            <CheckoutProgress step={step} onStepClick={goTo} />
          </div>

          <div className="mt-10">
            {step === 0 && <ShippingStep mode={mode} setMode={setMode} data={data} set={set} errors={errors} applyAddress={applyAddress} />}
            {step === 1 && <DeliveryStep value={data.delivery} onChange={(v) => set('delivery', v)} freeStandard={freeStandard} />}
            {step === 2 && <PaymentStep mode={mode} data={data} set={set} errors={errors} />}
            {step === 3 && <ReviewStep data={data} onEdit={goTo} />}
          </div>

          <div className="mt-10 flex flex-col-reverse items-stretch gap-4 border-t border-hairline pt-8 sm:flex-row sm:items-center sm:justify-between">
            {step === 0 ?
            <Link to="/cart" className="flex items-center justify-center gap-2 text-[13px] underline-offset-4 hover:underline">
                <ArrowLeftIcon className="h-4 w-4" /> Return to bag
              </Link> :

            <button type="button" onClick={back} className="flex items-center justify-center gap-2 text-[13px] underline-offset-4 hover:underline">
                <ArrowLeftIcon className="h-4 w-4" /> Back
              </button>
            }
            {step < 3 ?
            <Button size="lg" onClick={next}>
                Continue to {['delivery', 'payment', 'review'][step]}
              </Button> :

            <Button size="lg" onClick={placeOrder} disabled={placing} aria-busy={placing}>
                {placing ? 'Placing order…' : `Place order · ${formatPrice(total)}`}
              </Button>
            }
          </div>
        </div>

        <CheckoutSummary variant="desktop" shippingPrice={shippingPrice} shippingLabel={delivery.name} />
      </div>
    </div>);

}