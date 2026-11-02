import React from 'react';
import { ButtonLink } from '../components/Button';
import { LogoMark } from '../components/Logo';

export function NotFound() {
  return (
    <section className="flex min-h-[calc(100vh-108px)] items-center bg-ink text-white">
      <div className="mx-auto max-w-2xl px-5 py-20 text-center">
        <LogoMark className="mx-auto h-16 w-12 text-white/80" />
        <p className="mt-8 text-[12px] tracking-[0.2em] text-white/45">Error 404</p>
        <h1 className="mt-4 font-serif text-[40px] leading-tight md:text-[60px]">This page has wandered off.</h1>
        <p className="mx-auto mt-5 max-w-md text-[15px] leading-relaxed text-white/65">
          The link may be broken, or the page may have moved. Don’t worry — we’ll help you find your way back.
        </p>
        <p className="mt-8 font-serif text-[17px] italic text-white/75">
          “…go after the one which is lost until he finds it.” <span className="font-sans text-[12px] not-italic text-white/45">— Luke 15:4</span>
        </p>
        <div className="mt-12 flex flex-col justify-center gap-3 sm:flex-row">
          <ButtonLink to="/shop" variant="inverse" size="lg">Shop the collection</ButtonLink>
          <ButtonLink to="/" variant="outlineLight" size="lg">Back to home</ButtonLink>
        </div>
      </div>
    </section>);

}