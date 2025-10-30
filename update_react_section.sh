#!/bin/bash

# Script pour mettre à jour la section React dans index.html

cd /home/akdev/GIT_SHARE/souljax_dev_tools

# Créer une sauvegarde
cp index.html index_backup_$(date +%Y%m%d_%H%M%S).html

# Remplacer seulement la section React (lignes ~379-425)
cat > temp_react_section.html << 'EOF'
            <div class="framework-card">
                <div class="framework-header">
                    <div class="framework-icon">
                        <img src="./assets/logos/react.png" alt="React">
                    </div>
                    <div>
                        <h2>React</h2>
                        <span class="status available">Available</span>
                    </div>
                </div>
                
                <div class="packages-list">
                    <h4>📦 Available Packages:</h4>
                    <div class="package-item">
                        <div class="package-header">
                            <span class="package-name">bouncing-tech-logos</span>
                            <span class="package-status">✅ Enhanced</span>
                        </div>
                        <div class="package-description">
                            Enhanced React version with 30% performance boost, TypeScript support, and energy-boosting physics.
                        </div>
                        <div class="package-buttons">
                            <a href="ReactJS/bouncing-tech-logos/" class="mini-btn mini-demo-btn">
                                🚀 Demo
                            </a>
                            <a href="https://github.com/souljax/souljax_dev_tools/tree/main/ReactJS/bouncing-tech-logos" class="mini-btn mini-source-btn">
                                📂 Source
                            </a>
                        </div>
                    </div>
                </div>
            </div>
EOF

# Créer le nouveau fichier en remplaçant la section React
awk '
    /framework-card coming-soon-card/ && /React/ { 
        in_react_section = 1
        # Insérer la nouvelle section React
        while ((getline line < "temp_react_section.html") > 0) {
            print line
        }
        close("temp_react_section.html")
        next
    }
    in_react_section && /<\/div>/ && depth == 0 {
        in_react_section = 0
        next
    }
    in_react_section {
        # Compter les divs pour savoir quand finir
        depth += gsub(/<div/, "")
        depth -= gsub(/<\/div>/, "")
        next
    }
    { print }
' index.html > index_new.html

# Vérifier si le remplacement a fonctionné
if [ -s index_new.html ]; then
    mv index_new.html index.html
    echo "✅ Section React mise à jour avec succès!"
else
    echo "❌ Erreur lors du remplacement"
    exit 1
fi

# Nettoyer
rm -f temp_react_section.html

echo "🎉 Page GitHub Pages mise à jour!"
echo "📍 La section React est maintenant active avec le package bouncing-tech-logos"