// PrismCalc Website - Marketing Copy

export const copy = {
  tagline: 'Beautiful calculations, real-world clarity',

  heroSubtitle:
    'A fast everyday calculator with tip, discount, split, and unit conversions—wrapped in glassmorphism (Liquid Glass on iOS 26+) and built for privacy.',

  shortDescription:
    'Glassmorphic calculator for iPhone, iPad, and Mac with a companion Apple Watch app for quick calculations.',

  privacy: {
    headline: 'Your data stays yours',
    body: 'PrismCalc does not collect, store, or transmit personal data. All calculations stay on your device—no analytics, no tracking, no servers.',
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
    headline: 'Built by an indie team that sweats the details',
    body: 'PrismCalc is built by LaClair Technologies with a focus on clarity, speed, and privacy. Every interaction—glass layers, haptics, and typography—is designed to make everyday math feel effortless.',
    developer: 'LaClair Technologies',
    support: 'support@laclairtech.com',
  },

  meta: {
    title: 'PrismCalc - Beautiful calculations, real-world clarity',
    description:
      'Glassmorphic calculator for iPhone, iPad, Mac, and Apple Watch. Tip, discount, split, unit conversion, private history, and one-time Pro unlock.',
    keywords:
      'calculator, tip calculator, split bill, discount calculator, unit converter, glassmorphism, iOS app, watchOS app, Apple Watch, privacy, one-time purchase',
    url: 'https://prismcalc.app',
  },

  footer: {
    copyright: `© ${new Date().getFullYear()} LaClair Technologies. All rights reserved.`,
    links: [
      { label: 'About', href: '#about' },
      { label: 'Accessibility', href: '#accessibility' },
      { label: 'Roadmap', href: '#roadmap' },
      { label: 'Privacy', href: '#privacy' },
      { label: 'Support', href: 'mailto:support@laclairtech.com' },
    ],
  },
} as const;
