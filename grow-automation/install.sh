#!/bin/bash
# ============================================================================
# MAGIC GARDEN - Installation Script
# ============================================================================
# Script d'installation automatique pour Home Assistant sur Raspberry Pi
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${GREEN}"
    echo "============================================================================"
    echo "  🌱 MAGIC GARDEN - Installation"
    echo "  IoT Cannabis Grow Automation pour Home Assistant"
    echo "============================================================================"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}[ÉTAPE]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[ATTENTION]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERREUR]${NC} $1"
}

# Main installation
print_header

# ============================================================================
# STEP 1: Détection du répertoire Home Assistant
# ============================================================================
print_step "Détection du répertoire Home Assistant..."

HA_DIR=""
POSSIBLE_DIRS=(
    "/home/pi/homeassistant"
    "/home/$USER/homeassistant"
    "/config"
    "/usr/share/hassio/homeassistant"
)

for dir in "${POSSIBLE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        if [ -f "$dir/configuration.yaml" ]; then
            HA_DIR="$dir"
            print_success "Home Assistant trouvé: $HA_DIR"
            break
        fi
    fi
done

if [ -z "$HA_DIR" ]; then
    print_warning "Répertoire Home Assistant non trouvé automatiquement"
    read -p "Entrez le chemin complet de votre répertoire Home Assistant: " HA_DIR

    if [ ! -d "$HA_DIR" ] || [ ! -f "$HA_DIR/configuration.yaml" ]; then
        print_error "Répertoire invalide ou configuration.yaml non trouvé!"
        exit 1
    fi
fi

# ============================================================================
# STEP 2: Vérification des permissions
# ============================================================================
print_step "Vérification des permissions..."

if [ ! -w "$HA_DIR/configuration.yaml" ]; then
    print_error "Pas de permission d'écriture sur configuration.yaml"
    print_warning "Essayez: sudo chown -R $USER:$USER $HA_DIR"
    exit 1
fi

print_success "Permissions OK"

# ============================================================================
# STEP 3: Backup de la configuration existante
# ============================================================================
print_step "Backup de la configuration existante..."

BACKUP_DIR="$HA_DIR/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_SUBDIR="$BACKUP_DIR/magic_garden_backup_$TIMESTAMP"

mkdir -p "$BACKUP_SUBDIR"

# Backup configuration.yaml
if [ -f "$HA_DIR/configuration.yaml" ]; then
    cp "$HA_DIR/configuration.yaml" "$BACKUP_SUBDIR/configuration.yaml.backup"
    print_success "Backup configuration.yaml → $BACKUP_SUBDIR"
fi

# Backup automations.yaml
if [ -f "$HA_DIR/automations.yaml" ]; then
    cp "$HA_DIR/automations.yaml" "$BACKUP_SUBDIR/automations.yaml.backup"
    print_success "Backup automations.yaml → $BACKUP_SUBDIR"
fi

# Backup ui-lovelace.yaml (si existe)
if [ -f "$HA_DIR/ui-lovelace.yaml" ]; then
    cp "$HA_DIR/ui-lovelace.yaml" "$BACKUP_SUBDIR/ui-lovelace.yaml.backup"
    print_success "Backup ui-lovelace.yaml → $BACKUP_SUBDIR"
fi

# ============================================================================
# STEP 4: Ajout de la configuration Magic Garden
# ============================================================================
print_step "Ajout de la configuration Magic Garden..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if Magic Garden config already exists
if grep -q "# MAGIC GARDEN" "$HA_DIR/configuration.yaml" 2>/dev/null; then
    print_warning "Configuration Magic Garden déjà présente dans configuration.yaml"
    read -p "Voulez-vous la remplacer? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Installation de configuration.yaml annulée"
    else
        # Remove old Magic Garden config
        sed -i '/# MAGIC GARDEN - START/,/# MAGIC GARDEN - END/d' "$HA_DIR/configuration.yaml"
        print_success "Ancienne configuration supprimée"

        # Add new config
        echo "" >> "$HA_DIR/configuration.yaml"
        echo "# MAGIC GARDEN - START" >> "$HA_DIR/configuration.yaml"
        cat "$SCRIPT_DIR/configuration.yaml" >> "$HA_DIR/configuration.yaml"
        echo "# MAGIC GARDEN - END" >> "$HA_DIR/configuration.yaml"
        print_success "Nouvelle configuration ajoutée"
    fi
