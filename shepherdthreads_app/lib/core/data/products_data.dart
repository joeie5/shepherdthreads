import '../constants/app_images.dart';
import '../models/product.dart';

/// Real catalog only — every product here has actual photography in
/// assets/images/ (see MIGRATION_NOTES.md "Demo content removed"). No
/// placehold.co-backed placeholder products.

// Real size runs from the actual size chart.
const _realSizes = ['S', 'M', 'L', 'XL', '2XL']; // Identity Shorts, Saved Joggers, Saved Hoodie
const _realSizesWith3xl = ['S', 'M', 'L', 'XL', '2XL', '3XL']; // Identity Polo, Crowned T-Shirt

const _heavyCare = [
  'Machine wash cold, inside out, with like colors',
  'Tumble dry low or hang to dry',
  'Do not bleach',
  'Cool iron, avoid embroidery',
];

final productCollections = <ProductCollection>[
  const ProductCollection(
    id: CollectionId.psalm23,
    name: 'The Psalm 23 Collection',
    description: 'Soft tones and quiet details inspired by green pastures and still waters.',
  ),
  const ProductCollection(
    id: CollectionId.essentials,
    name: 'Daily Essentials',
    description: 'The foundations. Heavyweight staples built to be worn every day for years.',
  ),
  const ProductCollection(
    id: CollectionId.sabbath,
    name: 'Sabbath Rest',
    description: 'Loungewear made for slowing down, set apart for the seventh day.',
  ),
];

