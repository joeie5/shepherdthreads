import React from 'react';

interface LogoMarkProps {
  className?: string;
}

export function LogoMark({ className = 'h-7 w-6' }: LogoMarkProps) {
  return (
    <svg viewBox="0 0 32 44" fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" className={className} aria-hidden="true">
      {/* crook */}
      <path d="M16 12 C16 5 25 4 25 10.5 C25 13 23.4 14.2 21.8 13.8" strokeWidth="1.6" />
      {/* shaft / needle */}
      <path d="M16 12 V40" strokeWidth="1.6" />
      <path d="M15.2 37.5 L16 42 L16.8 37.5" strokeWidth="1.2" />
      {/* needle eye */}
      <path d="M16 15.5 V19" strokeWidth="3.2" stroke="currentColor" opacity="0.18" />
      {/* crossbar */}
      <path d="M9 22 H23" strokeWidth="1.6" />
      {/* thread */}
      <path d="M16.4 17 C 23 18.5, 24 25, 18 27 C 12.5 28.8, 11 32, 13.5 35" strokeWidth="0.9" />
    </svg>);

}

interface LogoProps {
  className?: string;
  showTagline?: boolean;
}

export function Logo({ className = '', showTagline = true }: LogoProps) {
  return (
    <span className={`inline-flex items-center gap-2.5 ${className}`}>
      <LogoMark className="h-8 w-6 shrink-0" />
      <span className="flex flex-col items-start leading-none">
        <span className="whitespace-nowrap font-serif text-[13px] uppercase tracking-[0.16em] sm:text-[16px] sm:tracking-[0.2em]">
          Shepherds Thread
        </span>
        {showTagline &&
        <span className="mt-1 whitespace-nowrap text-[9px] uppercase tracking-[0.3em] opacity-60">Christian Clothing</span>
        }
      </span>
    </span>);

}