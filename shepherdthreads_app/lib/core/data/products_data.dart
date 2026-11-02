import '../constants/app_images.dart';
import '../models/product.dart';

/// Ported from react-source/src/data/products.ts.
/// This is the mock dataset backing MockProductRepository until Stage 10
/// swaps it for Supabase-backed queries.

const _apparelSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

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
  // Real product — name/price from Stock Inventory.txt ("Saved Hoodie(MB/G) £23.40");
  // photography in assets/images/. Was "Good Shepherd Hoodie" in the original mock data.
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
    sizes: _apparelSizes,
    soldOutSizes: const ['XS'],
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
  // Real product — "Crowned T-Shirt(LA/B) £26.99" from Stock Inventory.txt.
  // Was "Psalm 23 Tee" in the original mock data.
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
    sizes: _apparelSizes,
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
  Product(
    id: 'still-waters-crewneck',
    name: 'Still Waters Crewneck',
    subtitle: 'Garment-Dyed Fleece',
    price: 98,
    category: ProductCategory.crewnecks,
    collection: CollectionId.psalm23,
    description:
        'Garment-dyed in a soft stone grey that only gets better with wear. Relaxed through the body with a slightly cropped length to sit well over trousers.',
    verse: const VerseRef(text: 'He leads me beside still waters.', reference: 'Psalm 23:2'),
    colors: [ColorVariant(name: 'Stone', hex: '#9A9893', images: [AppImages.crewStone, AppImages.crewModel])],
    sizes: _apparelSizes,
    soldOutSizes: const ['XXL'],
    bestsellerRank: 4,
    addedOn: '2026-08-14',
    details: const [
      'Relaxed fit, slightly cropped',
      'Garment-dyed — each piece varies subtly',
      'Flatlock seams for comfort',
    ],
    fabric: '100% organic cotton, 420gsm loopback fleece.',
    care: _heavyCare,
  ),
  Product(
    id: 'threaded-crook-cap',
    name: 'Threaded Crook Cap',
    subtitle: 'Unstructured Six-Panel',
    price: 42,
    category: ProductCategory.headwear,
    collection: CollectionId.essentials,
    description:
        'A low-profile, unstructured cap in washed cotton twill with our crook-and-cross mark embroidered tonally at the front.',
    colors: [ColorVariant(name: 'Black', hex: '#0A0A0A', images: [AppImages.capBlack, AppImages.capModel])],
    sizes: const ['One Size'],
    bestsellerRank: 3,
    addedOn: '2026-06-20',
    details: const ['Adjustable brass slide closure', 'Curved brim', 'Tonal embroidery'],
    fabric: '100% cotton twill, enzyme washed.',
    care: const ['Spot clean only', 'Reshape while damp', 'Do not machine wash'],
  ),
  Product(
    id: 'narrow-path-long-sleeve',
    name: 'Narrow Path Long Sleeve',
    subtitle: 'Heavyweight Long Sleeve',
    price: 64,
    category: ProductCategory.tees,
    collection: CollectionId.essentials,
    description:
        'A clean long sleeve with a relaxed body and slim cuff. Made for layering, built to hold up through the seasons.',
    verse: const VerseRef(
        text: 'Narrow is the gate and difficult is the way which leads to life.',
        reference: 'Matthew 7:14'),
    colors: [
      ColorVariant(name: 'Black', hex: '#0A0A0A', images: [AppImages.longsleeveBlack, AppImages.lookbookField]),
    ],
    sizes: _apparelSizes,
    isNew: true,
    bestsellerRank: 6,
    addedOn: '2026-10-18',
    details: const ['Relaxed body, slim ribbed cuffs', 'Tonal back-neck print', 'Side-seamed construction'],
    fabric: '100% combed cotton, 240gsm jersey.',
    care: _heavyCare,
  ),
  Product(
    id: 'selah-beanie',
    name: 'Selah Beanie',
    subtitle: 'Merino Rib Knit',
    price: 38,
    category: ProductCategory.headwear,
    collection: CollectionId.sabbath,
    description: 'A fine-ribbed merino beanie with a deep fold. Selah — pause, and reflect.',
    colors: [ColorVariant(name: 'Stone', hex: '#9A9893', images: [AppImages.beanieStone, AppImages.lookbookDetail])],
    sizes: const ['One Size'],
    soldOut: true,
    bestsellerRank: 5,
    addedOn: '2026-10-01',
    details: const ['Double-layer fold cuff', 'Fine 2×2 rib', 'Woven label at cuff'],
    fabric: '100% extra-fine merino wool.',
    care: const ['Hand wash cold', 'Lay flat to dry'],
  ),
  Product(
    id: 'washed-grace-tee',
    name: 'Washed Grace Tee',
    subtitle: 'Garment-Dyed Tee',
    price: 44,
    compareAt: 54,
    category: ProductCategory.tees,
    collection: CollectionId.psalm23,
    description:
        'Our heavyweight tee, washed down to a soft stone grey with a lived-in hand. Grace, by definition, is undeserved — this price is too.',
    verse: const VerseRef(text: 'For by grace you have been saved through faith.', reference: 'Ephesians 2:8'),
    colors: [ColorVariant(name: 'Stone', hex: '#9A9893', images: [AppImages.teeStone, AppImages.teeCreamModel])],
    sizes: _apparelSizes,
    soldOutSizes: const ['XS', 'S'],
    bestsellerRank: 8,
    addedOn: '2026-07-10',
    details: const ['Oversized boxy fit', 'Garment-dyed and enzyme washed', 'Ribbed collar'],
    fabric: '100% cotton, 260gsm jersey.',
    care: _heavyCare,
  ),
  Product(
    id: 'cornerstone-crewneck',
    name: 'Cornerstone Crewneck',
    subtitle: 'Heavyweight Fleece',
    price: 98,
    category: ProductCategory.crewnecks,
    collection: CollectionId.essentials,
    description:
        'A foundational crew in natural ecru. Heavy enough to stand on its own in autumn, clean enough to wear anywhere.',
    verse: const VerseRef(
        text: 'The stone the builders rejected has become the cornerstone.', reference: 'Psalm 118:22'),
    colors: [ColorVariant(name: 'Ecru', hex: '#E8E0CF', images: [AppImages.crewCream, AppImages.capModel])],
    sizes: _apparelSizes,
    isNew: true,
    bestsellerRank: 7,
    addedOn: '2026-10-24',
    details: const ['Relaxed fit', 'Raglan shoulder seam', 'V-insert at neck'],
    fabric: '100% organic cotton, 480gsm brushed fleece.',
    care: _heavyCare,
  ),
  Product(
    id: 'shepherds-zip-hoodie',
    name: 'Shepherd’s Zip Hoodie',
    subtitle: 'Full-Zip Heavyweight',
    price: 128,
    category: ProductCategory.hoodies,
    collection: CollectionId.essentials,
    description:
        'The full-zip version of our signature fleece with a matte black two-way zip and deep hand pockets.',
    colors: [ColorVariant(name: 'Black', hex: '#0A0A0A', images: [AppImages.zipBlack, AppImages.hoodieModel])],
    sizes: _apparelSizes,
    isNew: true,
    bestsellerRank: 9,
    addedOn: '2026-10-28',
    details: const ['Two-way matte metal zip', 'Double-layer hood', 'Hidden phone pocket'],
    fabric: '100% organic cotton, 480gsm brushed fleece.',
    care: _heavyCare,
  ),
  // Real product — "Saved Joggers(MB/G) £24.20" from Stock Inventory.txt.
  // Was "Sabbath Sweatpant" in the original mock data.
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
    sizes: _apparelSizes,
    bestsellerRank: 10,
    addedOn: '2026-09-12',
    details: const ['Straight leg, elastic waist with drawcord', 'Side pockets', 'Printed leg graphic'],
    fabric: '100% organic cotton, brushed fleece.',
    care: _heavyCare,
  ),
  // Real product — "Identity Polo £21.40" from Stock Inventory.txt. No
  // photography yet — placeholder images until supplied.
  Product(
    id: 'identity-polo',
    name: 'Identity Polo',
    subtitle: 'Pique Polo Shirt',
    price: 21.40,
    category: ProductCategory.tees,
    collection: CollectionId.essentials,
    description:
        'A clean pique polo for anywhere a tee won’t do — smart enough for church, relaxed enough for everywhere else.',
    colors: [
      ColorVariant(name: 'Black', hex: '#0A0A0A', images: [AppImages.identityPolo]),
    ],
    sizes: _apparelSizes,
    bestsellerRank: 12,
    addedOn: '2026-10-30',
    details: const ['Ribbed polo collar', 'Three-button placket', 'Side vents'],
    fabric: '100% cotton pique.',
    care: _heavyCare,
  ),
  // Real product — "Identity Shorts £27.60" from Stock Inventory.txt. No
  // photography yet — placeholder images until supplied.
  Product(
    id: 'identity-shorts',
    name: 'Identity Shorts',
    subtitle: 'Relaxed Fleece Short',
    price: 27.60,
    category: ProductCategory.bottoms,
    collection: CollectionId.essentials,
    description: 'A relaxed fleece short cut from the same fabric as our joggers, for warmer days set apart.',
    colors: [
      ColorVariant(name: 'Grey', hex: '#8C8C88', images: [AppImages.identityShorts]),
    ],
    sizes: _apparelSizes,
    bestsellerRank: 13,
    addedOn: '2026-10-30',
    details: const ['Elastic waist with drawcord', 'Side pockets'],
    fabric: '100% organic cotton, brushed fleece.',
    care: _heavyCare,
  ),
  Product(
    id: 'daily-bread-tote',
    name: 'Daily Bread Tote',
    subtitle: '16oz Canvas Tote',
    price: 36,
    category: ProductCategory.accessories,
    collection: CollectionId.sabbath,
    description:
        'A sturdy canvas tote with cotton webbing handles. Carries your Bible, your laptop, or the week’s groceries.',
    verse: const VerseRef(text: 'Give us this day our daily bread.', reference: 'Matthew 6:11'),
    colors: [ColorVariant(name: 'Natural', hex: '#E9E1CF', images: [AppImages.tote, AppImages.lookbookDetail])],
    sizes: const ['One Size'],
    bestsellerRank: 11,
    addedOn: '2026-05-30',
    details: const ['16oz natural canvas', 'Interior slip pocket', 'Embroidered cross at corner'],
    fabric: '100% cotton canvas.',
    care: const ['Spot clean', 'Hang to dry'],
  ),
];
