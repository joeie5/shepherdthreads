import React from 'react';
import { ButtonLink } from '../components/Button';
import { LogoMark } from '../components/Logo';
import { images } from '../data/images';

const journey = [
{ title: 'Grown', place: 'Texas, USA', text: 'Certified organic cotton from family farms in the Texas High Plains — no synthetic pesticides, rain-fed where possible.' },
{ title: 'Knit', place: 'Porto, Portugal', text: 'Spun and knit into 480gsm fleece by the Silva family, who have been working the same machines for three generations.' },
{ title: 'Sewn', place: 'Los Angeles & Porto', text: 'Cut and sewn in small runs by teams paid a living wage — with Sundays off, always.' },
{ title: 'Given', place: 'Wherever you are', text: '10% of every order funds clean-water wells in East Africa and church-based youth mentorship at home.' }];


function PullQuote({ text, reference, tone = 'cream' }: {text: string;reference: string;tone?: 'cream' | 'ink';}) {
  return (
    <section className={tone === 'cream' ? 'bg-cream text-ink' : 'bg-ink text-white'}>
      <figure className="mx-auto max-w-4xl px-5 py-20 text-center md:py-28">
        <blockquote className="font-serif text-[30px] italic leading-snug md:text-[46px]">“{text}”</blockquote>
        <figcaption className={`mt-6 text-[12px] uppercase tracking-[0.2em] ${tone === 'cream' ? 'text-stone' : 'text-white/55'}`}>{reference}</figcaption>
      </figure>
    </section>);

}

export function OurStory() {
  return (
    <article className="bg-white">
      {/* Opening */}
      <header className="bg-ink text-white">
        <div className="mx-auto max-w-5xl px-5 pb-14 pt-16 md:pb-20 md:pt-28">
          <p className="text-[12px] tracking-[0.14em] text-white/55">Our Story</p>
          <h1 className="mt-5 font-serif text-[44px] leading-[1.04] md:text-[84px]">A thread worth following.</h1>
          <p className="mt-8 max-w-2xl text-[17px] leading-relaxed text-white/70">
            Shepherds Thread began at a kitchen table in Atlanta with a simple question: what would it look like to make clothing the way we hope to live?
          </p>
        </div>
        <img src={images.workshop} alt="Hands guiding heavy cotton through a sewing machine in our partner workshop" className="aspect-[16/9] w-full object-cover md:aspect-[21/9]" />
      </header>

      {/* Founder */}
      <section className="mx-auto grid max-w-site gap-10 px-5 py-20 md:grid-cols-12 md:gap-16 md:px-8 md:py-28">
        <div className="md:col-span-5">
          <img src={images.founder} alt="Daniel Okafor, founder of Shepherds Thread, in the studio" className="aspect-[4/5] w-full object-cover" />
          <p className="mt-3 text-[13px] text-stone">Daniel Okafor, founder — in the Atlanta studio</p>
        </div>
        <div className="md:col-span-7 md:pt-8">
          <h2 className="font-serif text-[32px] uppercase leading-tight tracking-[0.05em] md:text-[40px]">The mission</h2>
          <div className="mt-8 space-y-6 font-serif text-[19px] leading-[1.7] text-ink/85">
            <p>
              I grew up in church wearing whatever the youth group printed that summer. I loved what those shirts meant. I never loved wearing them.
            </p>
            <p>
              Years later, working in fashion, I saw the other side — beautiful garments made carelessly, by people who were treated as costs. Neither world felt like the Kingdom.
            </p>
            <p>
              Shepherds Thread is our attempt to hold both: clothes made with the patience and quality of the best streetwear, carrying a quiet reminder of the One who knows us by name.
            </p>
          </div>
          <p className="mt-10 font-serif text-[22px] italic">— Daniel</p>
        </div>
      </section>

      <PullQuote text="I am the good shepherd. I know my own and my own know me." reference="John 10:14" />

      {/* Faith / mark */}
      <section className="mx-auto grid max-w-site items-center gap-12 px-5 py-20 md:grid-cols-2 md:px-8 md:py-28">
        <div className="flex aspect-square items-center justify-center bg-ink text-white">
          <LogoMark className="h-[55%] w-auto" />
        </div>
        <div className="md:pl-8">
          <h2 className="font-serif text-[32px] uppercase leading-tight tracking-[0.05em] md:text-[40px]">The mark</h2>
          <div className="mt-8 space-y-5 text-[16px] leading-relaxed text-ink/75">
            <p>
              Our mark is a single continuous idea. A shepherd’s crook — the tool of the one who goes after the lost. A cross — where that pursuit was finished. And a needle, threaded — the slow, faithful work of making something well.
            </p>
            <p>
              It sits small on every piece. Not to announce anything, but to remind the person wearing it. If someone asks, you’ll have a story to tell.
            </p>
          </div>
        </div>
      </section>

      <img src={images.lookbookDetail} alt="A needle with cream thread on heavyweight black cotton" className="aspect-[16/9] w-full object-cover md:aspect-[21/8]" />

      {/* Sourcing */}
      <section className="bg-ink text-white">
        <div className="mx-auto max-w-site px-5 py-20 md:px-8 md:py-28">
          <div className="max-w-2xl">
            <h2 className="font-serif text-[32px] uppercase leading-tight tracking-[0.05em] md:text-[44px]">From field to fold</h2>
            <p className="mt-4 text-[16px] text-white/65">Every garment passes through four sets of hands before it reaches yours. We know each of them by name.</p>
          </div>
          <ol className="mt-14 grid gap-10 md:grid-cols-4 md:gap-8">
            {journey.map((j, i) =>
            <li key={j.title} className="border-t border-white/20 pt-6">
                <p className="text-[12px] tabular-nums text-white/45">{String(i + 1).padStart(2, '0')}</p>
                <h3 className="mt-3 font-serif text-[28px]">{j.title}</h3>
                <p className="mt-1 text-[13px] text-brass">{j.place}</p>
                <p className="mt-4 text-[14px] leading-relaxed text-white/70">{j.text}</p>
              </li>
            )}
          </ol>
        </div>
      </section>

      <PullQuote text="Whatever you do, work heartily, as for the Lord and not for men." reference="Colossians 3:23" />

      {/* Close */}
      <section className="mx-auto max-w-3xl px-5 py-20 text-center md:py-28">
        <p className="font-serif text-[64px] leading-none md:text-[96px]">$184,000</p>
        <p className="mt-4 text-[16px] text-ink/70">given to clean water and youth mentorship since 2024 — because of people like you.</p>
        <div className="mt-10 flex flex-col justify-center gap-3 sm:flex-row">
          <ButtonLink to="/shop" size="lg">Shop the collection</ButtonLink>
          <ButtonLink to="/journal" size="lg" variant="outline">Read the journal</ButtonLink>
        </div>
      </section>
    </article>);

}