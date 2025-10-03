# 🔄 CONVERSION RAPIDE : Framework → GitHub Pages

## Vue.js → Vanilla JS

### **TEMPLATE CONVERSION**
```html
<!-- VUE.JS -->
<template>
  <div class="container">
    <h1>{{ title }}</h1>
    <button @click="increment">{{ count }}</button>
    <div v-if="showMessage">Message visible</div>
  </div>
</template>

<!-- VANILLA HTML -->
<div class="container">
  <h1 id="title">Mon titre</h1>
  <button onclick="increment()" id="counter">0</button>
  <div id="message" style="display: none;">Message visible</div>
</div>
```

### **SCRIPT CONVERSION**
```javascript
// VUE.JS
export default {
  data() {
    return {
      title: 'Mon Component',
      count: 0,
      showMessage: false
    }
  },
  methods: {
    increment() {
      this.count++;
      this.showMessage = this.count > 5;
    }
  }
}

// VANILLA JS
let state = {
  title: 'Mon Component',
  count: 0,
  showMessage: false
};

function increment() {
  state.count++;
  state.showMessage = state.count > 5;
  updateUI();
}

function updateUI() {
  document.getElementById('counter').textContent = state.count;
  document.getElementById('message').style.display = state.showMessage ? 'block' : 'none';
}
```

### **STYLE CONVERSION**
```css
/* VUE.JS (scoped) */
<style scoped>
.container { padding: 20px; }
.container h1 { color: blue; }
</style>

/* VANILLA CSS */
<style>
.container { padding: 20px; }
.container h1 { color: blue; }
</style>
```

---

## React → Vanilla JS

### **COMPONENT CONVERSION**
```javascript
// REACT
import React, { useState } from 'react';

function MyComponent() {
  const [count, setCount] = useState(0);
  const [visible, setVisible] = useState(false);
  
  const handleClick = () => {
    setCount(count + 1);
    setVisible(count + 1 > 5);
  };
  
  return (
    <div className="container">
      <h1>React Component</h1>
      <button onClick={handleClick}>{count}</button>
      {visible && <div>Message visible</div>}
    </div>
  );
}

// VANILLA JS
let state = {
  count: 0,
  visible: false
};

function handleClick() {
  state.count++;
  state.visible = state.count > 5;
  updateUI();
}

function updateUI() {
  document.getElementById('counter').textContent = state.count;
  document.getElementById('message').style.display = state.visible ? 'block' : 'none';
}

// HTML
// <div class="container">
//   <h1>React Component</h1>
//   <button onclick="handleClick()" id="counter">0</button>
//   <div id="message" style="display: none;">Message visible</div>
// </div>
```

---

## 🎨 CONVERSIONS COMMUNES

### **Event Handling**
```javascript
// VUE: @click="method"
// REACT: onClick={method}
// VANILLA: onclick="method()" ou addEventListener('click', method)
```

### **Conditional Rendering**
```javascript
// VUE: v-if="condition"
// REACT: {condition && <div>...</div>}
// VANILLA: element.style.display = condition ? 'block' : 'none';
```

### **Loops**
```javascript
// VUE: v-for="item in items"
// REACT: {items.map(item => <div key={item.id}>...)}
// VANILLA: items.forEach(item => { /* create DOM elements */ });
```

### **Two-way Binding**
```javascript
// VUE: v-model="value"
// REACT: value={value} onChange={setValue}
// VANILLA: 
// input.value = state.value;
// input.addEventListener('input', (e) => {
//   state.value = e.target.value;
//   updateUI();
// });
```

---

## 🛠️ TEMPLATE COMPLET GITHUB PAGES

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Component Demo</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: Arial, sans-serif; }
    
    /* Styles du component original */
    .container { padding: 20px; }
    .header { background: #2e3b4e; color: white; padding: 15px; }
    .footer { background: #2e3b4e; color: white; padding: 15px; }
    
    /* Classes utilitaires */
    .hidden { display: none !important; }
    .visible { display: block !important; }
  </style>
</head>
<body>
  <!-- Structure HTML -->
  <div class="header">HEADER</div>
  
  <div class="container" id="app">
    <h1 id="title">Loading...</h1>
    <button onclick="handleAction()" id="actionBtn">Click me</button>
    <div id="result" class="hidden">Résultat</div>
  </div>
  
  <div class="footer">FOOTER</div>
  
  <script>
    // État global de l'application
    let state = {
      title: 'Mon Component',
      count: 0,
      items: [],
      loading: false
    };
    
    // Fonctions métier (logique du component)
    function handleAction() {
      state.count++;
      console.log('Action triggered:', state.count);
      updateUI();
    }
    
    function addItem(item) {
      state.items.push(item);
      updateUI();
    }
    
    // Fonction de mise à jour de l'interface
    function updateUI() {
      // Mettre à jour le titre
      document.getElementById('title').textContent = state.title;
      
      // Mettre à jour le bouton
      document.getElementById('actionBtn').textContent = `Cliqué ${state.count} fois`;
      
      // Afficher/cacher le résultat
      const result = document.getElementById('result');
      if (state.count > 3) {
        result.classList.remove('hidden');
        result.classList.add('visible');
      } else {
        result.classList.add('hidden');
        result.classList.remove('visible');
      }
    }
    
    // Gestion des événements
    function setupEventListeners() {
      // Écouter les redimensionnements
      window.addEventListener('resize', () => {
        console.log('Window resized');
        // Ajuster l'interface si nécessaire
      });
      
      // Autres event listeners...
    }
    
    // Initialisation
    document.addEventListener('DOMContentLoaded', () => {
      console.log('🚀 Component initialized');
      
      // Setup initial
      state.title = 'Component Ready!';
      updateUI();
      setupEventListeners();
      
      // Autres initialisations...
    });
    
    // Utils (si nécessaire)
    function debounce(func, wait) {
      let timeout;
      return function executedFunction(...args) {
        const later = () => {
          clearTimeout(timeout);
          func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
      };
    }
  </script>
</body>
</html>
```

---

## 📋 CHECKLIST CONVERSION

### **Avant conversion :**
- [ ] Identifier les données réactives (data, state)
- [ ] Lister tous les événements (@click, onClick, etc.)
- [ ] Noter les conditions d'affichage (v-if, conditional rendering)
- [ ] Repérer les boucles (v-for, map)
- [ ] Extraire les styles (scoped → global)

### **Pendant conversion :**
- [ ] Créer l'état global JavaScript
- [ ] Convertir template → HTML statique
- [ ] Ajouter IDs aux éléments dynamiques
- [ ] Créer fonction updateUI()
- [ ] Convertir methods → fonctions globales
- [ ] Tester chaque interaction

### **Après conversion :**
- [ ] Test complet en local
- [ ] Vérifier console (F12) sans erreurs
- [ ] Test responsive
- [ ] Optimiser performance si nécessaire
- [ ] Push et test sur GitHub Pages

---

## 🎯 EXEMPLE RÉEL : Bouncing Logos

### **Notre conversion réussie :**

**Vue.js original :** 200+ lignes avec Composition API, reactive, watchers
**HTML final :** Version standalone qui marche parfaitement

**Éléments convertis :**
- `ref()` → variables globales
- `onMounted()` → `DOMContentLoaded`
- `@mouseenter/@mouseleave` → `onmouseenter/onmouseleave`
- `@click` → `onclick`
- `:style` → `element.style.X`
- `v-for` → `forEach` + `createElement`

**Résultat :** Page GitHub parfaitement fonctionnelle ! 🎉