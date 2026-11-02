export interface CartItem {
  key: string;
  productId: string;
  color: string;
  size: string;
  qty: number;
}

export interface Promo {
  code: string;
  percentOff: number;
  label: string;
}

export type OrderStatus = 'Processing' | 'Shipped' | 'Delivered';

export interface OrderLine {
  productId: string;
  color: string;
  size: string;
  qty: number;
  price: number;
}

export interface Address {
  id: string;
  label: string;
  name: string;
  line1: string;
  line2?: string;
  city: string;
  state: string;
  zip: string;
  country: string;
  phone: string;
  isDefault?: boolean;
}

export interface Order {
  id: string;
  placedOn: string;
  status: OrderStatus;
  items: OrderLine[];
  shipping: number;
  tax: number;
  discount: number;
  carrier: string;
  trackingNumber?: string;
  estimatedDelivery: string;
  address: Address;
  payment: string;
  timeline: {label: string;date?: string;done: boolean;}[];
}

export interface PaymentMethod {
  id: string;
  brand: string;
  last4: string;
  expires: string;
  isDefault?: boolean;
}

export interface DeliveryOption {
  id: string;
  name: string;
  eta: string;
  price: number;
}