import React, { useState } from 'react';
import { CheckIcon } from 'lucide-react';
import { FormField } from '../FormField';
import { Button } from '../Button';
import { user } from '../../data/account';

export function ProfilePanel() {
  const [editing, setEditing] = useState(false);
  const [saved, setSaved] = useState(false);
  const [form, setForm] = useState({ firstName: user.firstName, lastName: user.lastName, email: user.email, phone: user.phone });
  const [prefs, setPrefs] = useState({ newsletter: true, devotional: true, sms: false });

  const fields: {key: keyof typeof form;label: string;}[] = [
  { key: 'firstName', label: 'First name' },
  { key: 'lastName', label: 'Last name' },
  { key: 'email', label: 'Email' },
  { key: 'phone', label: 'Phone' }];


  return (
    <div className="space-y-12">
      <section>
        <div className="flex items-center justify-between">
          <h2 className="font-serif text-[24px]">Personal details</h2>
          {!editing &&
          <button onClick={() => {setEditing(true);setSaved(false);}} className="text-[13px] underline underline-offset-4">
              Edit
            </button>
          }
        </div>
        {saved &&
        <p className="mt-4 flex items-center gap-2 bg-cream px-4 py-3 text-[13px]" role="status">
            <CheckIcon className="h-4 w-4" /> Your details have been updated.
          </p>
        }
        {editing ?
        <form
          className="mt-6 grid gap-4 sm:grid-cols-2"
          onSubmit={(e) => {
            e.preventDefault();
            setEditing(false);
            setSaved(true);
          }}>
          
            {fields.map((f) =>
          <FormField key={f.key} id={`profile-${f.key}`} label={f.label} value={form[f.key]} onChange={(e) => setForm((s) => ({ ...s, [f.key]: e.target.value }))} />
          )}
            <div className="flex gap-3 sm:col-span-2">
              <Button type="submit">Save changes</Button>
              <Button type="button" variant="outline" onClick={() => setEditing(false)}>
                Cancel
              </Button>
            </div>
          </form> :

        <dl className="mt-6 grid gap-x-8 gap-y-6 border-t border-hairline pt-6 sm:grid-cols-2">
            {fields.map((f) =>
          <div key={f.key}>
                <dt className="text-[12px] uppercase tracking-[0.12em] text-stone">{f.label}</dt>
                <dd className="mt-1 text-[15px]">{form[f.key]}</dd>
              </div>
          )}
            <div>
              <dt className="text-[12px] uppercase tracking-[0.12em] text-stone">Password</dt>
              <dd className="mt-1 text-[15px]">••••••••••</dd>
            </div>
          </dl>
        }
      </section>

      <section>
        <h2 className="font-serif text-[24px]">Communication</h2>
        <ul className="mt-6 divide-y divide-hairline border-y border-hairline">
          {[
          { key: 'newsletter' as const, label: 'New releases & restocks', sub: 'Early access before anyone else' },
          { key: 'devotional' as const, label: 'Monthly devotional', sub: 'A short reflection from our team' },
          { key: 'sms' as const, label: 'Text message updates', sub: 'Shipping updates and launch reminders' }].
          map((p) =>
          <li key={p.key} className="flex items-center justify-between gap-6 py-4">
              <div>
                <p className="text-[14px] font-medium">{p.label}</p>
                <p className="text-[13px] text-stone">{p.sub}</p>
              </div>
              <button
              role="switch"
              aria-checked={prefs[p.key]}
              aria-label={p.label}
              onClick={() => setPrefs((s) => ({ ...s, [p.key]: !s[p.key] }))}
              className={`relative h-6 w-11 shrink-0 rounded-full transition-colors duration-200 ${prefs[p.key] ? 'bg-ink' : 'bg-hairline'}`}>
              
                <span className={`absolute left-0.5 top-0.5 h-5 w-5 rounded-full bg-white transition-transform duration-200 ease-out ${prefs[p.key] ? 'translate-x-5' : ''}`} />
              </button>
            </li>
          )}
        </ul>
      </section>
    </div>);

}