#!/bin/bash
# deploy-component.sh - Déploie un composant complet sur GitHub Pages
# Usage: ./deploy-component.sh <framework> <component-name>

set -e

FRAMEWORK=$1
COMPONENT=$2

PROD_ROOT="/home/akdev/GIT_SHARE/souljax_dev_tools"
COMPONENT_PATH="$PROD_ROOT/$FRAMEWORK/$COMPONENT"

# Validation
if [ -z "$FRAMEWORK" ] || [ -z "$COMPONENT" ]; then
    echo "❌ Usage: ./deploy-component.sh <framework> <component-name>"
    echo ""
    echo "Example: ./deploy-component.sh ReactJS bouncing-tech-logos"
    exit 1
fi

if [ ! -d "$COMPONENT_PATH" ]; then
    echo "❌ Composant introuvable: $COMPONENT_PATH"
    exit 1
fi

echo "🚀 Déploiement GitHub Pages"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   Framework: $FRAMEWORK"
echo "   Composant: $COMPONENT"
echo ""

# 1. Vérifier le package.json
cd "$COMPONENT_PATH"

if [ ! -f "package.json" ]; then
    echo "❌ package.json manquant"
    exit 1
fi

PACKAGE_NAME=$(jq -r '.name' package.json)
PACKAGE_VERSION=$(jq -r '.version' package.json)

echo "📦 Package: $PACKAGE_NAME v$PACKAGE_VERSION"
echo ""

# 2. Nettoyer et installer
echo "🧹 Nettoyage..."
rm -rf node_modules dist .vite

echo "📥 Installation des dépendances..."
npm ci

# 3. Build de production
echo "🔨 Build de production..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build échoué!"
    exit 1
fi

echo "✅ Build réussi"

# 4. Vérifier les assets
if [ ! -d "dist" ]; then
    echo "❌ Dossier dist/ manquant après build"
    exit 1
fi

DIST_SIZE=$(du -sh dist | cut -f1)
echo "   Taille du build: $DIST_SIZE"

# 5. Commit et push
cd "$PROD_ROOT"

echo ""
echo "📝 Préparation du commit..."

git add "$FRAMEWORK/$COMPONENT"

if ! git diff --cached --quiet; then
    echo "   Changements détectés"
    
    git commit -m "deploy($FRAMEWORK): update $COMPONENT to v$PACKAGE_VERSION

- Production build with optimized assets
- Size: $DIST_SIZE
- Ready for GitHub Pages deployment

Component available at:
https://souljax.github.io/souljax_dev_tools/$FRAMEWORK/$COMPONENT/"
    
    echo "✅ Commit créé"
    
    echo ""
    echo "📤 Push vers GitHub..."
    git push origin main
    
    echo "✅ Poussé vers origin/main"
    
    # 6. Surveiller le déploiement
    echo ""
    echo "⏳ Surveillance du déploiement GitHub Pages..."
    sleep 5
    
    for i in {1..12}; do
        BUILD_STATUS=$(curl -s "https://api.github.com/repos/souljax/souljax_dev_tools/actions/runs?per_page=1" | \
                       jq -r '.workflow_runs[0] | "\(.status):\(.conclusion // "pending")"')
        
        echo "   [$i/12] Build: $BUILD_STATUS"
        
        if [[ "$BUILD_STATUS" == "completed:success" ]]; then
            echo ""
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "🎉 Déploiement réussi!"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo ""
            echo "🌐 URL disponible:"
            echo "   https://souljax.github.io/souljax_dev_tools/$FRAMEWORK/$COMPONENT/"
            echo ""
            
            # Tester l'URL
            sleep 3
            HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://souljax.github.io/souljax_dev_tools/$FRAMEWORK/$COMPONENT/")
            
            if [ "$HTTP_CODE" = "200" ]; then
                echo "✅ URL accessible (HTTP $HTTP_CODE)"
            else
                echo "⚠️  URL répond mais pas encore 200 (HTTP $HTTP_CODE)"
                echo "   Attends quelques minutes pour la propagation..."
            fi
            
            exit 0
        elif [[ "$BUILD_STATUS" == "completed:failure" ]]; then
            echo ""
            echo "❌ Le déploiement a échoué!"
            echo "   👉 Logs: https://github.com/souljax/souljax_dev_tools/actions"
            exit 1
        fi
        
        sleep 5
    done
    
    echo ""
    echo "⏳ Le déploiement prend plus de temps..."
    echo "   👉 Vérifie: https://github.com/souljax/souljax_dev_tools/actions"
    
else
    echo "   Aucun changement à déployer"
fi

echo ""
echo "🎉 Déploiement terminé!"
