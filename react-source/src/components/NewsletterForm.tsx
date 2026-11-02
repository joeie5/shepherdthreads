import React, { useState } from 'react';
import { ArrowRightIcon, CheckIcon } from 'lucide-react';

interface NewsletterFormProps {
  tone?: 'dark' | 'light';
  id: string;
}

export function NewsletterForm({ tone = 'dark', id }: NewsletterFormProps) {
  const [email, setEmail] = useState('');
  const [state, setState] = useState<'idle' | 'error' | 'success'>('idle');
  const dark = tone === 'dark';

  const submit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      setState('error');
      return;
    }
    setState('success');
  };

  if (state === 'success') {
    return (
      <p className={`flex items-center gap-2 text-[14px] ${dark ? 'text-white' : 'text-ink'}`} role="status">
        <CheckIcon className="h-4 w-4" /> You’re on the list. Watch for a welcome note — and 15% off.
      </p>);

  }

  return (
    <form onSubmit={submit} noValidate>
      <label htmlFor={id} className="sr-only">
        Email address
      </label>
      <div className={`flex items-center border-b ${dark ? 'border-white/40 focus-within:border-white' : 'border-ink/40 focus-within:border-ink'} transition-colors`}>
        <input
          id={id}
          type="email"
          value={email}
          onChange={(e) => {
            setEmail(e.target.value);
            if (state === 'error') setState('idle');
          }}
          placeholder="Your email address"
          aria-invalid={state === 'error'}
          aria-describedby={state === 'error' ? `${id}-error` : undefined}
          className={`h-12 flex-1 bg-transparent text-[15px] outline-none ${dark ? 'text-white placeholder:text-white/40' : 'text-ink placeholder:text-stone'}`} />
        
        <button type="submit" aria-label="Subscribe" className="flex h-12 items-center gap-2 pl-4 text-[12px] font-medium uppercase tracking-[0.12em]">
          Join <ArrowRightIcon className="h-4 w-4" />
        </button>
      </div>
      {state === 'error' &&
      <p id={`${id}-error`} className="mt-2 text-[12px] text-brass">
          Please enter a valid email address.
        </p>
      }
    </form>);

}