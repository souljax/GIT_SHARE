#!/bin/bash
# reactivate-pages.sh - Réactive GitHub Pages après passage private→public
# Usage: ./reactivate-pages.sh

set -e

REPO_ROOT="/home/akdev/GIT_SHARE/souljax_dev_tools"
REPO_NAME="souljax_dev_tools"
REPO_OWNER="souljax"

cd "$REPO_ROOT"

echo "🚀 Réactivation GitHub Pages"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 1. Vérifier l'état du repo
echo ""
echo "🔍 Vérification du repository..."

REPO_INFO=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME")
IS_PRIVATE=$(echo "$REPO_INFO" | jq -r '.private')
HAS_PAGES=$(echo "$REPO_INFO" | jq -r '.has_pages')

echo "   Repository: $REPO_OWNER/$REPO_NAME"
echo "   Privé: $IS_PRIVATE"
echo "   Pages activé: $HAS_PAGES"

if [ "$IS_PRIVATE" = "true" ]; then
    echo ""
    echo "❌ Le repository est encore PRIVÉ!"
    echo "   👉 Va sur: https://github.com/$REPO_OWNER/$REPO_NAME/settings"
    echo "   👉 Change Visibility → Public"
    exit 1
fi

# 2. Vérifier l'état de GitHub Pages
echo ""
echo "🔍 Vérification GitHub Pages..."

PAGES_STATUS=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/pages" | jq -r '.status // "404"')

if [ "$PAGES_STATUS" = "404" ]; then
    echo "⚠️  GitHub Pages n'est PAS activé"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📋 ÉTAPES MANUELLES REQUISES"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "1. Ouvre cette URL:"
    echo "   👉 https://github.com/$REPO_OWNER/$REPO_NAME/settings/pages"
    echo ""
    echo "2. Configure:"
    echo "   • Source: Deploy from a branch"
    echo "   • Branch: main"
    echo "   • Folder: / (root)"
    echo ""
    echo "3. Clique sur 'Save'"
    echo ""
    read -p "Appuie sur ENTER quand c'est fait..."
fi

# 3. Nettoyer le repo
echo ""
echo "🧹 Nettoyage du repository..."

# Lancer le script de cleanup si disponible
if [ -f "./scripts/cleanup-repo.sh" ]; then
    echo "   Utilisation de cleanup-repo.sh..."
    # Note: on ne l'exécute pas automatiquement car il est interactif
    echo "   💡 Lance manuellement: ./scripts/cleanup-repo.sh"
else
    # Nettoyage basique
    echo "   Vérification rapide..."
    GITLINKS=$(git ls-files --stage | grep '^160000' || true)
    if [ -n "$GITLINKS" ]; then
        echo "   ⚠️  Submodules détectés - nettoyage..."
        while IFS= read -r line; do
            if [ -n "$line" ]; then
                SUBMODULE_PATH=$(echo "$line" | awk '{print $4}')
                git rm --cached "$SUBMODULE_PATH" 2>/dev/null || true
            fi
        done <<< "$GITLINKS"
        git add -A
        git commit -m "fix: remove nested submodules for Pages deployment"
    else
        echo "   ✅ Repo propre"
    fi
fi

# 4. Forcer un rebuild
echo ""
echo "🔄 Déclenchement d'un rebuild GitHub Pages..."

if git diff --quiet && git diff --cached --quiet; then
    # Aucun changement - commit vide
    git commit --allow-empty -m "chore: trigger GitHub Pages rebuild after reactivation"
else
    # Il y a des changements - commit normal
    git add -A
    git commit -m "chore: cleanup and trigger GitHub Pages rebuild"
fi

git push origin main

echo "✅ Commit poussé - Build en cours..."

# 5. Surveiller le build
echo ""
echo "⏳ Surveillance du build (30 secondes)..."
sleep 10

for i in {1..6}; do
    BUILD_STATUS=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/runs?per_page=1" | \
                   jq -r '.workflow_runs[0] | "\(.status):\(.conclusion // "pending")"')
    
    echo "   [$i/6] Status: $BUILD_STATUS"
    
    if [[ "$BUILD_STATUS" == "completed:success" ]]; then
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "🎉 GitHub Pages déployé avec succès!"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "🌐 URLs disponibles:"
        echo "   • https://$REPO_OWNER.github.io/$REPO_NAME/"
        echo "   • https://$REPO_OWNER.github.io/$REPO_NAME/VueJS/bouncing-tech-logos/"
        echo "   • https://$REPO_OWNER.github.io/$REPO_NAME/ReactJS/bouncing-tech-logos/"
        echo ""
        exit 0
    elif [[ "$BUILD_STATUS" == "completed:failure" ]]; then
        echo ""
        echo "❌ Le build a échoué!"
        echo "   👉 Vérifie les logs: https://github.com/$REPO_OWNER/$REPO_NAME/actions"
        exit 1
    fi
    
    sleep 5
done

echo ""
echo "⏳ Le build prend plus de temps que prévu..."
echo "   👉 Vérifie manuellement: https://github.com/$REPO_OWNER/$REPO_NAME/actions"
echo "   👉 Pages seront dispo sous: https://$REPO_OWNER.github.io/$REPO_NAME/"
