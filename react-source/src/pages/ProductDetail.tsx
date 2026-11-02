import React, { useEffect, useRef, useState } from 'react';
import { Link, useParams, useSearchParams } from 'react-router-dom';
import { AnimatePresence, motion } from 'framer-motion';
import { HeartIcon, RotateCcwIcon, RulerIcon, TruckIcon } from 'lucide-react';
import { useStore } from '../contexts/StoreContext';
import { ProductGallery } from '../components/product/ProductGallery';
import { ProductCarousel } from '../components/product/ProductCarousel';
import { ColorSwatches } from '../components/ColorSwatches';
import { Price } from '../components/Price';
import { Button } from '../components/Button';
import { AccordionItem } from '../components/Accordion';
import { SizeGuideModal } from '../components/SizeGuideModal';
import { NotFound } from './NotFound';
import { getColor, getProduct, relatedProducts } from '../utils/products';
import { formatPrice } from '../utils/currency';

export function ProductDetail() {
  const { productId = '' } = useParams();
  const [params] = useSearchParams();
  const product = getProduct(productId);
  const { addToCart, toggleWishlist, isWishlisted } = useStore();

  const [colorName, setColorName] = useState(params.get('color') ?? '');
  const [size, setSize] = useState<string | null>(null);
  const [sizeError, setSizeError] = useState(false);
  const [guideOpen, setGuideOpen] = useState(false);
  const [notified, setNotified] = useState(false);
  const [showSticky, setShowSticky] = useState(false);
  const ctaRef = useRef<HTMLDivElement>(null);
  const sizeRef = useRef<HTMLFieldSetElement>(null);

  useEffect(() => {
    setColorName(params.get('color') ?? '');
    setSize(product && product.sizes.length === 1 ? product.sizes[0] : null);
    setSizeError(false);
    setNotified(false);
  }, [productId]); // eslint-disable-line react-hooks/exhaustive-deps

  useEffect(() => {
    const el = ctaRef.current;
    if (!el) return;
    const io = new IntersectionObserver(([entry]) => setShowSticky(!entry.isIntersecting && entry.boundingClientRect.top < 0), { threshold: 0 });
    io.observe(el);
    return () => io.disconnect();
  }, [productId]);

  if (!product) return <NotFound />;
  const color = getColor(product, colorName);
  const saved = isWishlisted(product.id);

  const handleAdd = () => {
    if (!size) {
      setSizeError(true);
      sizeRef.current?.scrollIntoView({ behavior: 'smooth', block: 'center' });
      return;
    }
    addToCart(product.id, color.name, size);
  };

  return (
    <div className="bg-white">
      <div className="mx-auto max-w-site md:px-8 md:pt-8">
        <nav aria-label="Breadcrumb" className="hidden text-[12px] text-stone md:block">
          <Link to="/" className="hover:text-ink">Home</Link> / <Link to="/shop" className="hover:text-ink">Shop</Link> /{' '}
          <Link to={`/shop?category=${product.category}`} className="hover:text-ink">{product.category}</Link> / <span className="text-ink">{product.name}</span>
        </nav>

        <div className="grid gap-8 md:mt-6 md:grid-cols-[1.2fr_1fr] md:gap-12 lg:gap-20">
          <ProductGallery images={color.images} alt={`${product.name} in ${color.name}`} />

          <div className="px-5 md:px-0">
            <div className="md:sticky md:top-28">
              {product.isNew && <p className="text-[12px] tracking-[0.1em] text-stone">New this season</p>}
              <h1 className="mt-1 font-serif text-[32px] leading-tight md:text-[40px]">{product.name}</h1>
              <p className="mt-1 text-[14px] text-stone">{product.subtitle}</p>
              <Price price={product.price} compareAt={product.compareAt} className="mt-4 text-[18px]" />

              <p className="mt-6 text-[15px] leading-relaxed text-ink/75">{product.description}</p>
              {product.verse &&
              <p className="mt-5 border-l border-brass pl-4 font-serif text-[16px] italic text-ink/80">
                  “{product.verse.text}” <span className="not-italic font-sans text-[12px] text-stone">— {product.verse.reference}</span>
                </p>
              }

              <div className="mt-8">
                <p className="text-[13px]">
                  Color: <span className="text-stone">{color.name}</span>
                </p>
                <div className="mt-3">
                  <ColorSwatches colors={product.colors} selected={color.name} onSelect={setColorName} size="lg" />
                </div>
              </div>

              {product.sizes.length > 1 &&
              <fieldset ref={sizeRef} className="mt-8">
                  <div className="flex items-center justify-between">
                    <legend className="text-[13px]">
                      Size: <span className="text-stone">{size ?? 'Select'}</span>
                    </legend>
                    <button type="button" onClick={() => setGuideOpen(true)} className="flex items-center gap-1.5 text-[12px] underline underline-offset-4">
                      <RulerIcon className="h-3.5 w-3.5" /> Size guide
                    </button>
                  </div>
                  <div className="mt-3 grid grid-cols-6 gap-2">
                    {product.sizes.map((s) => {
                    const out = product.soldOut || product.soldOutSizes?.includes(s);
                    const active = size === s;
                    return (
                      <button
                        key={s}
                        type="button"
                        disabled={out}
                        aria-pressed={active}
                        onClick={() => {
                          setSize(s);
                          setSizeError(false);
                        }}
                        className={`h-11 border text-[13px] transition-colors ${
                        active ? 'border-ink bg-ink text-white' : 'border-hairline hover:border-ink'} disabled:cursor-not-allowed disabled:text-stone/50 disabled:line-through disabled:hover:border-hairline`
                        }>
                        
                          {s}
                        </button>);

                  })}
                  </div>
                  {sizeError &&
                <p className="mt-2 text-[12px] text-brass" role="alert">
                      Please choose a size.
                    </p>
                }
                  <p className="mt-3 text-[12px] text-stone">Boxy, oversized fit. Between sizes? Size down.</p>
                </fieldset>
              }

              <div ref={ctaRef} className="mt-8 flex gap-3">
                {product.soldOut ?
                <Button full disabled={notified} onClick={() => setNotified(true)} variant="outline">
                    {notified ? 'We’ll email you when it’s back' : 'Sold out — Notify me'}
                  </Button> :

                <Button full size="lg" onClick={handleAdd}>
                    Add to bag · {formatPrice(product.price)}
                  </Button>
                }
                <button
                  onClick={() => toggleWishlist(product.id)}
                  aria-pressed={saved}
                  aria-label={saved ? 'Remove from wishlist' : 'Save to wishlist'}
                  className="flex h-14 w-14 shrink-0 items-center justify-center border border-hairline transition-colors hover:border-ink">
                  
                  <HeartIcon className={`h-5 w-5 ${saved ? 'fill-ink' : ''}`} strokeWidth={1.5} />
                </button>
              </div>

              <ul className="mt-6 space-y-2 text-[13px] text-ink/70">
                <li className="flex items-center gap-3"><TruckIcon className="h-4 w-4" strokeWidth={1.5} /> Free U.S. shipping on orders over $150</li>
                <li className="flex items-center gap-3"><RotateCcwIcon className="h-4 w-4" strokeWidth={1.5} /> Free returns and exchanges within 30 days</li>
              </ul>

              <div className="mt-8 border-t border-hairline">
                <AccordionItem title="Details & Fabric" defaultOpen>
                  <ul className="list-disc space-y-1.5 pl-4">
                    {product.details.map((d) => <li key={d}>{d}</li>)}
                  </ul>
                  <p className="mt-3">{product.fabric}</p>
                </AccordionItem>
                <AccordionItem title="Shipping & Returns">
                  <p>Orders placed before 1pm ET ship the same day. Standard delivery in 3–5 business days, free over $150. Returns are free within 30 days of delivery on unworn items.</p>
                </AccordionItem>
                <AccordionItem title="Care Instructions">
                  <ul className="list-disc space-y-1.5 pl-4">
                    {product.care.map((c) => <li key={c}>{c}</li>)}
                  </ul>
                </AccordionItem>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="mt-8 border-t border-hairline">
        <ProductCarousel title="You may also like" products={relatedProducts(product)} />
      </div>

      <AnimatePresence>
        {showSticky && !product.soldOut &&
        <motion.div
          initial={{ y: '100%' }}
          animate={{ y: 0 }}
          exit={{ y: '100%' }}
          transition={{ duration: 0.22, ease: [0.23, 1, 0.32, 1] }}
          className="fixed inset-x-0 bottom-16 z-30 border-t border-hairline bg-white px-4 py-3 md:hidden">
          
            <div className="flex items-center gap-3">
              <img src={color.images[0]} alt="" className="h-12 w-10 bg-cream object-cover" />
              <div className="min-w-0 flex-1">
                <p className="truncate text-[13px] font-medium">{product.name}</p>
                <p className="text-[12px] text-stone">{color.name}{size ? ` · ${size}` : ''} · {formatPrice(product.price)}</p>
              </div>
              <Button size="sm" onClick={handleAdd}>{size ? 'Add to bag' : 'Select size'}</Button>
            </div>
          </motion.div>
        }
      </AnimatePresence>

      <SizeGuideModal open={guideOpen} onClose={() => setGuideOpen(false)} />
    </div>);

}