/// Ported from react-source/src/data/navigation.ts
library;

class NavItem {
  final String label;
  final String to;
  const NavItem(this.label, this.to);
}

const primaryNav = [
  NavItem('Shop', '/shop'),
  NavItem('Collections', '/collections'),
  NavItem('Our Story', '/our-story'),
  NavItem('Journal', '/journal'),
];

const footerShopLinks = [
  NavItem('All Products', '/shop'),
  NavItem('Hoodies', '/shop?category=Hoodies'),
  NavItem('Crewnecks', '/shop?category=Crewnecks'),
  NavItem('Tees', '/shop?category=Tees'),
  NavItem('Headwear', '/shop?category=Headwear'),
  NavItem('Accessories', '/shop?category=Accessories'),
];

const footerBrandLinks = [
  NavItem('Our Story', '/our-story'),
  NavItem('Journal', '/journal'),
  NavItem('FAQ', '/faq'),
  NavItem('Contact', '/contact'),
  NavItem('My Account', '/account'),
];

class VerseOfTheMonth {
  final String month;
  final String text;
  final String reference;
  const VerseOfTheMonth({required this.month, required this.text, required this.reference});
}

const verseOfTheMonth = VerseOfTheMonth(
  month: 'November',
  text: 'I am the good shepherd. The good shepherd lays down his life for the sheep.',
  reference: 'John 10:11',
);
