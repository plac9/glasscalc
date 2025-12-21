// PrismCalc Website - FAQ Data

import type { FAQItem } from '../types';

export const faqItems: FAQItem[] = [
  {
    id: 'free',
    question: 'Is PrismCalc free to download?',
    answer:
      'Yes! PrismCalc is free to download with a full-featured basic calculator, calculation history (last 10), the Aurora theme, and a basic widget. Pro features are available via a one-time purchase of $2.99.',
  },
  {
    id: 'platforms',
    question: 'What platforms is PrismCalc available on?',
    answer:
      'PrismCalc is available for iPhone (iOS 18+), iPad (iPadOS 18+), and Mac (macOS 15+ with Apple Silicon). The app is optimized for each platform with adaptive layouts.',
  },
  {
    id: 'privacy',
    question: 'Does PrismCalc collect my data?',
    answer:
      'No. PrismCalc does not collect any personal data. All calculations stay on your device. We have no servers, no analytics, and no tracking. Your privacy is completely protected.',
  },
  {
    id: 'pro-features',
    question: 'What Pro features are included?',
    answer:
      'Pro unlocks the Tip Calculator with arc slider, Discount Calculator, Split Bill, Unit Converter, unlimited calculation history with iCloud sync, 5 premium themes (in addition to Aurora), and all widget styles.',
  },
  {
    id: 'subscription',
    question: 'Is Pro a subscription?',
    answer:
      'No. PrismCalc Pro is a one-time purchase of $2.99. Pay once, own forever. No subscriptions, no recurring charges, no hidden fees.',
  },
  {
    id: 'sync',
    question: 'Does history sync across devices?',
    answer:
      'Yes! Pro users get iCloud sync for calculation history across all their Apple devices. Your calculations follow you from iPhone to iPad to Mac seamlessly.',
  },
];
