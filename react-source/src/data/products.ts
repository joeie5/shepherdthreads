import { images } from './images';
import type { Collection, Product } from '../types/product';

const apparelSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

const heavyCare = [
'Machine wash cold, inside out, with like colors',
'Tumble dry low or hang to dry',
'Do not bleach',
'Cool iron, avoid embroidery'];


export const collections: Collection[] = [
{
  id: 'psalm-23',
  name: 'The Psalm 23 Collection',
  description: 'Soft tones and quiet details inspired by green pastures and still waters.'
},
{
  id: 'essentials',
  name: 'Daily Essentials',
  description: 'The foundations. Heavyweight staples built to be worn every day for years.'
},
{
  id: 'sabbath',
  name: 'Sabbath Rest',
  description: 'Loungewear made for slowing down, set apart for the seventh day.'
}];


export const products: Product[] = [
{
  id: 'good-shepherd-hoodie',
  name: 'Good Shepherd Hoodie',
  subtitle: 'Heavyweight Fleece',
  price: 118,
  category: 'Hoodies',
  collection: 'essentials',
  description:
  'Our signature hoodie in 480gsm brushed-back fleece with a boxy, dropped-shoulder fit. A tonal crook-and-cross is stitched at the chest — small enough to be personal, clear enough to start a conversation.',
  verse: { text: 'I am the good shepherd.', reference: 'John 10:11' },
  colors: [
  { name: 'Black', hex: '#0A0A0A', images: [images.hoodieBlack, images.hoodieModel, images.hero] },
  { name: 'Bone', hex: '#ECE7DC', images: [images.hoodieBone, images.lookbookSteps] }],

  sizes: apparelSizes,
  soldOutSizes: ['XS'],
  bestsellerRank: 1,
  addedOn: '2026-09-02',
  details: [
  'Boxy fit with dropped shoulders — size down for a closer fit',
  'Double-layer hood, no drawcords',
  'Tonal embroidered crook-and-cross at left chest',
  'Ribbed cuffs and hem with 2×2 rib'],

  fabric: '100% organic cotton, 480gsm brushed fleece. Knit and garment-dyed in Portugal.',
  care: heavyCare
},
{
  id: 'psalm-23-tee',
  name: 'Psalm 23 Tee',
  subtitle: 'Oversized Heavyweight Tee',
  price: 54,
  category: 'Tees',
  collection: 'psalm-23',
  description:
  'A structured, boxy tee in 260gsm cotton jersey. The first line of Psalm 23 is printed small across the upper back — a reminder carried with you, not announced.',
  verse: { text: 'The Lord is my shepherd; I shall not want.', reference: 'Psalm 23:1' },
  colors: [
  { name: 'Cream', hex: '#F1EBDD', images: [images.teeCream, images.teeCreamModel] },
  { name: 'Black', hex: '#0A0A0A', images: [images.teeBlack, images.lookbookField] }],

  sizes: apparelSizes,
  bestsellerRank: 2,
  addedOn: '2026-08-14',
  details: [
  'Oversized boxy fit, cropped slightly at the hem',
  'Thick 1" ribbed collar that holds its shape',
  'Water-based screen print at upper back',
  'Pre-shrunk to minimise shrinkage'],

  fabric: '100% combed cotton, 260gsm single jersey. Made in Los Angeles.',
  care: heavyCare
},
{
  id: 'still-waters-crewneck',
  name: 'Still Waters Crewneck',
  subtitle: 'Garment-Dyed Fleece',
  price: 98,
  category: 'Crewnecks',
  collection: 'psalm-23',
  description:
  'Garment-dyed in a soft stone grey that only gets better with wear. Relaxed through the body with a slightly cropped length to sit well over trousers.',
  verse: { text: 'He leads me beside still waters.', reference: 'Psalm 23:2' },
  colors: [{ name: 'Stone', hex: '#9A9893', images: [images.crewStone, images.crewModel] }],
  sizes: apparelSizes,
  soldOutSizes: ['XXL'],
  bestsellerRank: 4,
  addedOn: '2026-08-14',
  details: [
  'Relaxed fit, slightly cropped',
  'Garment-dyed — each piece varies subtly',
  'Flatlock seams for comfort'],

  fabric: '100% organic cotton, 420gsm loopback fleece.',
  care: heavyCare
},
{
  id: 'threaded-crook-cap',
  name: 'Threaded Crook Cap',
  subtitle: 'Unstructured Six-Panel',
  price: 42,
  category: 'Headwear',
  collection: 'essentials',
  description:
  'A low-profile, unstructured cap in washed cotton twill with our crook-and-cross mark embroidered tonally at the front.',
  colors: [{ name: 'Black', hex: '#0A0A0A', images: [images.capBlack, images.capModel] }],
  sizes: ['One Size'],
  bestsellerRank: 3,
  addedOn: '2026-06-20',
  details: ['Adjustable brass slide closure', 'Curved brim', 'Tonal embroidery'],
  fabric: '100% cotton twill, enzyme washed.',
  care: ['Spot clean only', 'Reshape while damp', 'Do not machine wash']
},
{
  id: 'narrow-path-long-sleeve',
  name: 'Narrow Path Long Sleeve',
  subtitle: 'Heavyweight Long Sleeve',
  price: 64,
  category: 'Tees',
  collection: 'essentials',
  description:
  'A clean long sleeve with a relaxed body and slim cuff. Made for layering, built to hold up through the seasons.',
  verse: { text: 'Narrow is the gate and difficult is the way which leads to life.', reference: 'Matthew 7:14' },
  colors: [{ name: 'Black', hex: '#0A0A0A', images: [images.longsleeveBlack, images.lookbookField] }],
  sizes: apparelSizes,
  isNew: true,
  bestsellerRank: 6,
  addedOn: '2026-10-18',
  details: ['Relaxed body, slim ribbed cuffs', 'Tonal back-neck print', 'Side-seamed construction'],
  fabric: '100% combed cotton, 240gsm jersey.',
  care: heavyCare
},
{
  id: 'selah-beanie',
  name: 'Selah Beanie',
  subtitle: 'Merino Rib Knit',
  price: 38,
  category: 'Headwear',
  collection: 'sabbath',
  description: 'A fine-ribbed merino beanie with a deep fold. Selah — pause, and reflect.',
  colors: [{ name: 'Stone', hex: '#9A9893', images: [images.beanieStone, images.lookbookDetail] }],
  sizes: ['One Size'],
  soldOut: true,
  bestsellerRank: 5,
  addedOn: '2026-10-01',
  details: ['Double-layer fold cuff', 'Fine 2×2 rib', 'Woven label at cuff'],
  fabric: '100% extra-fine merino wool.',
  care: ['Hand wash cold', 'Lay flat to dry']
},
{
  id: 'washed-grace-tee',
  name: 'Washed Grace Tee',
  subtitle: 'Garment-Dyed Tee',
  price: 44,
  compareAt: 54,
  category: 'Tees',
  collection: 'psalm-23',
  description:
  'Our heavyweight tee, washed down to a soft stone grey with a lived-in hand. Grace, by definition, is undeserved — this price is too.',
  verse: { text: 'For by grace you have been saved through faith.', reference: 'Ephesians 2:8' },
  colors: [{ name: 'Stone', hex: '#9A9893', images: [images.teeStone, images.teeCreamModel] }],
  sizes: apparelSizes,
  soldOutSizes: ['XS', 'S'],
  bestsellerRank: 8,
  addedOn: '2026-07-10',
  details: ['Oversized boxy fit', 'Garment-dyed and enzyme washed', 'Ribbed collar'],
  fabric: '100% cotton, 260gsm jersey.',
  care: heavyCare
},
{
  id: 'cornerstone-crewneck',
  name: 'Cornerstone Crewneck',
  subtitle: 'Heavyweight Fleece',
  price: 98,
  category: 'Crewnecks',
  collection: 'essentials',
  description:
  'A foundational crew in natural ecru. Heavy enough to stand on its own in autumn, clean enough to wear anywhere.',
  verse: { text: 'The stone the builders rejected has become the cornerstone.', reference: 'Psalm 118:22' },
  colors: [{ name: 'Ecru', hex: '#E8E0CF', images: [images.crewCream, images.capModel] }],
  sizes: apparelSizes,
  isNew: true,
  bestsellerRank: 7,
  addedOn: '2026-10-24',
  details: ['Relaxed fit', 'Raglan shoulder seam', 'V-insert at neck'],
  fabric: '100% organic cotton, 480gsm brushed fleece.',
  care: heavyCare
},
{
  id: 'shepherds-zip-hoodie',
  name: 'Shepherd’s Zip Hoodie',
  subtitle: 'Full-Zip Heavyweight',
  price: 128,
  category: 'Hoodies',
  collection: 'essentials',
  description:
  'The full-zip version of our signature fleece with a matte black two-way zip and deep hand pockets.',
  colors: [{ name: 'Black', hex: '#0A0A0A', images: [images.zipBlack, images.hoodieModel] }],
  sizes: apparelSizes,
  isNew: true,
  bestsellerRank: 9,
  addedOn: '2026-10-28',
  details: ['Two-way matte metal zip', 'Double-layer hood', 'Hidden phone pocket'],
  fabric: '100% organic cotton, 480gsm brushed fleece.',
  care: heavyCare
},
{
  id: 'sabbath-sweatpant',
  name: 'Sabbath Sweatpant',
  subtitle: 'Relaxed Fleece Pant',
  price: 92,
  category: 'Bottoms',
  collection: 'sabbath',
  description:
  'A relaxed, straight-leg sweatpant cut from the same fleece as our hoodies. Made for the day you set apart.',
  verse: { text: 'Come to me, all who labor and are heavy laden, and I will give you rest.', reference: 'Matthew 11:28' },
  colors: [{ name: 'Black', hex: '#0A0A0A', images: [images.sweatpantsBlack, images.hero] }],
  sizes: apparelSizes,
  bestsellerRank: 10,
  addedOn: '2026-09-12',
  details: ['Straight leg, open hem', 'Internal drawcord', 'Two side pockets and one back pocket'],
  fabric: '100% organic cotton, 420gsm brushed fleece.',
  care: heavyCare
},
{
  id: 'daily-bread-tote',
  name: 'Daily Bread Tote',
  subtitle: '16oz Canvas Tote',
  price: 36,
  category: 'Accessories',
  collection: 'sabbath',
  description:
  'A sturdy canvas tote with cotton webbing handles. Carries your Bible, your laptop, or the week’s groceries.',
  verse: { text: 'Give us this day our daily bread.', reference: 'Matthew 6:11' },
  colors: [{ name: 'Natural', hex: '#E9E1CF', images: [images.tote, images.lookbookDetail] }],
  sizes: ['One Size'],
  bestsellerRank: 11,
  addedOn: '2026-05-30',
  details: ['16oz natural canvas', 'Interior slip pocket', 'Embroidered cross at corner'],
  fabric: '100% cotton canvas.',
  care: ['Spot clean', 'Hang to dry']
}];