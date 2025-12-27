import { useState } from 'react';
import { GlassCard } from '../ui/GlassCard';

const demoItems = [
  {
    id: 'calculator',
    label: 'Calculator',
    title: 'Everyday arithmetic, instantly',
    description: 'Fast, precise calculations with a glass interface that stays out of your way.',
    image: '/showcase/iphone_hero.png',
  },
  {
    id: 'tip',
    label: 'Tip',
    title: 'Arc slider tips',
    description: 'Dial in any percentage and split the total in seconds.',
    image: '/showcase/iphone_tip.png',
  },
  {
    id: 'split',
    label: 'Split',
    title: 'Split bills the smart way',
    description: 'Include tip, adjust headcount, and see per-person totals at a glance.',
    image: '/showcase/iphone_split.png',
  },
  {
    id: 'discount',
    label: 'Discount',
    title: 'Know the real price',
    description: 'See savings and final totals while you shop or compare deals.',
    image: '/showcase/iphone_discount.png',
  },
  {
    id: 'converter',
    label: 'Convert',
    title: 'Units in one tap',
    description: 'Length, weight, and temperature conversions with instant results.',
    image: '/showcase/iphone_converter.png',
  },
];

export function Demo() {
  const [activeId, setActiveId] = useState(demoItems[0]?.id ?? 'calculator');
  const active = demoItems.find((item) => item.id === activeId) ?? demoItems[0];

  return (
    <section id="demo" className="demo">
      <div className="container">
        <div className="section-header">
          <span className="section-header__label">Demo</span>
          <h2 className="section-header__title">See how it feels</h2>
          <p className="section-header__subtitle">
            Tap through the core flows to understand how PrismCalc saves time.
          </p>
        </div>

        <div className="demo__layout">
          <GlassCard className="demo__controls" hover={false}>
            <div className="demo__tabs" aria-label="Demo sections">
              {demoItems.map((item) => (
                <button
                  key={item.id}
                  className={`demo__tab ${item.id === activeId ? 'demo__tab--active' : ''}`}
                  aria-pressed={item.id === activeId}
                  onClick={() => setActiveId(item.id)}
                  type="button"
                >
                  {item.label}
                </button>
              ))}
            </div>
            <div className="demo__details">
              <h3>{active.title}</h3>
              <p>{active.description}</p>
            </div>
          </GlassCard>

          <div className="demo__preview">
            <img
              src={active.image}
              alt={`${active.label} screenshot`}
              loading="lazy"
              decoding="async"
            />
          </div>
        </div>
      </div>
    </section>
  );
}
