// PrismCalc Website - Feature Data

import type { Feature } from '../types';

export const features: Feature[] = [
  {
    id: 'calculator',
    title: 'Basic Calculator',
    description:
      'Beautiful glassmorphic calculator with full arithmetic operations. Precise calculations with an elegant, responsive interface and haptic feedback.',
    icon: '🧮',
    isPro: false,
  },
  {
    id: 'tip',
    title: 'Tip Calculator',
    description:
      'Calculate tips effortlessly with our unique arc slider. Quick presets for 15%, 18%, 20%, 25%. Split bills between any number of people instantly.',
    icon: '💵',
    isPro: true,
    highlight: 'Arc Slider',
  },
  {
    id: 'discount',
    title: 'Discount Calculator',
    description:
      'Find the final price after any discount. See both your savings and the final amount. Perfect for shopping and comparing deals.',
    icon: '🏷️',
    isPro: true,
  },
  {
    id: 'split',
    title: 'Split Bill',
    description:
      'Divide expenses fairly among friends. Include or exclude tip in the split. Perfect for group dinners and shared expenses.',
    icon: '👥',
    isPro: true,
  },
  {
    id: 'converter',
    title: 'Unit Converter',
    description:
      'Convert length, weight, and temperature instantly. Miles to kilometers, pounds to kilograms, Fahrenheit to Celsius, and more.',
    icon: '🔄',
    isPro: true,
  },
  {
    id: 'themes',
    title: '6 Premium Themes',
    description:
      'Aurora, Calming Blues, Forest Earth, Soft Tranquil, Blue-Green Harmony, and Midnight. Each with unique animated mesh gradients.',
    icon: '🎨',
    isPro: true,
  },
];
