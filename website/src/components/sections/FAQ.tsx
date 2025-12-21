import { FAQAccordion } from '../ui/FAQAccordion';
import { GlassCard } from '../ui/GlassCard';
import { faqItems } from '../../data/faq';

export function FAQ() {
  return (
    <section id="faq" className="faq">
      <div className="container">
        <div className="section-header">
          <span className="section-header__label">FAQ</span>
          <h2 className="section-header__title">Common questions</h2>
          <p className="section-header__subtitle">
            Everything you need to know about PrismCalc.
          </p>
        </div>

        <GlassCard className="faq__card" hover={false}>
          <FAQAccordion items={faqItems} />
        </GlassCard>
      </div>
    </section>
  );
}
