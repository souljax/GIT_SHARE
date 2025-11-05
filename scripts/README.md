# 🛠️ Scripts Utilitaires - SOULJAX Dev Tools

Collection de scripts Bash pour automatiser la gestion du workflow GitHub Pages et des composants.

## 📋 Scripts Disponibles

### 1. **cleanup-repo.sh** 🧹
Nettoie le repository des submodules et dossiers `.git` imbriqués problématiques.

**Usage:**
```bash
./scripts/cleanup-repo.sh
```

**Fonctionnalités:**
- ✅ Détecte et supprime les submodules/gitlinks (mode 160000)
- ✅ Trouve les dossiers `.git` imbriqués
- ✅ Retire les `node_modules` versionnés par erreur
- ✅ Vérifie les builds non-gitignorés
- ✅ Mode interactif avec confirmations
- ✅ Propose de committer et pousser automatiquement

**Quand l'utiliser:**
- Après avoir ajouté accidentellement un dossier avec `.git`
- Avant de réactiver GitHub Pages
- Quand les builds GitHub Pages échouent mystérieusement

---

### 2. **reactivate-pages.sh** 🚀
Réactive GitHub Pages après avoir remis un repo public (private → public).

**Usage:**
```bash
./scripts/reactivate-pages.sh
```

**Fonctionnalités:**
- ✅ Vérifie que le repo est bien public
- ✅ Détecte si GitHub Pages est activé
- ✅ Guide pour l'activation manuelle (si nécessaire)
- ✅ Nettoie le repo automatiquement
- ✅ Force un rebuild avec commit vide
- ✅ Surveille le build en temps réel
- ✅ Affiche les URLs dès que disponibles

**Quand l'utiliser:**
- Après avoir remis un repo private en public
- Quand GitHub Pages ne se réactive pas automatiquement
- Pour vérifier l'état complet de Pages

---

### 3. **check-pages-status.sh** 🔍
Affiche l'état complet de GitHub Pages et des déploiements.

**Usage:**
```bash
# Vérification ponctuelle
./scripts/check-pages-status.sh

# Mode surveillance (rafraîchit toutes les 10s)
./scripts/check-pages-status.sh --watch
```

**Fonctionnalités:**
- ✅ État du repository (public/private)
- ✅ Configuration GitHub Pages
- ✅ Historique des 3 derniers builds
- ✅ Test d'accessibilité des URLs principales
- ✅ Informations sur le dernier commit
- ✅ Mode surveillance en temps réel

**Quand l'utiliser:**
- Pour vérifier rapidement l'état de Pages
- Pendant un déploiement (mode --watch)
- Pour diagnostiquer des problèmes d'accessibilité

---

### 4. **sync-to-production.sh** 🔄
Synchronise un composant de l'environnement TEST vers PRODUCTION.

**Usage:**
```bash
./scripts/sync-to-production.sh <framework> <component-name>

# Examples:
./scripts/sync-to-production.sh VueJS bouncing-tech-logos
./scripts/sync-to-production.sh ReactJS my-new-component
```

**Fonctionnalités:**
- ✅ Vérifie le composant en TEST
- ✅ Teste le build avant synchronisation
- ✅ Sauvegarde l'ancienne version en production
- ✅ Copie intelligente (exclut node_modules, .cache, etc.)
- ✅ Rebuild propre en production
- ✅ Copie le dist vers GitHub Pages
- ✅ Propose de committer et pousser

**Quand l'utiliser:**
- Après avoir développé et testé un composant
- Pour déployer une mise à jour validée
- Workflow: `GIT_SHARE_TEST` → `GIT_SHARE`

**Structure attendue:**
```
/home/akdev/GIT_SHARE_TEST/
└── VueJS/
    └── mon-composant/
        ├── package.json
        ├── src/
        └── dist/

↓ Synchronisation ↓

/home/akdev/GIT_SHARE/souljax_dev_tools/
└── VueJS/
    └── mon-composant/
        ├── package.json (production)
        ├── src/
        └── dist/
```

---

### 5. **deploy-component.sh** 📤
Déploie un composant existant sur GitHub Pages.

