// PrismCalc Website - Marketing Copy

export const copy = {
  tagline: 'The beautiful way to calculate',

  heroSubtitle:
    'A spectacularly designed calculator featuring iOS 18 glassmorphism, animated mesh gradients, and practical tools for everyday calculations.',

  shortDescription:
    'Beautiful glassmorphic calculator with tip splitting, discounts, unit conversion, and stunning iOS 18 visual effects. Pro tools for everyday math.',

  privacy: {
    headline: 'Your data stays yours',
    body: 'PrismCalc does not collect, store, or transmit any personal information. All calculations happen on your device. No analytics, no tracking, no servers.',
  },

  proValue: {
    headline: 'Unlock the full experience',
    body: 'One-time purchase of $2.99. No subscriptions, no recurring charges. Pay once, own forever.',
    price: '$2.99',
  },

  appStore: {
    url: 'https://apps.apple.com/app/prismcalc/id6740092498',
    badge: 'Download on the App Store',
  },

  about: {
    headline: 'Built with care',
    body: 'PrismCalc was crafted by LaClair Technologies with a focus on beautiful design and practical utility. Every detail, from the animated mesh gradients to the haptic feedback, was designed to make calculations a delightful experience.',
    developer: 'LaClair Technologies',
  },

  meta: {
    title: 'PrismCalc - The beautiful way to calculate',
    description:
      'Beautiful glassmorphic calculator for iPhone, iPad, and Mac. Tip splitting, discounts, unit conversion, and 6 stunning themes.',
    keywords:
      'calculator, tip calculator, glassmorphism, iOS app, iPhone calculator, split bill, unit converter, discount calculator',
    url: 'https://prismcalc.app',
  },

  footer: {
    copyright: `© ${new Date().getFullYear()} LaClair Technologies. All rights reserved.`,
    links: [
      { label: 'Privacy Policy', href: '/privacy' },
      { label: 'Support', href: 'mailto:support@laclairtech.com' },
    ],
  },
} as const;
