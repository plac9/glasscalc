import { useState } from 'react';
import type { FAQItem } from '../../types';

interface FAQAccordionProps {
  items: FAQItem[];
}

export function FAQAccordion({ items }: FAQAccordionProps) {
  const [openId, setOpenId] = useState<string | null>(null);

  const toggle = (id: string) => {
    setOpenId(openId === id ? null : id);
  };

  return (
    <div className="faq-accordion">
      {items.map((item) => (
        <div key={item.id} className="faq-item">
          <button
            className="faq-question"
            onClick={() => toggle(item.id)}
            aria-expanded={openId === item.id}
            aria-controls={`faq-answer-${item.id}`}
          >
            <span>{item.question}</span>
            <span className="faq-question__icon" aria-hidden="true">
              +
            </span>
          </button>
          {openId === item.id && (
            <div
              id={`faq-answer-${item.id}`}
              className="faq-answer"
              role="region"
            >
              {item.answer}
            </div>
          )}
        </div>
      ))}
    </div>
  );
}