final mockProducts = <Product>[
  // "Saved Hoodie(MB/G) £23.40" from Stock Inventory.txt.
  Product(
    id: 'saved-hoodie',
    name: 'Saved Hoodie',
    subtitle: 'Heavyweight Fleece',
    price: 23.40,
    category: ProductCategory.hoodies,
    collection: CollectionId.essentials,
    description:
        'Our signature hoodie in heavyweight brushed-back fleece with a boxy, dropped-shoulder fit. A tonal cross and our crook-and-cross mark are stitched at the chest — small enough to be personal, clear enough to start a conversation.',
    verse: const VerseRef(text: 'Believe in the Lord Jesus, and you will be saved.', reference: 'Acts 16:31'),
    colors: [
      const ColorVariant(
        name: 'Grey',
        hex: '#8C8C88',
        images: [AppImages.savedHoodieFrontGrey, AppImages.savedHoodieBackGrey],
      ),
      const ColorVariant(
        name: 'Medium Blue',
        hex: '#7FA8D9',
        images: [AppImages.savedHoodieFrontMediumBlue, AppImages.savedHoodieBackMediumBlue],
      ),
    ],
    sizes: _realSizes,
    bestsellerRank: 1,
    addedOn: '2026-09-02',
    details: const [
      'Boxy fit with dropped shoulders — size down for a closer fit',
      'Double-layer hood, no drawcords',
      'Embroidered cross and tonal crook-and-cross mark at chest',
      'Ribbed cuffs and hem with 2×2 rib',
    ],
    fabric: '100% organic cotton, brushed fleece.',
    care: _heavyCare,
  ),
  // "Crowned T-Shirt(LA/B) £26.99" from Stock Inventory.txt.
  Product(
    id: 'crowned-tee',
    name: 'Crowned T-Shirt',
    subtitle: 'Oversized Heavyweight Tee',
    price: 26.99,
    category: ProductCategory.tees,
    collection: CollectionId.psalm23,
    description:
        'A structured, boxy tee in heavyweight cotton jersey, printed with a crown of thorns and our wordmark at the chest — a quiet reminder of what the crown cost.',
    verse: const VerseRef(text: 'He will receive the crown of life.', reference: 'James 1:12'),
    colors: [
      const ColorVariant(
        name: 'Black',
        hex: '#0A0A0A',
        images: [AppImages.crownedTeeFrontBlack, AppImages.crownedTeeBackBlack],
      ),
      // Only a front shot exists for this colorway — no back image to show yet.
      const ColorVariant(
        name: 'Light Apricot',
        hex: '#F1D9C4',
        images: [AppImages.crownedTeeFrontLightApricot],
      ),
    ],
    sizes: _realSizesWith3xl,
    bestsellerRank: 2,
    addedOn: '2026-08-14',
    details: const [
      'Oversized boxy fit, cropped slightly at the hem',
      'Thick ribbed collar that holds its shape',
      'Crown-of-thorns print at chest',
      'Pre-shrunk to minimise shrinkage',
    ],
    fabric: '100% combed cotton jersey.',
    care: _heavyCare,
  ),
  // "Saved Joggers(MB/G) £24.20" from Stock Inventory.txt.
  Product(
    id: 'saved-joggers',
    name: 'Saved Joggers',
    subtitle: 'Relaxed Fleece Jogger',
    price: 24.20,
    category: ProductCategory.bottoms,
    collection: CollectionId.sabbath,
    description:
        'A relaxed, straight-leg jogger cut from the same fleece as our hoodies, printed with our mark and a portrait of Christ at the lower leg. Made for the day you set apart.',
    verse: const VerseRef(
        text: 'Come to me, all who labor and are heavy laden, and I will give you rest.',
        reference: 'Matthew 11:28'),
    colors: [
      const ColorVariant(
        name: 'Medium Blue',
        hex: '#7FA8D9',
        images: [AppImages.savedJoggersFrontMediumBlue, AppImages.savedJoggersBackMediumBlue],
      ),
      // Only a back shot exists for this colorway — no front image to show yet.
      const ColorVariant(name: 'Grey', hex: '#8C8C88', images: [AppImages.savedJoggersBackGrey]),
    ],
    sizes: _realSizes,
    bestsellerRank: 3,
    addedOn: '2026-09-12',
    details: const ['Straight leg, elastic waist with drawcord', 'Side pockets', 'Printed leg graphic'],
    fabric: '100% organic cotton, brushed fleece.',
    care: _heavyCare,
  ),
  // "Identity Polo £21.40" from Stock Inventory.txt.
  Product(
    id: 'identity-polo',
    name: 'Identity Polo',
    subtitle: 'Piped Pique Polo',
    price: 21.40,
    category: ProductCategory.tees,
    collection: CollectionId.essentials,
    description:
        'A clean pique polo with contrast white piping and collar, printed "Child of God" across the back — smart enough for church, relaxed enough for everywhere else.',
    verse: const VerseRef(
        text: 'So you are no longer a slave, but a son, and if a son, then an heir through God.',
        reference: 'Galatians 3:26'),
    colors: const [
      ColorVariant(
        name: 'Black',
        hex: '#0A0A0A',
        images: [AppImages.identityPoloFrontBlack, AppImages.identityPoloBackBlack],
      ),
    ],
    sizes: _realSizesWith3xl,
    bestsellerRank: 4,
    addedOn: '2026-10-30',
    details: const ['Ribbed polo collar with contrast piping', 'Three-button placket', '"Child of God" back print'],
    fabric: '100% cotton pique.',
    care: _heavyCare,
  ),
  // "Identity Shorts £27.60" from Stock Inventory.txt.
  Product(
    id: 'identity-shorts',
    name: 'Identity Shorts',
    subtitle: 'Relaxed Fleece Short',
    price: 27.60,
    category: ProductCategory.bottoms,
    collection: CollectionId.essentials,
    description: 'A relaxed fleece short cut from the same fabric as our joggers, for warmer days set apart.',
    colors: const [
      ColorVariant(
        name: 'Black',
        hex: '#0A0A0A',
        images: [AppImages.identityShortsFrontBlack, AppImages.identityShortsBackBlack],
      ),
    ],
    sizes: _realSizes,
    bestsellerRank: 5,
    addedOn: '2026-10-30',
    details: const ['Elastic waist with drawcord', 'Side pockets'],
    fabric: '100% organic cotton, brushed fleece.',
    care: _heavyCare,
  ),
];
