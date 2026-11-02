import React, { useState } from 'react';
import { PlusIcon } from 'lucide-react';
import { addresses as initial } from '../../data/account';

export function AddressesPanel() {
  const [list, setList] = useState(initial);

  return (
    <section>
      <h2 className="font-serif text-[24px]">Addresses</h2>
      <ul className="mt-6 grid gap-4 sm:grid-cols-2">
        {list.map((a) =>
        <li key={a.id} className="flex flex-col border border-hairline p-6">
            <div className="flex items-center justify-between">
              <p className="text-[14px] font-medium">{a.label}</p>
              {a.isDefault && <span className="text-[11px] uppercase tracking-[0.12em] text-brass">Default</span>}
            </div>
            <address className="mt-3 flex-1 text-[14px] not-italic leading-relaxed text-ink/75">
              {a.name}
              <br />
              {a.line1}
              {a.line2 ? `, ${a.line2}` : ''}
              <br />
              {a.city}, {a.state} {a.zip}
              <br />
              {a.phone}
            </address>
            <div className="mt-5 flex gap-4 text-[13px]">
              <button className="underline underline-offset-4">Edit</button>
              {!a.isDefault &&
            <>
                  <button
                className="underline underline-offset-4"
                onClick={() => setList((l) => l.map((x) => ({ ...x, isDefault: x.id === a.id })))}>
                
                    Set as default
                  </button>
                  <button className="text-stone underline underline-offset-4 hover:text-ink" onClick={() => setList((l) => l.filter((x) => x.id !== a.id))}>
                    Remove
                  </button>
                </>
            }
            </div>
          </li>
        )}
        <li>
          <button className="flex h-full min-h-[200px] w-full flex-col items-center justify-center gap-2 border border-dashed border-stone/50 text-[14px] transition-colors hover:border-ink">
            <PlusIcon className="h-5 w-5" /> Add new address
          </button>
        </li>
      </ul>
    </section>);

}