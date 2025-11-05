#!/bin/bash
# check-pages-status.sh - Vérifie l'état de GitHub Pages et des déploiements
# Usage: ./check-pages-status.sh [--watch]

REPO_OWNER="souljax"
REPO_NAME="souljax_dev_tools"
WATCH_MODE=false

if [ "$1" = "--watch" ]; then
    WATCH_MODE=true
fi

check_status() {
    clear
    echo "🔍 Status GitHub Pages - $(date '+%H:%M:%S')"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # 1. État du repository
    echo ""
    echo "📦 Repository Info:"
    REPO_INFO=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME")
    IS_PRIVATE=$(echo "$REPO_INFO" | jq -r '.private')
    HAS_PAGES=$(echo "$REPO_INFO" | jq -r '.has_pages')
    
    echo "   Visibility: $([ "$IS_PRIVATE" = "true" ] && echo "🔒 Private" || echo "🌐 Public")"
    echo "   Pages: $([ "$HAS_PAGES" = "true" ] && echo "✅ Enabled" || echo "❌ Disabled")"
    
    # 2. Configuration Pages
    echo ""
    echo "⚙️  Pages Configuration:"
    PAGES_INFO=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/pages")
    PAGES_STATUS=$(echo "$PAGES_INFO" | jq -r '.status // "not_configured"')
    
    if [ "$PAGES_STATUS" != "not_configured" ] && [ "$PAGES_STATUS" != "404" ]; then
        PAGES_URL=$(echo "$PAGES_INFO" | jq -r '.html_url')
        BUILD_STATUS=$(echo "$PAGES_INFO" | jq -r '.build_status // "unknown"')
        
        echo "   URL: $PAGES_URL"
        echo "   Build Status: $BUILD_STATUS"
    else
        echo "   ⚠️  Pages non configuré"
        echo "   👉 https://github.com/$REPO_OWNER/$REPO_NAME/settings/pages"
    fi
    
    # 3. Derniers builds
    echo ""
    echo "🔨 Derniers Builds (Actions):"
    BUILDS=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/runs?per_page=3")
    
    echo "$BUILDS" | jq -r '.workflow_runs[] | 
        "   • " + 
        (if .status == "completed" then
            (if .conclusion == "success" then "✅" 
             elif .conclusion == "failure" then "❌"
             elif .conclusion == "cancelled" then "🚫"
             else "⚠️" end)
         else "🔄" end) + 
        " " + .name + 
        " (" + .status + 
        (if .conclusion then "/" + .conclusion else "" end) + ")" +
        " - " + (.created_at | sub("T.*"; ""))
    '
    
    # 4. Accessibilité des URLs
    echo ""
    echo "🌐 Accessibilité des Pages:"
    
    URLS=(
        "https://$REPO_OWNER.github.io/$REPO_NAME/"
        "https://$REPO_OWNER.github.io/$REPO_NAME/VueJS/bouncing-tech-logos/"
        "https://$REPO_OWNER.github.io/$REPO_NAME/ReactJS/bouncing-tech-logos/"
    )
    
    for url in "${URLS[@]}"; do
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$url")
        if [ "$HTTP_CODE" = "200" ]; then
            echo "   ✅ $url"
        else
            echo "   ❌ $url (HTTP $HTTP_CODE)"
        fi
    done
    
    # 5. Dernier commit
    echo ""
    echo "📝 Dernier Commit:"
    LAST_COMMIT=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/commits/main")
    COMMIT_MSG=$(echo "$LAST_COMMIT" | jq -r '.commit.message' | head -1)
    COMMIT_DATE=$(echo "$LAST_COMMIT" | jq -r '.commit.author.date')
    COMMIT_SHA=$(echo "$LAST_COMMIT" | jq -r '.sha' | cut -c1-7)
    
    echo "   $COMMIT_SHA - $COMMIT_MSG"
    echo "   Date: $COMMIT_DATE"
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

if [ "$WATCH_MODE" = true ]; then
    echo "👁️  Mode surveillance activé (Ctrl+C pour quitter)"
    while true; do
        check_status
        echo ""
        echo "⏳ Prochaine vérification dans 10 secondes..."
        sleep 10
    done
else
    check_status
    echo ""
    echo "💡 Utilise --watch pour surveillance en temps réel"
fi
