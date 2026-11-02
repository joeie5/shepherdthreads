import React, { useId, useState } from 'react';
import { AnimatePresence, motion, useReducedMotion } from 'framer-motion';
import { PlusIcon } from 'lucide-react';

interface AccordionItemProps {
  title: string;
  children: React.ReactNode;
  defaultOpen?: boolean;
  tone?: 'light' | 'dark';
}

export function AccordionItem({ title, children, defaultOpen = false, tone = 'light' }: AccordionItemProps) {
  const [open, setOpen] = useState(defaultOpen);
  const id = useId();
  const reduce = useReducedMotion();
  const border = tone === 'dark' ? 'border-white/15' : 'border-hairline';

  return (
    <div className={`border-b ${border}`}>
      <h3>
        <button
          type="button"
          aria-expanded={open}
          aria-controls={id}
          onClick={() => setOpen((o) => !o)}
          className="flex w-full items-center justify-between gap-6 py-5 text-left text-[15px] font-medium">
          
          <span>{title}</span>
          <PlusIcon
            className={`h-4 w-4 shrink-0 transition-transform duration-200 ease-out ${open ? 'rotate-45' : ''}`}
            aria-hidden="true" />
          
        </button>
      </h3>
      <AnimatePresence initial={false}>
        {open &&
        <motion.div
          id={id}
          initial={{ height: 0, opacity: 0 }}
          animate={{ height: 'auto', opacity: 1 }}
          exit={{ height: 0, opacity: 0 }}
          transition={{ duration: reduce ? 0 : 0.22, ease: [0.23, 1, 0.32, 1] }}
          className="overflow-hidden">
          
            <div className={`pb-6 text-[14px] leading-relaxed ${tone === 'dark' ? 'text-white/70' : 'text-ink/70'}`}>{children}</div>
          </motion.div>
        }
      </AnimatePresence>
    </div>);

}