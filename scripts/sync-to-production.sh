#!/bin/bash
# sync-to-production.sh - Synchronise un composant de TEST vers PRODUCTION
# Usage: ./sync-to-production.sh <framework> <component-name>
#   Example: ./sync-to-production.sh VueJS bouncing-tech-logos

set -e

FRAMEWORK=$1
COMPONENT=$2

TEST_ROOT="/home/akdev/GIT_SHARE_TEST"
PROD_ROOT="/home/akdev/GIT_SHARE/souljax_dev_tools"

# Validation des arguments
if [ -z "$FRAMEWORK" ] || [ -z "$COMPONENT" ]; then
    echo "❌ Usage: ./sync-to-production.sh <framework> <component-name>"
    echo ""
    echo "Frameworks disponibles:"
    echo "   • VueJS"
    echo "   • ReactJS"
    echo "   • VanillaJS"
    echo ""
    echo "Example:"
    echo "   ./sync-to-production.sh VueJS bouncing-tech-logos"
    exit 1
fi

# Vérifier que le framework existe
if [ "$FRAMEWORK" != "VueJS" ] && [ "$FRAMEWORK" != "ReactJS" ] && [ "$FRAMEWORK" != "VanillaJS" ]; then
    echo "❌ Framework invalide: $FRAMEWORK"
    echo "   Utilise: VueJS, ReactJS, ou VanillaJS"
    exit 1
fi

TEST_PATH="$TEST_ROOT/$FRAMEWORK/$COMPONENT"
PROD_PATH="$PROD_ROOT/$FRAMEWORK/$COMPONENT"

# Vérifier que le composant existe en TEST
if [ ! -d "$TEST_PATH" ]; then
    echo "❌ Composant introuvable: $TEST_PATH"
    exit 1
fi

echo "🔄 Synchronisation TEST → PRODUCTION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   Source: $TEST_PATH"
echo "   Destination: $PROD_PATH"
echo ""

# 1. Vérifier l'état du composant de test
echo "🔍 Vérification du composant en TEST..."

if [ ! -f "$TEST_PATH/package.json" ]; then
    echo "❌ package.json manquant dans $TEST_PATH"
    exit 1
fi

PACKAGE_NAME=$(jq -r '.name' "$TEST_PATH/package.json")
PACKAGE_VERSION=$(jq -r '.version' "$TEST_PATH/package.json")
echo "   Composant: $PACKAGE_NAME v$PACKAGE_VERSION"

# 2. Tester le build
echo ""
echo "🔨 Test du build..."
cd "$TEST_PATH"

if [ -d "node_modules" ]; then
    echo "   node_modules existant - skip install"
else
    echo "   Installation des dépendances..."
    npm ci --silent
fi

echo "   Build en cours..."
npm run build --silent

if [ $? -ne 0 ]; then
    echo "❌ Le build a échoué!"
    exit 1
fi

echo "✅ Build réussi"

# 3. Sauvegarder l'ancien package en production (si existe)
if [ -d "$PROD_PATH" ]; then
    echo ""
    echo "💾 Sauvegarde de l'ancienne version..."
    BACKUP_DIR="$PROD_ROOT/.backups/$FRAMEWORK/$COMPONENT-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    cp -r "$PROD_PATH" "$BACKUP_DIR/"
    echo "   Sauvegardé dans: $BACKUP_DIR"
fi

# 4. Copier vers production
echo ""
echo "📦 Copie vers PRODUCTION..."
mkdir -p "$(dirname "$PROD_PATH")"
rsync -av --delete \
    --exclude 'node_modules' \
    --exclude '.vite' \
    --exclude '.cache' \
    --exclude '*.log' \
    "$TEST_PATH/" "$PROD_PATH/"

echo "✅ Copie terminée"

# 5. Nettoyer et rebuilder en production
echo ""
echo "🧹 Nettoyage et rebuild en production..."
cd "$PROD_PATH"

rm -rf node_modules dist .vite

echo "   Installation des dépendances (production only)..."
npm ci --only=production --silent

echo "   Build de production..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Le build de production a échoué!"
    echo "   La sauvegarde est disponible dans: $BACKUP_DIR"
    exit 1
fi

echo "✅ Build de production réussi"

# 6. Copier le dist vers le dossier GitHub Pages (si nécessaire)
PAGES_PATH="$PROD_ROOT/$FRAMEWORK/$COMPONENT"

if [ -d "$PROD_PATH/dist" ]; then
    echo ""
    echo "📤 Copie du build vers GitHub Pages..."
    mkdir -p "$PAGES_PATH"
    cp -r "$PROD_PATH/dist/"* "$PAGES_PATH/" 2>/dev/null || true
    echo "✅ Build copié vers: $PAGES_PATH"
fi

# 7. Afficher le résumé
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Synchronisation terminée!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 Résumé:"
echo "   • Composant: $PACKAGE_NAME v$PACKAGE_VERSION"
echo "   • Framework: $FRAMEWORK"
echo "   • Path production: $PROD_PATH"
echo ""

# 8. Proposer de committer
cd "$PROD_ROOT"

if git status --porcelain | grep -q .; then
    echo "📝 Modifications Git détectées"
    echo ""
    git status --short
    echo ""
    read -p "Committer ces changements? (y/N) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add "$FRAMEWORK/$COMPONENT"
        git commit -m "feat($FRAMEWORK): sync $COMPONENT v$PACKAGE_VERSION from test to production

- Build tested and validated
- Production dependencies installed
- GitHub Pages assets updated"
        
        echo "✅ Changements commités"
        echo ""
        read -p "Pousser vers origin/main? (y/N) " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git push origin main
            echo "✅ Changements poussés"
            echo ""
            echo "🌐 Le composant sera disponible sous:"
            echo "   https://souljax.github.io/souljax_dev_tools/$FRAMEWORK/$COMPONENT/"
        fi
    fi
fi

echo ""
echo "🎉 Synchronisation complète!"
