// PrismCalc Website - Theme Data

import type { Theme } from '../types';

export const themes: Theme[] = [
  {
    id: 'aurora',
    name: 'Aurora',
    isPro: false,
    colors: {
      primary: '#7B68EE',
      secondary: '#00CED1',
      gradient: ['#4059BF', '#7359CC', '#33408C'],
    },
  },
  {
    id: 'calming-blues',
    name: 'Calming Blues',
    isPro: true,
    colors: {
      primary: '#4DA8C8',
      secondary: '#3898B8',
      gradient: ['#3380A6', '#4794B8', '#2E7399'],
    },
  },
  {
    id: 'forest-earth',
    name: 'Forest Earth',
    isPro: true,
    colors: {
      primary: '#4E785E',
      secondary: '#2A4B44',
      gradient: ['#2E734D', '#408561', '#266140'],
    },
  },
  {
    id: 'soft-tranquil',
    name: 'Soft Tranquil',
    isPro: true,
    colors: {
      primary: '#C88060',
      secondary: '#A87058',
      gradient: ['#D99973', '#C78585', '#B3807A'],
    },
  },
  {
    id: 'blue-green-harmony',
    name: 'Blue-Green',
    isPro: true,
    colors: {
      primary: '#00B0A8',
      secondary: '#009890',
      gradient: ['#0099A6', '#148594', '#00808C'],
    },
  },
  {
    id: 'midnight',
    name: 'Midnight',
    isPro: true,
    colors: {
      primary: '#6366F1',
      secondary: '#8B5CF6',
      gradient: ['#59528C', '#6B61AD', '#524D85'],
    },
  },
];
