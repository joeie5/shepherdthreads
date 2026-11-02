export function formatPrice(value: number): string {
  return Number.isInteger(value) ? `$${value}` : `$${value.toFixed(2)}`;
}

export const FREE_SHIPPING_THRESHOLD = 150;
export const TAX_RATE = 0.0825;

export function calcTotals(subtotal: number, percentOff: number, shippingPrice: number | null) {
  const discount = Math.round(subtotal * (percentOff / 100) * 100) / 100;
  const discounted = subtotal - discount;
  const shipping = shippingPrice ?? (discounted >= FREE_SHIPPING_THRESHOLD || discounted === 0 ? 0 : 8);
  const tax = Math.round(discounted * TAX_RATE * 100) / 100;
  const total = Math.round((discounted + shipping + tax) * 100) / 100;
  return { discount, shipping, tax, total };
}