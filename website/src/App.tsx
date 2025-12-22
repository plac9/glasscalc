import { MeshGradient } from './components/ui';
import { Header, Footer } from './components/layout';
import { Hero, Features, Demo, Screenshots, Themes, Accessibility, Roadmap, FAQ, About, CTA } from './components/sections';

import './styles/index.css';
import './styles/animations.css';
import './styles/components.css';
import './App.css';

function App() {
  return (
    <>
      <MeshGradient />
      <Header />
      <main>
        <Hero />
        <Features />
        <Demo />
        <Screenshots />
        <Themes />
        <Accessibility />
        <Roadmap />
        <FAQ />
        <About />
        <CTA />
      </main>
      <Footer />
    </>
  );
}

export default App;
