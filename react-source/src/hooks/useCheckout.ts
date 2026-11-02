import { useState } from 'react';
import { useStore } from '../contexts/StoreContext';
import { addresses, user } from '../data/account';

export interface CheckoutData {
  email: string;
  newsletter: boolean;
  firstName: string;
  lastName: string;
  address1: string;
  address2: string;
  city: string;
  state: string;
  zip: string;
  phone: string;
  delivery: string;
  payMethod: 'saved' | 'card' | 'paypal' | 'applepay';
  cardNumber: string;
  cardName: string;
  expiry: string;
  cvc: string;
  billingSame: boolean;
}

export type CheckoutErrors = Partial<Record<keyof CheckoutData, string>>;

export const checkoutSteps = ['Shipping', 'Delivery', 'Payment', 'Review'];

const blank: CheckoutData = {
  email: '',
  newsletter: true,
  firstName: '',
  lastName: '',
  address1: '',
  address2: '',
  city: '',
  state: '',
  zip: '',
  phone: '',
  delivery: 'standard',
  payMethod: 'card',
  cardNumber: '',
  cardName: '',
  expiry: '',
  cvc: '',
  billingSame: true
};

const member = (): CheckoutData => {
  const a = addresses[0];
  return {
    ...blank,
    email: user.email,
    firstName: user.firstName,
    lastName: user.lastName,
    address1: a.line1,
    address2: a.line2 ?? '',
    city: a.city,
    state: a.state,
    zip: a.zip,
    phone: a.phone,
    payMethod: 'saved'
  };
};

export function useCheckout() {
  const { isSignedIn } = useStore();
  const [step, setStep] = useState(0);
  const [mode, setModeState] = useState<'guest' | 'member'>(isSignedIn ? 'member' : 'guest');
  const [data, setData] = useState<CheckoutData>(isSignedIn ? member() : blank);
  const [errors, setErrors] = useState<CheckoutErrors>({});

  const set = <K extends keyof CheckoutData,>(key: K, value: CheckoutData[K]) => {
    setData((d) => ({ ...d, [key]: value }));
    setErrors((e) => ({ ...e, [key]: undefined }));
  };

  const setMode = (m: 'guest' | 'member') => {
    setModeState(m);
    setErrors({});
    setData(m === 'member' ? member() : { ...blank, delivery: data.delivery });
  };

  const applyAddress = (id: string) => {
    const a = addresses.find((x) => x.id === id);
    if (!a) return;
    setData((d) => ({ ...d, address1: a.line1, address2: a.line2 ?? '', city: a.city, state: a.state, zip: a.zip, phone: a.phone }));
  };

  const validate = (s: number): boolean => {
    const e: CheckoutErrors = {};
    if (s === 0) {
      if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(data.email)) e.email = 'Enter a valid email address';
      (['firstName', 'lastName', 'address1', 'city', 'state'] as const).forEach((k) => {
        if (!data[k].trim()) e[k] = 'Required';
      });
      if (!/^\d{5}$/.test(data.zip.trim())) e.zip = 'Enter a 5-digit ZIP';
      if (data.phone.replace(/\D/g, '').length < 10) e.phone = 'Enter a valid phone number';
    }
    if (s === 2 && data.payMethod === 'card') {
      if (data.cardNumber.replace(/\s/g, '').length !== 16) e.cardNumber = 'Enter a 16-digit card number';
      if (!data.cardName.trim()) e.cardName = 'Required';
      if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(data.expiry)) e.expiry = 'Use MM/YY';
      if (!/^\d{3,4}$/.test(data.cvc)) e.cvc = '3–4 digits';
    }
    setErrors(e);
    return Object.keys(e).length === 0;
  };

  const next = () => {
    if (!validate(step)) return;
    setStep((s) => Math.min(checkoutSteps.length - 1, s + 1));
    window.scrollTo({ top: 0 });
  };

  const back = () => setStep((s) => Math.max(0, s - 1));
  const goTo = (i: number) => i < step && setStep(i);

  return { step, next, back, goTo, mode, setMode, data, set, errors, applyAddress };
}