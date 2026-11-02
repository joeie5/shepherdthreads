import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { CheckIcon, ChevronDownIcon, ClockIcon, MailIcon, MapPinIcon, PhoneIcon } from 'lucide-react';
import { FormField, TextAreaField } from '../components/FormField';
import { Button } from '../components/Button';
import { InstagramGlyph, TiktokGlyph, YoutubeGlyph } from '../components/BrandIcons';

const topics = ['Order status', 'Returns & exchanges', 'Sizing help', 'Church or bulk orders', 'Partnerships', 'Something else'];
const shortcuts = [
{ label: 'Where’s my order?', to: '/faq#shipping' },
{ label: 'Start a return', to: '/faq#returns' },
{ label: 'Find my size', to: '/faq#sizing' },
{ label: 'Our giving', to: '/faq#faith' }];


export function Contact() {
  const [form, setForm] = useState({ name: '', email: '', order: '', topic: '', message: '' });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [status, setStatus] = useState<'idle' | 'sending' | 'sent'>('idle');

  const update = (k: keyof typeof form, v: string) => {
    setForm((f) => ({ ...f, [k]: v }));
    setErrors((e) => ({ ...e, [k]: '' }));
  };

  const submit = (e: React.FormEvent) => {
    e.preventDefault();
    const next: Record<string, string> = {};
    if (!form.name.trim()) next.name = 'Please enter your name';
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) next.email = 'Enter a valid email address';
    if (!form.topic) next.topic = 'Choose a topic';
    if (form.message.trim().length < 10) next.message = 'Tell us a little more (at least 10 characters)';
    setErrors(next);
    if (Object.keys(next).length) return;
    setStatus('sending');
    window.setTimeout(() => setStatus('sent'), 800);
  };

  return (
    <div className="bg-white">
      <header className="bg-cream">
        <div className="mx-auto max-w-site px-5 py-12 md:px-8 md:py-16">
          <h1 className="font-serif text-[40px] uppercase tracking-[0.06em] md:text-[56px]">Contact</h1>
          <p className="mt-3 max-w-lg text-[15px] text-ink/65">A real person reads every message. We usually reply within one business day.</p>
          <ul className="mt-8 flex flex-wrap gap-2">
            {shortcuts.map((s) =>
            <li key={s.to}>
                <Link to={s.to} className="flex h-10 items-center border border-ink/20 bg-white px-4 text-[13px] transition-colors hover:border-ink">
                  {s.label}
                </Link>
              </li>
            )}
          </ul>
        </div>
      </header>

      <div className="mx-auto grid max-w-site gap-14 px-5 py-14 md:px-8 md:py-20 lg:grid-cols-[1.5fr_1fr] lg:gap-24">
        <section aria-label="Contact form">
          {status === 'sent' ?
          <div className="bg-cream p-8 md:p-12" role="status">
              <span className="flex h-12 w-12 items-center justify-center rounded-full bg-ink text-white">
                <CheckIcon className="h-5 w-5" />
              </span>
              <h2 className="mt-6 font-serif text-[30px]">Message received</h2>
              <p className="mt-3 text-[15px] text-ink/70">Thanks, {form.name.split(' ')[0]}. We’ll reply to {form.email} within one business day.</p>
              <Button variant="outline" className="mt-8" onClick={() => {setForm({ name: '', email: '', order: '', topic: '', message: '' });setStatus('idle');}}>
                Send another message
              </Button>
            </div> :

          <form onSubmit={submit} noValidate className="grid gap-5 sm:grid-cols-2">
              <FormField id="c-name" label="Name" autoComplete="name" value={form.name} onChange={(e) => update('name', e.target.value)} error={errors.name} />
              <FormField id="c-email" label="Email" type="email" autoComplete="email" value={form.email} onChange={(e) => update('email', e.target.value)} error={errors.email} />
              <FormField id="c-order" label="Order number (optional)" placeholder="ST-10000" value={form.order} onChange={(e) => update('order', e.target.value)} />
              <div>
                <label htmlFor="c-topic" className="mb-1.5 block text-[13px]">Topic</label>
                <div className="relative">
                  <select
                  id="c-topic"
                  value={form.topic}
                  onChange={(e) => update('topic', e.target.value)}
                  aria-invalid={Boolean(errors.topic)}
                  className={`h-12 w-full appearance-none border bg-white px-3.5 pr-10 text-[15px] outline-none focus:border-ink ${errors.topic ? 'border-brass' : 'border-hairline'}`}>
                  
                    <option value="">Choose a topic</option>
                    {topics.map((t) => <option key={t}>{t}</option>)}
                  </select>
                  <ChevronDownIcon className="pointer-events-none absolute right-3.5 top-4 h-4 w-4" />
                </div>
                {errors.topic && <p className="mt-1.5 text-[12px] text-brass">{errors.topic}</p>}
              </div>
              <TextAreaField id="c-message" className="sm:col-span-2" label="Message" value={form.message} onChange={(e) => update('message', e.target.value)} error={errors.message} />
              <div className="sm:col-span-2">
                <Button type="submit" size="lg" disabled={status === 'sending'}>
                  {status === 'sending' ? 'Sending…' : 'Send message'}
                </Button>
              </div>
            </form>
          }
        </section>

        <aside className="space-y-10 text-[14px]">
          <section>
            <h2 className="text-[12px] font-medium uppercase tracking-[0.14em]">Reach us</h2>
            <ul className="mt-4 space-y-3 text-ink/75">
              <li className="flex items-center gap-3"><MailIcon className="h-4 w-4" strokeWidth={1.5} /> hello@shepherdsthread.co</li>
              <li className="flex items-center gap-3"><PhoneIcon className="h-4 w-4" strokeWidth={1.5} /> (404) 555-0140</li>
              <li className="flex items-center gap-3"><ClockIcon className="h-4 w-4" strokeWidth={1.5} /> Mon–Fri, 9am–5pm ET</li>
            </ul>
          </section>
          <section>
            <h2 className="text-[12px] font-medium uppercase tracking-[0.14em]">Studio & pickup</h2>
            <p className="mt-4 flex gap-3 leading-relaxed text-ink/75">
              <MapPinIcon className="mt-0.5 h-4 w-4 shrink-0" strokeWidth={1.5} />
              <span>
                Shepherds Thread Studio
                <br />
                675 Ponce de Leon Ave NE, Suite 210
                <br />
                Atlanta, GA 30308
                <br />
                <span className="text-stone">Open Saturdays 10am–4pm</span>
              </span>
            </p>
          </section>
          <section>
            <h2 className="text-[12px] font-medium uppercase tracking-[0.14em]">Follow along</h2>
            <ul className="mt-4 flex gap-2">
              {[
              { label: 'Instagram', Icon: InstagramGlyph },
              { label: 'TikTok', Icon: TiktokGlyph },
              { label: 'YouTube', Icon: YoutubeGlyph }].
              map(({ label, Icon }) =>
              <li key={label}>
                  <a href="#" aria-label={label} className="flex h-10 w-10 items-center justify-center border border-hairline transition-colors hover:border-ink">
                    <Icon className="h-[18px] w-[18px]" />
                  </a>
                </li>
              )}
            </ul>
          </section>
          <p className="border-t border-hairline pt-8 font-serif text-[18px] italic leading-snug text-ink/80">
            “Carry each other’s burdens.” <span className="font-sans text-[12px] not-italic text-stone">— Galatians 6:2</span>
          </p>
        </aside>
      </div>
    </div>);

}