else
    echo "" >> "$HA_DIR/configuration.yaml"
    echo "# MAGIC GARDEN - START" >> "$HA_DIR/configuration.yaml"
    cat "$SCRIPT_DIR/configuration.yaml" >> "$HA_DIR/configuration.yaml"
    echo "# MAGIC GARDEN - END" >> "$HA_DIR/configuration.yaml"
    print_success "Configuration ajoutée à configuration.yaml"
fi

# ============================================================================
# STEP 5: Ajout des automations
# ============================================================================
print_step "Ajout des automations Magic Garden..."

if [ ! -f "$HA_DIR/automations.yaml" ]; then
    # Create automations.yaml if doesn't exist
    cat "$SCRIPT_DIR/automations.yaml" > "$HA_DIR/automations.yaml"
    print_success "Fichier automations.yaml créé"
else
    # Check if Magic Garden automations already exist
    if grep -q "# MAGIC GARDEN" "$HA_DIR/automations.yaml" 2>/dev/null; then
        print_warning "Automations Magic Garden déjà présentes"
        read -p "Voulez-vous les remplacer? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_warning "Installation des automations annulée"
        else
            # Remove old automations
            sed -i '/# MAGIC GARDEN - START/,/# MAGIC GARDEN - END/d' "$HA_DIR/automations.yaml"

            # Add new automations
            echo "" >> "$HA_DIR/automations.yaml"
            echo "# MAGIC GARDEN - START" >> "$HA_DIR/automations.yaml"
            cat "$SCRIPT_DIR/automations.yaml" >> "$HA_DIR/automations.yaml"
            echo "# MAGIC GARDEN - END" >> "$HA_DIR/automations.yaml"
            print_success "Automations remplacées"
        fi
    else
        # Append to existing automations
        echo "" >> "$HA_DIR/automations.yaml"
        echo "# MAGIC GARDEN - START" >> "$HA_DIR/automations.yaml"
        cat "$SCRIPT_DIR/automations.yaml" >> "$HA_DIR/automations.yaml"
        echo "# MAGIC GARDEN - END" >> "$HA_DIR/automations.yaml"
        print_success "Automations ajoutées à automations.yaml"
    fi
fi

# ============================================================================
# STEP 6: Copie du dashboard
# ============================================================================
print_step "Copie du dashboard Lovelace..."

DASHBOARDS_DIR="$HA_DIR/dashboards"
mkdir -p "$DASHBOARDS_DIR"

cp "$SCRIPT_DIR/dashboard.yaml" "$DASHBOARDS_DIR/magic_garden_dashboard.yaml"
print_success "Dashboard copié → $DASHBOARDS_DIR/magic_garden_dashboard.yaml"

# ============================================================================
# STEP 7: Validation de la configuration
# ============================================================================
print_step "Validation de la configuration..."

# Check if docker or hass command is available
DOCKER_CONTAINER=""
HAS_DOCKER=false

if command -v docker &> /dev/null; then
    # Find Home Assistant container
    DOCKER_CONTAINER=$(docker ps --filter "name=homeassistant" --filter "name=home-assistant" --format "{{.Names}}" | head -n 1)

    if [ -n "$DOCKER_CONTAINER" ]; then
        HAS_DOCKER=true
        print_success "Container Docker trouvé: $DOCKER_CONTAINER"

        # Validate configuration
        print_step "Validation de la configuration Home Assistant..."
        if docker exec "$DOCKER_CONTAINER" hass --script check_config -c /config 2>&1 | grep -q "successful"; then
            print_success "Configuration valide ✓"
        else
            print_warning "La validation a échoué. Vérifiez les logs ci-dessus."
            read -p "Voulez-vous continuer quand même? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_error "Installation annulée"
                exit 1
            fi
        fi
    fi
