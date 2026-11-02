/// Ported from react-source/src/utils/currency.ts, switched from USD to GBP
/// per the real `Stock Inventory.txt` pricing. The threshold/tax-rate values
/// are still the React mock's placeholder numbers — flagged in
/// MIGRATION_NOTES.md pending real UK VAT/shipping rules.
library;

const double freeShippingThreshold = 150;
const double taxRate = 0.0825;

String formatPrice(num value) {
  if (value == value.roundToDouble()) {
    return '£${value.toInt()}';
  }
  return '£${value.toStringAsFixed(2)}';
}

class CheckoutTotals {
  final double discount;
  final double shipping;
  final double tax;
  final double total;
  const CheckoutTotals({
    required this.discount,
    required this.shipping,
    required this.tax,
    required this.total,
  });
}

double _round2(double v) => (v * 100).round() / 100;

CheckoutTotals calcTotals(double subtotal, double percentOff, double? shippingPrice) {
  final discount = _round2(subtotal * (percentOff / 100));
  final discounted = subtotal - discount;
  final shipping = shippingPrice ??
      (discounted >= freeShippingThreshold || discounted == 0 ? 0 : 8);
  final tax = _round2(discounted * taxRate);
  final total = _round2(discounted + shipping + tax);
  return CheckoutTotals(discount: discount, shipping: shipping, tax: tax, total: total);
}
