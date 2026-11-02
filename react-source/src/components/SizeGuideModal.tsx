import React, { useState } from 'react';
import { Modal } from './Modal';
import { sizeGuide } from '../data/account';

interface SizeGuideModalProps {
  open: boolean;
  onClose: () => void;
}

export function SizeGuideModal({ open, onClose }: SizeGuideModalProps) {
  const [unit, setUnit] = useState<'in' | 'cm'>('in');
  const convert = (v: string) => unit === 'in' ? v : (parseFloat(v) * 2.54).toFixed(0);

  return (
    <Modal open={open} onClose={onClose} title="Size Guide">
      <p className="text-[14px] text-ink/70">
        Our tops are cut boxy and oversized. For a closer fit, size down one. Measurements are of the garment laid flat.
      </p>
      <div className="mt-5 inline-flex border border-hairline" role="radiogroup" aria-label="Units">
        {(['in', 'cm'] as const).map((u) =>
        <button
          key={u}
          role="radio"
          aria-checked={unit === u}
          onClick={() => setUnit(u)}
          className={`h-8 px-4 text-[12px] uppercase tracking-[0.1em] transition-colors ${unit === u ? 'bg-ink text-white' : 'text-ink/70 hover:text-ink'}`}>
          
            {u}
          </button>
        )}
      </div>
      <div className="mt-5 overflow-x-auto">
        <table className="w-full text-left text-[14px]">
          <thead>
            <tr className="border-b border-ink">
              {sizeGuide.headers.map((h) =>
              <th key={h} scope="col" className="py-3 pr-4 text-[12px] font-medium uppercase tracking-[0.08em]">
                  {h.replace('(in)', `(${unit})`)}
                </th>
              )}
            </tr>
          </thead>
          <tbody>
            {sizeGuide.rows.map((row) =>
            <tr key={row[0]} className="border-b border-hairline">
                {row.map((cell, i) =>
              <td key={i} className={`py-3 pr-4 tabular-nums ${i === 0 ? 'font-medium' : 'text-ink/70'}`}>
                    {i === 0 ? cell : convert(cell)}
                  </td>
              )}
              </tr>
            )}
          </tbody>
        </table>
      </div>
      <p className="mt-5 text-[13px] text-stone">Between sizes? Our team will help — email fit@shepherdsthread.co.</p>
    </Modal>);

}