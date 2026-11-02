import type { Address, DeliveryOption, Order, PaymentMethod } from '../types/commerce';
import type { Testimonial } from '../types/content';
import { images } from './images';

export const user = {
  firstName: 'Jordan',
  lastName: 'Ellis',
  email: 'jordan.ellis@email.com',
  phone: '(404) 555-0182',
  memberSince: 'March 2025',
  birthday: 'June 14'
};

export const addresses: Address[] = [
{
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
  isDefault: true
},
{
  id: 'addr-2',
  label: 'Work',
  name: 'Jordan Ellis',
  line1: '200 Ponce de Leon Ave',
  city: 'Atlanta',
  state: 'GA',
  zip: '30308',
  country: 'United States',
  phone: '(404) 555-0182'
}];


export const paymentMethods: PaymentMethod[] = [
{ id: 'pm-1', brand: 'Visa', last4: '4242', expires: '08/28', isDefault: true },
{ id: 'pm-2', brand: 'Mastercard', last4: '8810', expires: '02/27' }];


export const deliveryOptions: DeliveryOption[] = [
{ id: 'standard', name: 'Standard', eta: '3–5 business days', price: 0 },
{ id: 'express', name: 'Express', eta: '1–2 business days', price: 18 },
{ id: 'pickup', name: 'Studio pickup — Atlanta', eta: 'Ready tomorrow', price: 0 }];


export const orders: Order[] = [
{
  id: 'ST-10533',
  placedOn: 'October 29, 2026',
  status: 'Processing',
  items: [
  { productId: 'shepherds-zip-hoodie', color: 'Black', size: 'L', qty: 1, price: 128 },
  { productId: 'selah-beanie', color: 'Stone', size: 'One Size', qty: 1, price: 38 }],

  shipping: 0,
  tax: 13.7,
  discount: 0,
  carrier: 'UPS',
  estimatedDelivery: 'November 4, 2026',
  address: addresses[0],
  payment: 'Visa ending 4242',
  timeline: [
  { label: 'Order placed', date: 'Oct 29', done: true },
  { label: 'Preparing', date: 'Oct 30', done: true },
  { label: 'Shipped', done: false },
  { label: 'Delivered', done: false }]

},
{
  id: 'ST-10517',
  placedOn: 'October 21, 2026',
  status: 'Shipped',
  items: [
  { productId: 'still-waters-crewneck', color: 'Stone', size: 'M', qty: 1, price: 98 },
  { productId: 'threaded-crook-cap', color: 'Black', size: 'One Size', qty: 1, price: 42 }],

  shipping: 8,
  tax: 11.55,
  discount: 0,
  carrier: 'UPS',
  trackingNumber: '1Z 999 AA1 0123 4567 84',
  estimatedDelivery: 'November 3, 2026',
  address: addresses[0],
  payment: 'Visa ending 4242',
  timeline: [
  { label: 'Order placed', date: 'Oct 21', done: true },
  { label: 'Preparing', date: 'Oct 22', done: true },
  { label: 'Shipped', date: 'Oct 23', done: true },
  { label: 'Delivered', done: false }]

},
{
  id: 'ST-10482',
  placedOn: 'September 8, 2026',
  status: 'Delivered',
  items: [
  { productId: 'good-shepherd-hoodie', color: 'Bone', size: 'M', qty: 1, price: 118 },
  { productId: 'psalm-23-tee', color: 'Black', size: 'M', qty: 2, price: 54 }],

  shipping: 0,
  tax: 18.65,
  discount: 22.6,
  carrier: 'USPS',
  trackingNumber: '9400 1000 0000 0000 0000 00',
  estimatedDelivery: 'September 12, 2026',
  address: addresses[1],
  payment: 'Mastercard ending 8810',
  timeline: [
  { label: 'Order placed', date: 'Sep 8', done: true },
  { label: 'Preparing', date: 'Sep 8', done: true },
  { label: 'Shipped', date: 'Sep 9', done: true },
  { label: 'Delivered', date: 'Sep 12', done: true }]

}];


export const testimonials: Testimonial[] = [
{
  name: 'Alexis M.',
  location: 'Nashville, TN',
  quote: 'Heaviest hoodie I own and somehow the one I reach for most. People ask about the cross on the chest every week.',
  product: 'Good Shepherd Hoodie',
  image: images.hoodieModel
},
{
  name: 'Josiah R.',
  location: 'Austin, TX',
  quote: 'Finally faith apparel I’d actually wear to dinner. Quiet, well-made, and it means something.',
  product: 'Psalm 23 Tee',
  image: images.teeCreamModel
},
{
  name: 'Grace K.',
  location: 'Seattle, WA',
  quote: 'Bought one for my youth pastor and ended up ordering three more for our leadership team.',
  product: 'Still Waters Crewneck',
  image: images.crewModel
},
{
  name: 'Daniel P.',
  location: 'Chicago, IL',
  quote: 'Fit, fabric and the story behind it. This is what I hoped Christian clothing could be.',
  product: 'Threaded Crook Cap',
  image: images.capModel
}];


export const sizeGuide = {
  headers: ['Size', 'Chest (in)', 'Length (in)', 'Sleeve (in)'],
  rows: [
  ['XS', '22', '26', '22.5'],
  ['S', '23', '27', '23'],
  ['M', '24.5', '28', '23.5'],
  ['L', '26', '29', '24'],
  ['XL', '27.5', '30', '24.5'],
  ['XXL', '29', '31', '25']]

};