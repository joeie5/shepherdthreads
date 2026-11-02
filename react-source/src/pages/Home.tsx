import React from 'react';
import { Link } from 'react-router-dom';
import { ArrowRightIcon } from 'lucide-react';
import { ButtonLink } from '../components/Button';
import { ProductCard } from '../components/ProductCard';
import { SectionHeading } from '../components/SectionHeading';
import { NewsletterForm } from '../components/NewsletterForm';
import { products } from '../data/products';
import { images } from '../data/images';
import { testimonials } from '../data/account';

const featured = [...products].filter((p) => !p.soldOut).sort((a, b) => a.bestsellerRank - b.bestsellerRank).slice(0, 6);

export function Home() {
  return (
    <>
      {/* Hero */}
      <section className="bg-ink text-white">
        <div className="mx-auto grid max-w-site md:min-h-[calc(100vh-108px)] md:grid-cols-2">
          <div className="relative order-1 aspect-[4/5] md:order-2 md:aspect-auto">
            <img src={images.hero} alt="Model wearing the black Good Shepherd Hoodie and Sabbath Sweatpant" className="absolute inset-0 h-full w-full object-cover" />
          </div>
          <div className="order-2 flex flex-col justify-end px-5 pb-14 pt-10 md:order-1 md:justify-center md:px-12 md:py-20 lg:px-20">
            <p className="text-[12px] tracking-[0.14em] text-white/60">Fall 2026 — The Good Shepherd Collection</p>
            <h1 className="mt-5 font-serif text-[48px] leading-[1.02] md:text-[72px] lg:text-[88px]">
              Clothed in
              <br />
              purpose.
            </h1>
            <p className="mt-6 max-w-md text-[16px] leading-relaxed text-white/70">
              Heavyweight essentials made slowly and worn with conviction. Quiet on the outside, rooted on the inside.
            </p>
            <div className="mt-10">
              <ButtonLink to="/shop" variant="inverse" size="lg">
                Shop the collection
              </ButtonLink>
            </div>
          </div>
        </div>
      </section>

      {/* Featured products */}
      <section className="bg-white">
        <div className="mx-auto max-w-site px-5 py-16 md:px-8 md:py-24">
          <SectionHeading title="Shop the Collection" description="Our most-worn pieces this season." linkLabel="View all" linkTo="/shop" />
          <div className="mt-10 grid grid-cols-2 gap-x-3 gap-y-10 md:gap-x-6 lg:grid-cols-3">
            {featured.map((p) =>
            <ProductCard key={p.id} product={p} />
            )}
          </div>
        </div>
      </section>

      {/* Brand story strip */}
      <section className="bg-cream">
        <div className="mx-auto max-w-4xl px-5 py-20 text-center md:py-28">
          <p className="font-serif text-[28px] leading-snug md:text-[44px]">
            We make garments the way we hope to live — slowly, honestly, and for the good of others.
          </p>
          <Link to="/our-story" className="group mt-10 inline-flex items-center gap-2 text-[12px] font-medium uppercase tracking-[0.14em]">
            <span className="underline decoration-1 underline-offset-[6px]">Read our story</span>
            <ArrowRightIcon className="h-4 w-4 transition-transform duration-200 ease-out group-hover:translate-x-1" />
          </Link>
        </div>
      </section>

      {/* Lookbook */}
      <section className="bg-ink text-white">
        <div className="mx-auto max-w-site px-5 py-16 md:px-8 md:py-24">
          <SectionHeading
            tone="dark"
            title="Green Pastures"
            description="The Fall ’26 lookbook. Shot at dawn outside Asheville, North Carolina."
            linkLabel="View the journal"
            linkTo="/journal" />
          
          <div className="mt-10 grid gap-3 md:grid-cols-12 md:gap-4">
            <figure className="relative aspect-[4/5] overflow-hidden md:col-span-7 md:aspect-auto md:min-h-[720px]">
              <img src={images.lookbookField} alt="Two people walking through a golden field at dusk in neutral Shepherds Thread pieces" className="absolute inset-0 h-full w-full object-cover" />
              <figcaption className="absolute bottom-0 left-0 p-5 text-[13px] text-white/85">Psalm 23 Tee in Black · Narrow Path Long Sleeve</figcaption>
            </figure>
            <div className="grid gap-3 md:col-span-5 md:gap-4">
              <figure className="relative aspect-[16/10] overflow-hidden md:aspect-auto">
                <img src={images.lookbookSteps} alt="Woman in the Bone Good Shepherd Hoodie on city steps" className="absolute inset-0 h-full w-full object-cover" />
                <figcaption className="absolute bottom-0 left-0 p-5 text-[13px] text-white/85">Good Shepherd Hoodie in Bone</figcaption>
              </figure>
              <figure className="relative aspect-[16/10] overflow-hidden md:aspect-auto">
                <img src={images.lookbookDetail} alt="A needle with cream thread on heavyweight black cotton" className="absolute inset-0 h-full w-full object-cover" />
                <figcaption className="absolute bottom-0 left-0 p-5 text-[13px] text-white/85">Every stitch, on purpose.</figcaption>
              </figure>
            </div>
          </div>
        </div>
      </section>

      {/* Community */}
      <section className="bg-white">
        <div className="mx-auto max-w-site py-16 md:px-8 md:py-24">
          <div className="px-5 md:px-0">
            <SectionHeading title="As Worn by the Community" description="Share yours with #WornWithPurpose — we feature a new story every week." />
          </div>
          <ul className="scrollbar-none mt-10 flex snap-x snap-mandatory gap-4 overflow-x-auto px-5 md:grid md:grid-cols-4 md:gap-6 md:overflow-visible md:px-0">
            {testimonials.map((t) =>
            <li key={t.name} className="flex w-[78%] shrink-0 snap-start flex-col sm:w-[45%] md:w-auto">
                <div className="aspect-[4/5] overflow-hidden bg-cream">
                  <img src={t.image} alt={`${t.name} wearing the ${t.product}`} loading="lazy" className="h-full w-full object-cover" />
                </div>
                <blockquote className="mt-5 flex-1 font-serif text-[18px] leading-snug">“{t.quote}”</blockquote>
                <div className="mt-5 border-t border-hairline pt-4 text-[13px]">
                  <p className="font-medium">{t.name}</p>
                  <p className="text-stone">
                    {t.location} · {t.product}
                  </p>
                </div>
              </li>
            )}
          </ul>
        </div>
      </section>

      {/* Newsletter band */}
      <section className="bg-ink text-white">
        <div className="mx-auto grid max-w-site gap-8 px-5 py-16 md:grid-cols-2 md:items-center md:px-8 md:py-24">
          <div>
            <h2 className="font-serif text-[32px] uppercase leading-tight tracking-[0.06em] md:text-[44px]">Join the flock</h2>
            <p className="mt-3 max-w-md text-[15px] text-white/65">
              First access to new releases, a monthly devotional, and 15% off your first order.
            </p>
          </div>
          <div className="md:pl-12">
            <NewsletterForm id="home-newsletter" />
            <p className="mt-3 text-[12px] text-white/45">No spam. Unsubscribe anytime.</p>
          </div>
        </div>
      </section>
    </>);

}