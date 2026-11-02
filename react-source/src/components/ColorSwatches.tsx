import React from 'react';
import type { ColorVariant } from '../types/product';
import { isLightColor } from '../utils/products';

interface ColorSwatchesProps {
  colors: ColorVariant[];
  selected: string;
  onSelect: (name: string) => void;
  size?: 'sm' | 'lg';
}

export function ColorSwatches({ colors, selected, onSelect, size = 'sm' }: ColorSwatchesProps) {
  const dim = size === 'sm' ? 'h-4 w-4' : 'h-8 w-8';
  return (
    <div className="flex items-center gap-2" role="radiogroup" aria-label="Color">
      {colors.map((c) => {
        const active = c.name === selected;
        return (
          <button
            key={c.name}
            type="button"
            role="radio"
            aria-checked={active}
            aria-label={c.name}
            title={c.name}
            onClick={() => onSelect(c.name)}
            className={`rounded-full p-[3px] ring-1 transition-shadow duration-150 ${active ? 'ring-ink' : 'ring-transparent hover:ring-stone/60'}`}>
            
            <span
              className={`block rounded-full ${dim} ${isLightColor(c.hex) ? 'ring-1 ring-inset ring-ink/15' : ''}`}
              style={{ backgroundColor: c.hex }} />
            
          </button>);

      })}
    </div>);

}