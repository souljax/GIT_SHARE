#!/bin/bash
# cleanup-repo.sh - Nettoie le repo des submodules et dossiers .git imbriqués
# Usage: ./cleanup-repo.sh

set -e

REPO_ROOT="/home/akdev/GIT_SHARE/souljax_dev_tools"
cd "$REPO_ROOT"

echo "🧹 Nettoyage du repository..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 1. Vérifier les submodules accidentels
echo ""
echo "🔍 Vérification des submodules/gitlinks..."
GITLINKS=$(git ls-files --stage | grep '^160000' || true)

if [ -n "$GITLINKS" ]; then
    echo "⚠️  Submodules/gitlinks trouvés:"
    echo "$GITLINKS"
    
    while IFS= read -r line; do
        if [ -n "$line" ]; then
            SUBMODULE_PATH=$(echo "$line" | awk '{print $4}')
            echo "   → Suppression de: $SUBMODULE_PATH"
            git rm --cached "$SUBMODULE_PATH" 2>/dev/null || true
        fi
    done <<< "$GITLINKS"
else
    echo "✅ Aucun submodule trouvé"
fi

# 2. Chercher les dossiers .git imbriqués
echo ""
echo "🔍 Recherche de dossiers .git imbriqués..."
NESTED_GITS=$(find . -mindepth 2 -name ".git" -type d 2>/dev/null || true)

if [ -n "$NESTED_GITS" ]; then
    echo "⚠️  Dossiers .git imbriqués trouvés:"
    while IFS= read -r git_dir; do
        if [ -n "$git_dir" ]; then
            echo "   → $git_dir"
            read -p "   Supprimer ce dossier .git? (y/N) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm -rf "$git_dir"
                echo "   ✅ Supprimé"
            fi
        fi
    done <<< "$NESTED_GITS"
else
    echo "✅ Aucun dossier .git imbriqué"
fi

# 3. Nettoyer les node_modules dans le repo principal
echo ""
echo "🔍 Recherche de node_modules non-gitignorés..."
NODE_MODULES=$(git ls-files | grep "node_modules/" || true)

if [ -n "$NODE_MODULES" ]; then
    echo "⚠️  Fichiers node_modules versionnés trouvés"
    echo "   → Nettoyage..."
    git rm -r --cached node_modules/ 2>/dev/null || true
    echo "✅ node_modules retiré du tracking"
else
    echo "✅ Pas de node_modules versionnés"
fi

# 4. Vérifier les fichiers de build non-gitignorés
echo ""
echo "🔍 Vérification des builds versionnés..."
BUILD_FILES=$(git ls-files | grep -E "(dist/|build/|\.output/)" | grep -v "VueJS/bouncing-tech-logos/dist/" || true)

if [ -n "$BUILD_FILES" ]; then
    echo "⚠️  Fichiers de build versionnés (sauf exceptions):"
    echo "$BUILD_FILES" | head -5
    echo "   💡 Vérifiez votre .gitignore"
else
    echo "✅ Pas de builds non-désirés"
fi

# 5. Résumé et commit
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Résumé du nettoyage"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if git status --porcelain | grep -q .; then
    echo ""
    echo "📝 Modifications détectées:"
    git status --short
    echo ""
    read -p "Committer ces changements? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add -A
        git commit -m "chore: cleanup repository - remove nested git dirs and submodules"
        echo "✅ Changements commités"
        echo ""
        read -p "Pousser vers origin/main? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git push origin main
            echo "✅ Changements poussés"
        fi
    fi
else
    echo "✅ Repository propre - aucune modification"
fi

echo ""
echo "🎉 Nettoyage terminé!"
