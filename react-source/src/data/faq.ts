import type { FaqGroup } from '../types/content';

export const faqGroups: FaqGroup[] = [
{
  id: 'shipping',
  title: 'Shipping',
  items: [
  { q: 'How long does shipping take?', a: 'Standard shipping arrives in 3–5 business days within the U.S. Express arrives in 1–2 business days. Orders placed before 1pm ET ship the same day.' },
  { q: 'Do you offer free shipping?', a: 'Yes — standard shipping is free on all U.S. orders over $150. Orders under $150 ship for a flat $8.' },
  { q: 'Do you ship internationally?', a: 'We currently ship to the U.S., Canada, the U.K., and Australia. International duties are calculated at checkout so there are no surprises on delivery.' },
  { q: 'How do I track my order?', a: 'You’ll receive a tracking link by email as soon as your order ships. You can also find it anytime under Order History in your account.' }]

},
{
  id: 'returns',
  title: 'Returns & Exchanges',
  items: [
  { q: 'What is your return policy?', a: 'We offer free returns within 30 days of delivery on unworn items with original tags attached. Refunds are issued to your original payment method within 5 business days of receipt.' },
  { q: 'How do I exchange for a different size?', a: 'Start an exchange from your Order History. We’ll ship your new size as soon as your return is scanned by the carrier — no waiting.' },
  { q: 'Are sale items returnable?', a: 'Sale items can be exchanged for size within 30 days, but are not eligible for refund.' }]

},
{
  id: 'sizing',
  title: 'Sizing & Fit',
  items: [
  { q: 'How do your pieces fit?', a: 'Most of our tops are cut boxy and oversized with dropped shoulders. If you prefer a closer fit, we recommend sizing down one size.' },
  { q: 'Will my garment shrink?', a: 'All of our cotton is pre-shrunk and garment-washed. Expect less than 3% shrinkage when washed cold and dried low or hung.' },
  { q: 'Where can I find measurements?', a: 'Every product page has a Size Guide with garment measurements in inches and centimeters.' }]

},
{
  id: 'faith',
  title: 'Faith & Mission',
  items: [
  { q: 'Why “Shepherds Thread”?', a: 'Jesus calls himself the Good Shepherd — the one who knows his sheep by name. The thread is the quiet, steady work of making something well. Our mark ties the two together: a crook that becomes a cross, threaded like a needle.' },
  { q: 'Where does a portion of profits go?', a: '10% of every order supports Living Water partners providing clean water to communities in East Africa, and local church-based youth mentorship programs.' },
  { q: 'Are you affiliated with a denomination?', a: 'No. We’re a team of believers from different church backgrounds, united around the person of Jesus and the hope of the gospel.' },
  { q: 'Can my church or ministry order in bulk?', a: 'Yes. We offer custom quantities and pricing for churches, ministries, and youth groups. Reach out via our Contact page.' }]

}];