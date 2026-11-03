import '../constants/app_images.dart';
import '../models/commerce.dart';
import '../models/content.dart';

/// Ported from react-source/src/data/account.ts.
/// Backs account/checkout features once those stages are built; only
/// `testimonials` is consumed so far (Home page).

class MockUser {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String memberSince;
  final String birthday;
  const MockUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.memberSince,
    required this.birthday,
  });
}

const user = MockUser(
  firstName: 'Jordan',
  lastName: 'Ellis',
  email: 'jordan.ellis@email.com',
  phone: '(404) 555-0182',
  memberSince: 'March 2025',
  birthday: 'June 14',
);

final addresses = <Address>[
  const Address(
    id: 'addr-1',
    label: 'Home',
    name: 'Jordan Ellis',
    line1: '1428 Peachtree St NE',
    line2: 'Apt 6B',
    city: 'Atlanta',
    state: 'GA',
    zip: '30309',
    country: 'United States',
    phone: '(404) 555-0182',
    isDefault: true,
  ),
  const Address(
    id: 'addr-2',
    label: 'Work',
    name: 'Jordan Ellis',
    line1: '200 Ponce de Leon Ave',
    city: 'Atlanta',
    state: 'GA',
    zip: '30308',
    country: 'United States',
    phone: '(404) 555-0182',
  ),
];

const paymentMethods = <PaymentMethod>[
  PaymentMethod(id: 'pm-1', brand: 'Visa', last4: '4242', expires: '08/28', isDefault: true),
  PaymentMethod(id: 'pm-2', brand: 'Mastercard', last4: '8810', expires: '02/27'),
];

const deliveryOptions = <DeliveryOption>[
  DeliveryOption(id: 'standard', name: 'Standard', eta: '3–5 business days', price: 0),
  DeliveryOption(id: 'express', name: 'Express', eta: '1–2 business days', price: 18),
  DeliveryOption(id: 'pickup', name: 'Studio pickup — Atlanta', eta: 'Ready tomorrow', price: 0),
];

final orders = <Order>[
  Order(
    id: 'ST-10533',
    placedOn: 'October 29, 2026',
    status: OrderStatus.processing,
    items: const [
      OrderLine(productId: 'identity-polo', color: 'Black', size: 'L', qty: 1, price: 21.40),
      OrderLine(productId: 'identity-shorts', color: 'Black', size: 'M', qty: 1, price: 27.60),
    ],
    shipping: 0,
    tax: 4.04,
    discount: 0,
    carrier: 'UPS',
    estimatedDelivery: 'November 4, 2026',
    address: addresses[0],
    payment: 'Visa ending 4242',
    timeline: const [
      TimelineStep(label: 'Order placed', date: 'Oct 29', done: true),
      TimelineStep(label: 'Preparing', date: 'Oct 30', done: true),
      TimelineStep(label: 'Shipped', done: false),
      TimelineStep(label: 'Delivered', done: false),
    ],
  ),
  Order(
    id: 'ST-10517',
    placedOn: 'October 21, 2026',
    status: OrderStatus.shipped,
    items: const [
      OrderLine(productId: 'saved-joggers', color: 'Medium Blue', size: 'M', qty: 1, price: 24.20),
    ],
    shipping: 8,
    tax: 2.00,
    discount: 0,
    carrier: 'UPS',
    trackingNumber: '1Z 999 AA1 0123 4567 84',
    estimatedDelivery: 'November 3, 2026',
    address: addresses[0],
    payment: 'Visa ending 4242',
    timeline: const [
      TimelineStep(label: 'Order placed', date: 'Oct 21', done: true),
      TimelineStep(label: 'Preparing', date: 'Oct 22', done: true),
      TimelineStep(label: 'Shipped', date: 'Oct 23', done: true),
      TimelineStep(label: 'Delivered', done: false),
    ],
  ),
  Order(
    id: 'ST-10482',
    placedOn: 'September 8, 2026',
    status: OrderStatus.delivered,
    items: const [
      OrderLine(productId: 'saved-hoodie', color: 'Grey', size: 'M', qty: 1, price: 23.40),
      OrderLine(productId: 'crowned-tee', color: 'Black', size: 'M', qty: 2, price: 26.99),
    ],
    shipping: 0,
    tax: 18.65,
    discount: 22.6,
    carrier: 'USPS',
    trackingNumber: '9400 1000 0000 0000 0000 00',
    estimatedDelivery: 'September 12, 2026',
    address: addresses[1],
    payment: 'Mastercard ending 8810',
    timeline: const [
      TimelineStep(label: 'Order placed', date: 'Sep 8', done: true),
      TimelineStep(label: 'Preparing', date: 'Sep 8', done: true),
      TimelineStep(label: 'Shipped', date: 'Sep 9', done: true),
      TimelineStep(label: 'Delivered', date: 'Sep 12', done: true),
    ],
  ),
];

final testimonials = <Testimonial>[
  Testimonial(
    name: 'Alexis M.',
    location: 'Nashville, TN',
    quote:
        'Heaviest hoodie I own and somehow the one I reach for most. People ask about the cross on the chest every week.',
    product: 'Saved Hoodie',
    image: AppImages.savedHoodieFrontMediumBlue,
  ),
  Testimonial(
    name: 'Josiah R.',
    location: 'Austin, TX',
    quote: 'Finally faith apparel I’d actually wear to dinner. Quiet, well-made, and it means something.',
    product: 'Crowned T-Shirt',
    image: AppImages.crownedTeeFrontBlack,
  ),
  Testimonial(
    name: 'Grace K.',
    location: 'Seattle, WA',
    quote: 'Bought one for my youth pastor and ended up ordering three more for our leadership team.',
    product: 'Saved Joggers',
    image: AppImages.savedJoggersFrontMediumBlue,
  ),
  Testimonial(
    name: 'Daniel P.',
    location: 'Chicago, IL',
    quote: 'Fit, fabric and the story behind it. This is what I hoped Christian clothing could be.',
    product: 'Identity Polo',
    image: AppImages.identityPoloFrontBlack,
  ),
];

const sizeGuide = (
  headers: ['Size', 'Chest (in)', 'Length (in)', 'Sleeve (in)'],
  rows: [
    ['XS', '22', '26', '22.5'],
    ['S', '23', '27', '23'],
    ['M', '24.5', '28', '23.5'],
    ['L', '26', '29', '24'],
    ['XL', '27.5', '30', '24.5'],
    ['XXL', '29', '31', '25'],
  ],
);