fi

if [ "$HAS_DOCKER" = false ]; then
    print_warning "Docker non trouvé ou container Home Assistant non détecté"
    print_warning "Validation automatique impossible"
fi

# ============================================================================
# STEP 8: Redémarrage de Home Assistant
# ============================================================================
print_step "Redémarrage de Home Assistant..."

if [ "$HAS_DOCKER" = true ] && [ -n "$DOCKER_CONTAINER" ]; then
    read -p "Voulez-vous redémarrer Home Assistant maintenant? (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        docker restart "$DOCKER_CONTAINER"
        print_success "Home Assistant redémarré"
        print_warning "Attendez 30-60 secondes que Home Assistant redémarre..."
    else
        print_warning "N'oubliez pas de redémarrer Home Assistant manuellement!"
    fi
else
    print_warning "Redémarrez Home Assistant manuellement pour appliquer les changements:"
    echo "  - Via l'interface: Configuration > Serveur > Redémarrer"
    echo "  - Ou: docker restart <container_name>"
fi

# ============================================================================
# STEP 9: Instructions post-installation
# ============================================================================
echo ""
print_header
echo -e "${GREEN}✓ Installation terminée avec succès!${NC}"
echo ""
echo -e "${BLUE}📋 PROCHAINES ÉTAPES:${NC}"
echo ""
echo "1. 🔄 Attendez que Home Assistant redémarre (30-60 secondes)"
echo ""
echo "2. 🎨 Ajoutez le dashboard Magic Garden:"
echo "   - Allez dans Configuration > Dashboards"
echo "   - Cliquez sur '+ Ajouter un dashboard'"
echo "   - Nom: 'Magic Garden 🌱'"
echo "   - Cliquez sur les 3 points > 'Modifier en YAML'"
echo "   - Copiez le contenu de: $DASHBOARDS_DIR/magic_garden_dashboard.yaml"
echo "   - Sauvegardez"
echo ""
echo "3. 🔧 Configurez vos entités Zigbee/WiFi:"
echo "   Assurez-vous que ces entités existent:"
echo "   - sensor.capteur_4en1_temperature"
echo "   - sensor.capteur_4en1_humidite_air"
echo "   - sensor.capteur_4en1_humidite_sol"
echo "   - sensor.capteur_4en1_luminosite"
echo "   - switch.smart_drip_irrigation"
echo "   - binary_sensor.smart_drip_alarme_eau"
echo "   - binary_sensor.smart_drip_alarme_obstruction"
echo "   - switch.prise_mars_hydro"
echo "   - switch.prise_extraction"
echo ""
echo "   Si les noms sont différents, renommez-les dans:"
echo "   Configuration > Entités > [cliquez sur l'entité] > ID d'entité"
echo ""
echo "4. ⚙️ Configurez vos paramètres de culture:"
echo "   - Allez dans le dashboard Magic Garden"
echo "   - Onglet 'Configuration'"
echo "   - Ajustez les seuils si nécessaire"
echo "   - Vérifiez la date de germination (30 nov 2024)"
echo "   - Sélectionnez la phase actuelle (Plantule)"
echo ""
echo "5. 🌱 Activez l'arrosage automatique:"
echo "   - Onglet 'Arrosage'"
echo "   - Activez 'Arrosage automatique'"
echo ""
echo -e "${YELLOW}📁 Backup de votre ancienne config:${NC}"
echo "   $BACKUP_SUBDIR"
echo ""
echo -e "${YELLOW}📖 Documentation complète:${NC}"
echo "   Consultez le README.md pour plus d'informations"
echo ""
echo -e "${GREEN}Bonne culture! 🌱${NC}"
echo ""
