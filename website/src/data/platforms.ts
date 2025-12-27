// PrismCalc Website - Platform Data

import type { Platform } from '../types';

export const platforms: Platform[] = [
  {
    id: 'iphone',
    title: 'iPhone',
    subtitle: 'Full PrismCalc experience in your pocket.',
    badge: 'iOS 18+',
    icon: 'iPhone',
    image: '/platforms/iphone.png',
    imageAlt: 'PrismCalc on iPhone',
    details: [
      'Calculator, tip, split, discount, and conversions.',
      'Control Center quick actions on iOS 18.',
      'Home Screen widgets and Siri shortcuts.',
    ],
  },
  {
    id: 'ipad',
    title: 'iPad',
    subtitle: 'Bigger layout, more room to breathe.',
    badge: 'iPadOS 18+',
    icon: 'iPad',
    image: '/platforms/ipad.png',
    imageAlt: 'PrismCalc on iPad',
    details: [
      'Optimized layouts with floating tab bar + sidebar.',
      'Ideal for multitasking and keyboard input.',
      'Widgets sized for large displays.',
    ],
  },
  {
    id: 'mac',
    title: 'Mac',
    subtitle: 'Native macOS app with resizable glass UI.',
    badge: 'macOS 15+',
    icon: 'Mac',
    image: '/platforms/mac.png',
    imageAlt: 'PrismCalc on Mac',
    details: [
      'Desktop-friendly controls and spacing.',
      'Full history, themes, and Pro tools.',
      'Optional iCloud sync across devices.',
    ],
  },
  {
    id: 'watch',
    title: 'Apple Watch',
    subtitle: 'Quick calculations on your wrist.',
    badge: 'watchOS 10+',
    icon: 'Watch',
    image: '/platforms/watch.png',
    imageAlt: 'PrismCalc on Apple Watch',
    details: [
      'Tap-friendly keypad tuned for small screens.',
      'Tip and discount tools on the go.',
      'Companion app for fast results.',
    ],
  },
];
