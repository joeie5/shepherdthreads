import React from 'react';

interface FormFieldProps extends React.InputHTMLAttributes<HTMLInputElement> {
  id: string;
  label: string;
  error?: string;
  hint?: string;
  tone?: 'light' | 'dark';
}

export function FormField({ id, label, error, hint, className = '', tone = 'light', ...rest }: FormFieldProps) {
  return (
    <div className={className}>
      <label htmlFor={id} className="mb-1.5 block text-[13px]">
        {label}
      </label>
      <input
        id={id}
        aria-invalid={Boolean(error)}
        aria-describedby={error ? `${id}-error` : hint ? `${id}-hint` : undefined}
        className={`h-12 w-full border bg-white px-3.5 text-[15px] text-ink outline-none transition-colors placeholder:text-stone/80 focus:border-ink ${
        error ? 'border-brass' : 'border-hairline hover:border-stone'}`
        }
        {...rest} />
      
      {error ?
      <p id={`${id}-error`} className="mt-1.5 text-[12px] text-brass">
          {error}
        </p> :
      hint ?
      <p id={`${id}-hint`} className={`mt-1.5 text-[12px] ${tone === 'dark' ? 'text-white/50' : 'text-stone'}`}>
          {hint}
        </p> :
      null}
    </div>);

}

interface TextAreaFieldProps extends React.TextareaHTMLAttributes<HTMLTextAreaElement> {
  id: string;
  label: string;
  error?: string;
}

export function TextAreaField({ id, label, error, className = '', ...rest }: TextAreaFieldProps) {
  return (
    <div className={className}>
      <label htmlFor={id} className="mb-1.5 block text-[13px]">
        {label}
      </label>
      <textarea
        id={id}
        aria-invalid={Boolean(error)}
        className={`min-h-[150px] w-full border bg-white px-3.5 py-3 text-[15px] outline-none transition-colors placeholder:text-stone/80 focus:border-ink ${
        error ? 'border-brass' : 'border-hairline hover:border-stone'}`
        }
        {...rest} />
      
      {error && <p className="mt-1.5 text-[12px] text-brass">{error}</p>}
    </div>);

}