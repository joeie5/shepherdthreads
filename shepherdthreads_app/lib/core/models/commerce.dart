/// Ported from react-source/src/types/commerce.ts
///
/// Hand-written (not @freezed) — see note in product.dart.
library;

class CartItem {
  final String key;
  final String productId;
  final String color;
  final String size;
  final int qty;

  const CartItem({
    required this.key,
    required this.productId,
    required this.color,
    required this.size,
    required this.qty,
  });

  CartItem copyWith({int? qty}) => CartItem(
        key: key,
        productId: productId,
        color: color,
        size: size,
        qty: qty ?? this.qty,
      );
}

String makeCartKey(String productId, String color, String size) => '${productId}__${color}__$size';

class Promo {
  final String code;
  final double percentOff;
  final String label;
  const Promo({required this.code, required this.percentOff, required this.label});
}

enum OrderStatus { processing, shipped, delivered }

extension OrderStatusLabel on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }
}

class OrderLine {
  final String productId;
  final String color;
  final String size;
  final int qty;
  final double price;
  const OrderLine({
    required this.productId,
    required this.color,
    required this.size,
    required this.qty,
    required this.price,
  });
}

class Address {
  final String id;
  final String label;
  final String name;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String zip;
  final String country;
  final String phone;
  final bool isDefault;

  const Address({
    required this.id,
    required this.label,
    required this.name,
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
    required this.phone,
    this.isDefault = false,
  });

  Address copyWith({bool? isDefault}) => Address(
        id: id,
        label: label,
        name: name,
        line1: line1,
        line2: line2,
        city: city,
        state: state,
        zip: zip,
        country: country,
        phone: phone,
        isDefault: isDefault ?? this.isDefault,
      );
}

class TimelineStep {
  final String label;
  final String? date;
  final bool done;
  const TimelineStep({required this.label, this.date, required this.done});
}

class Order {
  final String id;
  final String placedOn;
  final OrderStatus status;
  final List<OrderLine> items;
  final double shipping;
  final double tax;
  final double discount;
  final String carrier;
  final String? trackingNumber;
  final String estimatedDelivery;
  final Address address;
  final String payment;
  final List<TimelineStep> timeline;

  const Order({
    required this.id,
    required this.placedOn,
    required this.status,
    required this.items,
    required this.shipping,
    required this.tax,
    required this.discount,
    required this.carrier,
    this.trackingNumber,
    required this.estimatedDelivery,
    required this.address,
    required this.payment,
    required this.timeline,
  });
}

class PaymentMethod {
  final String id;
  final String brand;
  final String last4;
  final String expires;
  final bool isDefault;
  const PaymentMethod({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expires,
    this.isDefault = false,
  });
}

class DeliveryOption {
  final String id;
  final String name;
  final String eta;
  final double price;
  const DeliveryOption({required this.id, required this.name, required this.eta, required this.price});
}
