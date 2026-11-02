export type JournalCategory = 'Devotional' | 'Style' | 'Behind the Seams' | 'Community';

export interface JournalPost {
  slug: string;
  title: string;
  category: JournalCategory;
  excerpt: string;
  image: string;
  author: string;
  date: string;
  readTime: string;
  featured?: boolean;
  body: string[];
  pullQuote?: {text: string;reference: string;};
}

export interface FaqItem {
  q: string;
  a: string;
}

export interface FaqGroup {
  id: string;
  title: string;
  items: FaqItem[];
}

export interface Testimonial {
  name: string;
  location: string;
  quote: string;
  product: string;
  image: string;
}