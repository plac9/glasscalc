// PrismCalc Website - Widgets and Shortcuts Data

import type { WidgetFeature } from '../types';

export const widgetFeatures: WidgetFeature[] = [
  {
    id: 'home-screen',
    title: 'Home Screen Widgets',
    description: 'Quick calculations and history at a glance.',
    detail: 'Small, medium, and large layouts.',
    icon: 'Widgets',
  },
  {
    id: 'control-center',
    title: 'Control Center',
    description: 'Launch calculations without opening the app.',
    detail: 'iOS 18 quick actions.',
    icon: 'Control',
  },
  {
    id: 'shortcuts',
    title: 'Siri + Shortcuts',
    description: 'Hands-free tips, splits, and conversions.',
    detail: 'Works across iPhone, iPad, and Mac.',
    icon: 'Siri',
  },
];
