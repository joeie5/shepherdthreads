export type Category =
'Hoodies' |
'Crewnecks' |
'Tees' |
'Headwear' |
'Bottoms' |
'Accessories';

export type CollectionId = 'psalm-23' | 'essentials' | 'sabbath';

export interface ColorVariant {
  name: string;
  hex: string;
  images: string[];
}

export interface Product {
  id: string;
  name: string;
  subtitle: string;
  price: number;
  compareAt?: number;
  category: Category;
  collection: CollectionId;
  description: string;
  verse?: {text: string;reference: string;};
  colors: ColorVariant[];
  sizes: string[];
  soldOutSizes?: string[];
  soldOut?: boolean;
  isNew?: boolean;
  bestsellerRank: number;
  addedOn: string;
  details: string[];
  fabric: string;
  care: string[];
}

export interface Collection {
  id: CollectionId;
  name: string;
  description: string;
}