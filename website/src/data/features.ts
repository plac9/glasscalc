// PrismCalc Website - Feature Data

import type { Feature } from '../types';

export const features: Feature[] = [
  {
    id: 'calculator',
    title: 'Basic Calculator',
    description:
      'Fast, precise arithmetic with a responsive glass UI and haptic feedback. Built for everyday calculations you trust.',
    icon: '🧮',
    isPro: false,
  },
  {
    id: 'tip',
    title: 'Tip Calculator',
    description:
      'Dial in any percentage with the arc slider and quick presets. Split totals across any group in seconds.',
    icon: '💵',
    isPro: true,
    highlight: 'Arc Slider',
  },
  {
    id: 'discount',
    title: 'Discount Calculator',
    description:
      'See savings and final price instantly—ideal for shopping, price matching, and deal hunting.',
    icon: '🏷️',
    isPro: true,
  },
  {
    id: 'split',
    title: 'Split Bill',
    description:
      'Split bills fairly with optional tip and per-person totals. Great for dinners, trips, and shared expenses.',
    icon: '👥',
    isPro: true,
  },
  {
    id: 'converter',
    title: 'Unit Converter',
    description:
      'Convert length, weight, and temperature with a clean, fast workflow and history-aware results.',
    icon: '🔄',
    isPro: true,
  },
  {
    id: 'history',
    title: 'History + Widgets',
    description:
      'Keep your last calculations handy with widgets, Control Center, and Siri Shortcuts. Pro unlocks unlimited history and more widget styles.',
    icon: '🕘',
    isPro: true,
  },
];
