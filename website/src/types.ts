// PrismCalc Website - Type Definitions

export interface Feature {
  id: string;
  title: string;
  description: string;
  icon: string;
  isPro: boolean;
  highlight?: string;
}

export interface FAQItem {
  id: string;
  question: string;
  answer: string;
}

export interface Theme {
  id: string;
  name: string;
  isPro: boolean;
  colors: {
    primary: string;
    secondary: string;
    gradient: [string, string, string];
  };
}

export interface Screenshot {
  id: string;
  src: string;
  alt: string;
  caption?: string;
  theme?: string;
}

export interface NavItem {
  id: string;
  label: string;
  href: string;
}

export interface Platform {
  id: string;
  title: string;
  subtitle: string;
  badge: string;
  details: string[];
  icon: string;
  image: string;
  imageAlt: string;
}

export interface WidgetFeature {
  id: string;
  title: string;
  description: string;
  detail: string;
  icon: string;
}
