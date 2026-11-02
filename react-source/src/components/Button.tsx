import React from 'react';
import { Link, type LinkProps } from 'react-router-dom';

type Variant = 'primary' | 'inverse' | 'outline' | 'outlineLight';
type Size = 'sm' | 'md' | 'lg';

const base =
'inline-flex items-center justify-center gap-2 whitespace-nowrap font-medium uppercase tracking-[0.12em] transition-colors duration-150 ease-out disabled:cursor-not-allowed disabled:opacity-40 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2';

const variants: Record<Variant, string> = {
  primary: 'bg-ink text-white hover:bg-[#262626] focus-visible:outline-ink',
  inverse: 'bg-white text-ink hover:bg-cream focus-visible:outline-white',
  outline: 'border border-ink text-ink hover:bg-ink hover:text-white focus-visible:outline-ink',
  outlineLight: 'border border-white/50 text-white hover:bg-white hover:text-ink focus-visible:outline-white'
};

const sizes: Record<Size, string> = {
  sm: 'h-10 px-5 text-[11px]',
  md: 'h-12 px-7 text-[12px]',
  lg: 'h-14 px-10 text-[12px]'
};

export function buttonClass(variant: Variant = 'primary', size: Size = 'md', full = false) {
  return `${base} ${variants[variant]} ${sizes[size]} ${full ? 'w-full' : ''}`;
}

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
  size?: Size;
  full?: boolean;
}

export function Button({ variant = 'primary', size = 'md', full, className = '', ...rest }: ButtonProps) {
  return <button className={`${buttonClass(variant, size, full)} ${className}`} {...rest} />;
}

interface ButtonLinkProps extends LinkProps {
  variant?: Variant;
  size?: Size;
  full?: boolean;
}

export function ButtonLink({ variant = 'primary', size = 'md', full, className = '', ...rest }: ButtonLinkProps) {
  return <Link className={`${buttonClass(variant, size, full)} ${className}`} {...rest} />;
}