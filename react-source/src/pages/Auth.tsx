import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { ArrowLeftIcon, EyeIcon, EyeOffIcon } from 'lucide-react';
import { useStore } from '../contexts/StoreContext';
import { FormField } from '../components/FormField';
import { Button } from '../components/Button';
import { LogoMark } from '../components/Logo';
import { AppleGlyph, GoogleGlyph } from '../components/BrandIcons';

type View = 'login' | 'signup' | 'forgot';

export function Auth() {
  const [view, setView] = useState<View>('login');
  const [show, setShow] = useState(false);
  const [loading, setLoading] = useState(false);
  const [resetSent, setResetSent] = useState(false);
  const [form, setForm] = useState({ name: '', email: '', password: '' });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const { setSignedIn } = useStore();
  const navigate = useNavigate();

  const update = (k: keyof typeof form, v: string) => {
    setForm((f) => ({ ...f, [k]: v }));
    setErrors((e) => ({ ...e, [k]: '' }));
  };

  const submit = (e: React.FormEvent) => {
    e.preventDefault();
    const next: Record<string, string> = {};
    if (view === 'signup' && !form.name.trim()) next.name = 'Please enter your name';
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) next.email = 'Enter a valid email address';
    if (view !== 'forgot' && form.password.length < 8) next.password = 'Password must be at least 8 characters';
    setErrors(next);
    if (Object.keys(next).length) return;
    setLoading(true);
    window.setTimeout(() => {
      setLoading(false);
      if (view === 'forgot') {
        setResetSent(true);
        return;
      }
      setSignedIn(true);
      navigate('/account');
    }, 700);
  };

  const socialLogin = () => {
    setSignedIn(true);
    navigate('/account');
  };

  return (
    <div className="flex min-h-[calc(100vh-108px)] items-center justify-center bg-ink px-4 py-12 md:py-20">
      <div className="w-full max-w-[440px] bg-white p-7 md:p-10">
        <div className="flex flex-col items-center text-center">
          <LogoMark className="h-10 w-8" />
          <h1 className="mt-4 font-serif text-[28px]">
            {view === 'login' ? 'Welcome back' : view === 'signup' ? 'Create your account' : 'Reset your password'}
          </h1>
          <p className="mt-2 text-[14px] text-ink/60">
            {view === 'login' && 'Sign in to track orders and see your wishlist.'}
            {view === 'signup' && 'Faster checkout, order tracking, and early access to new releases.'}
            {view === 'forgot' && 'Enter your email and we’ll send a reset link.'}
          </p>
        </div>

        {view !== 'forgot' &&
        <div className="mt-8 grid grid-cols-2 border-b border-hairline" role="tablist">
            {(['login', 'signup'] as const).map((v) =>
          <button
            key={v}
            role="tab"
            aria-selected={view === v}
            onClick={() => {
              setView(v);
              setErrors({});
            }}
            className={`-mb-px border-b pb-3 text-[13px] uppercase tracking-[0.12em] transition-colors ${view === v ? 'border-ink text-ink' : 'border-transparent text-stone hover:text-ink'}`}>
            
                {v === 'login' ? 'Sign in' : 'Create account'}
              </button>
          )}
          </div>
        }

        {view === 'forgot' && resetSent ?
        <div className="mt-8 bg-cream p-5 text-[14px]" role="status">
            If an account exists for <span className="font-medium">{form.email}</span>, a reset link is on its way. It expires in 30 minutes.
          </div> :

        <form onSubmit={submit} noValidate className="mt-6 space-y-4">
            {view === 'signup' &&
          <FormField id="name" label="Full name" autoComplete="name" value={form.name} onChange={(e) => update('name', e.target.value)} error={errors.name} />
          }
            <FormField id="auth-email" label="Email" type="email" autoComplete="email" value={form.email} onChange={(e) => update('email', e.target.value)} error={errors.email} />
            {view !== 'forgot' &&
          <div className="relative">
                <FormField
              id="password"
              label="Password"
              type={show ? 'text' : 'password'}
              autoComplete={view === 'login' ? 'current-password' : 'new-password'}
              value={form.password}
              onChange={(e) => update('password', e.target.value)}
              error={errors.password}
              hint={view === 'signup' ? 'At least 8 characters' : undefined} />
            
                <button type="button" onClick={() => setShow((s) => !s)} aria-label={show ? 'Hide password' : 'Show password'} className="absolute right-3 top-[38px] p-1 text-stone hover:text-ink">
                  {show ? <EyeOffIcon className="h-4 w-4" /> : <EyeIcon className="h-4 w-4" />}
                </button>
              </div>
          }
            {view === 'login' &&
          <div className="flex justify-end">
                <button type="button" onClick={() => setView('forgot')} className="text-[13px] underline underline-offset-4">
                  Forgot password?
                </button>
              </div>
          }
            <Button type="submit" full size="lg" disabled={loading} aria-busy={loading}>
              {loading ? 'One moment…' : view === 'login' ? 'Sign in' : view === 'signup' ? 'Create account' : 'Send reset link'}
            </Button>
          </form>
        }

        {view === 'forgot' ?
        <button
          onClick={() => {
            setView('login');
            setResetSent(false);
          }}
          className="mx-auto mt-6 flex items-center gap-2 text-[13px] underline-offset-4 hover:underline">
          
            <ArrowLeftIcon className="h-4 w-4" /> Back to sign in
          </button> :

        <>
            <div className="my-6 flex items-center gap-4 text-[12px] text-stone">
              <span className="h-px flex-1 bg-hairline" /> or <span className="h-px flex-1 bg-hairline" />
            </div>
            <div className="grid gap-3">
              <button onClick={socialLogin} className="flex h-12 items-center justify-center gap-3 border border-hairline text-[14px] transition-colors hover:border-ink">
                <GoogleGlyph /> Continue with Google
              </button>
              <button onClick={socialLogin} className="flex h-12 items-center justify-center gap-3 border border-hairline text-[14px] transition-colors hover:border-ink">
                <AppleGlyph /> Continue with Apple
              </button>
            </div>
            <p className="mt-6 text-center text-[12px] text-stone">
              By continuing you agree to our <Link to="/faq" className="underline">Terms</Link> and <Link to="/faq" className="underline">Privacy Policy</Link>.
            </p>
          </>
        }
      </div>
    </div>);

}