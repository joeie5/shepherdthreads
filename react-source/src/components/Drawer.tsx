import React, { useEffect } from 'react';
import { AnimatePresence, motion, useReducedMotion } from 'framer-motion';

interface DrawerProps {
  open: boolean;
  onClose: () => void;
  side?: 'left' | 'right' | 'bottom';
  label: string;
  tone?: 'light' | 'dark';
  children: React.ReactNode;
}

export function Drawer({ open, onClose, side = 'right', label, tone = 'light', children }: DrawerProps) {
  const reduce = useReducedMotion();

  useEffect(() => {
    if (!open) return;
    const prev = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    const onKey = (e: KeyboardEvent) => e.key === 'Escape' && onClose();
    window.addEventListener('keydown', onKey);
    return () => {
      document.body.style.overflow = prev;
      window.removeEventListener('keydown', onKey);
    };
  }, [open, onClose]);

  const offscreen = side === 'right' ? { x: '100%' } : side === 'left' ? { x: '-100%' } : { y: '100%' };
  const onscreen = side === 'bottom' ? { y: 0 } : { x: 0 };
  const position =
  side === 'right' ?
  'right-0 top-0 bottom-0 w-full max-w-[440px]' :
  side === 'left' ?
  'left-0 top-0 bottom-0 w-[88%] max-w-[400px]' :
  'bottom-0 left-0 right-0 max-h-[88vh]';

  return (
    <AnimatePresence>
      {open &&
      <div className="fixed inset-0 z-[60]" role="dialog" aria-modal="true" aria-label={label}>
          <motion.div
          className="absolute inset-0 bg-ink/50"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: reduce ? 0 : 0.2, ease: 'easeOut' }}
          onClick={onClose} />
        
          <motion.aside
          className={`absolute flex flex-col ${position} ${tone === 'dark' ? 'bg-ink text-white' : 'bg-white text-ink'}`}
          initial={offscreen}
          animate={onscreen}
          exit={offscreen}
          transition={{ duration: reduce ? 0 : 0.28, ease: [0.23, 1, 0.32, 1] }}>
          
            {children}
          </motion.aside>
        </div>
      }
    </AnimatePresence>);

}