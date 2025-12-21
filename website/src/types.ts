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