**Usage:**
```bash
./scripts/deploy-component.sh <framework> <component-name>

# Example:
./scripts/deploy-component.sh ReactJS bouncing-tech-logos
```

**Fonctionnalités:**
- ✅ Nettoie et rebuild le composant
- ✅ Vérifie la taille du build
- ✅ Commit avec message détaillé
- ✅ Push vers GitHub
- ✅ Surveille le déploiement GitHub Pages
- ✅ Teste l'accessibilité de l'URL finale

**Quand l'utiliser:**
- Pour mettre à jour un composant déjà en production
- Après une modification directe dans `GIT_SHARE`
- Pour forcer un redéploiement

---

## 🔄 Workflow Complet

### **Scénario 1: Nouveau composant**
```bash
# 1. Développer dans TEST
cd /home/akdev/GIT_SHARE_TEST/VueJS/my-component
npm run dev
npm run build

# 2. Synchroniser vers production
cd /home/akdev/GIT_SHARE/souljax_dev_tools
./scripts/sync-to-production.sh VueJS my-component

# 3. Déployer sur GitHub Pages
./scripts/deploy-component.sh VueJS my-component

# 4. Vérifier le statut
./scripts/check-pages-status.sh
```

### **Scénario 2: Réactivation après private→public**
```bash
# 1. Remettre le repo en public (via GitHub.com)

# 2. Réactiver Pages
cd /home/akdev/GIT_SHARE/souljax_dev_tools
./scripts/reactivate-pages.sh

# 3. Surveiller le déploiement
./scripts/check-pages-status.sh --watch
```

### **Scénario 3: Nettoyage d'urgence**
```bash
# Si les builds échouent sans raison apparente
cd /home/akdev/GIT_SHARE/souljax_dev_tools
./scripts/cleanup-repo.sh

# Puis forcer un rebuild
git commit --allow-empty -m "chore: trigger rebuild"
git push origin main
```

---

## 🔧 Configuration

### Variables d'environnement (optionnel)
```bash
# Dans ton ~/.bashrc ou ~/.zshrc
export SOULJAX_TEST_ROOT="/home/akdev/GIT_SHARE_TEST"
export SOULJAX_PROD_ROOT="/home/akdev/GIT_SHARE/souljax_dev_tools"
export SOULJAX_REPO_OWNER="souljax"
export SOULJAX_REPO_NAME="souljax_dev_tools"
```

### Dépendances requises
- `bash` (v4.0+)
- `git`
- `curl`
- `jq` (pour parser JSON)
- `rsync` (pour sync-to-production.sh)

**Installation des dépendances:**
```bash
sudo apt update
sudo apt install -y git curl jq rsync
```

---

## 🚨 Troubleshooting

### **Problème: "Permission denied"**
```bash
chmod +x scripts/*.sh
```

### **Problème: "jq: command not found"**
```bash
sudo apt install jq
```

### **Problème: Builds qui échouent toujours**
1. Lance `cleanup-repo.sh`
2. Vérifie `.gitignore`
3. Cherche les dossiers `.git` imbriqués: `find . -name ".git" -type d`

### **Problème: Pages 404 après déploiement**
1. Vérifie que Pages est activé: Settings → Pages
2. Attends 2-3 minutes (propagation DNS)
3. Vérifie avec: `./scripts/check-pages-status.sh`

---

## 📝 Notes

- **Tous les scripts sont idempotents** : tu peux les relancer sans danger
- **Mode interactif** : la plupart demandent confirmation avant actions destructives
- **Sauvegardes automatiques** : `sync-to-production.sh` sauvegarde dans `.backups/`
- **Logs détaillés** : tous les scripts affichent ce qu'ils font

---

## 🤝 Contribution

Pour ajouter un nouveau script :
1. Créer le fichier dans `scripts/`
2. Ajouter le shebang : `#!/bin/bash`
3. Documenter l'usage en en-tête
4. Rendre exécutable : `chmod +x scripts/ton-script.sh`
5. Documenter ici dans le README

---

*Scripts créés par [SOULJAX](https://souljax.com) - Novembre 2025*
