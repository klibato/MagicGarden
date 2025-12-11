# 🌱 Magic Garden - IoT Cannabis Grow Automation

Système d'automatisation IoT complet pour culture de cannabis indoor avec Home Assistant sur Raspberry Pi.

![Version](https://img.shields.io/badge/version-1.0.0-green)
![Home Assistant](https://img.shields.io/badge/Home%20Assistant-2024.1+-blue)
![Platform](https://img.shields.io/badge/platform-Raspberry%20Pi-red)

## 📋 Table des matières

- [Vue d'ensemble](#vue-densemble)
- [Fonctionnalités](#fonctionnalités)
- [Matériel requis](#matériel-requis)
- [Installation](#installation)
- [Configuration](#configuration)
- [Utilisation](#utilisation)
- [Automatisations](#automatisations)
- [Dashboard](#dashboard)
- [Dépannage](#dépannage)
- [FAQ](#faq)
- [Licence](#licence)

## 🎯 Vue d'ensemble

Magic Garden est un système d'automatisation complet pour la culture de cannabis indoor qui :

- **Monitore** en temps réel température, humidité air/sol, luminosité
- **Automatise** l'arrosage selon la phase de culture
- **Alerte** en cas de conditions non optimales
- **Optimise** les conditions de croissance (VPD, température, humidité)
- **Documente** tout le processus avec historiques et rapports

### 🌿 Plante de référence

Ce système a été conçu pour **Watermelon Automatic** de Royal Queen Seeds :
- **Génétique:** Tropicanna Cookies x Lemon OG
- **Type:** 75% Indica / 20% Sativa / 5% Ruderalis
- **Cycle total:** 10-12 semaines
- **Rendement:** 50-80g/plante (indoor)
- **THC:** 20%

## ✨ Fonctionnalités

### 🔄 Arrosage automatique intelligent

- **Arrosage adaptatif** : Seuils et durées ajustés automatiquement selon la phase
- **Sécurité intégrée** : Détection réservoir vide et obstruction goutteurs
- **Volume calculé** : Estimation précise du volume d'eau distribué
- **Historique complet** : Compteur d'arrosages et logs détaillés

### 📊 Monitoring environnemental

- **Température** : Surveillance 24/7 avec alertes min/max
- **Humidité air** : Alerte critique en floraison (risque moisissure)
- **Humidité sol** : Mesure continue avec détection stress hydrique
- **Luminosité** : Vérification intensité lumineuse
- **VPD** : Calcul automatique du Vapor Pressure Deficit

### 🧪 Gestion des engrais

- **Recettes automatiques** : Mises à jour selon phase et semaine
- **BioBizz optimisé** : Root Juice, Bio Grow, Bio Bloom
- **pH rappelé** : Toujours 6.5 pour absorption optimale
- **Rinçage automatique** : Passage en eau claire en fin de cycle

### 🚨 Alertes intelligentes

- ⚠️ Température élevée (>30°C pendant 10min)
- ❄️ Température basse (<16°C pendant 30min)
- 💧 Humidité air élevée (>60% pendant 30min) - **CRITIQUE EN FLORAISON**
- 🏜️ Sol trop sec (<20% pendant 2h)
- 💡 Lumière faible (lampe ON mais peu de lux)
- 🚫 Réservoir vide
- 🔧 Goutteurs bouchés
- 🌫️ VPD non optimal

### 📈 Rapports et historiques

- **Rapport quotidien** : Synthèse à 20h chaque jour
- **Graphiques temps réel** : 24h à 7 jours d'historique
- **Suggestions de phase** : Recommandations basées sur l'âge de la plante
- **Guide intégré** : Documentation complète accessible dans le dashboard

## 🛠️ Matériel requis

### Contrôleur

- **Raspberry Pi 3/4** (recommandé : Pi 4 avec 2GB+ RAM)
- Carte SD 32GB+ (classe 10)
- Alimentation officielle Raspberry Pi

### Capteurs et actionneurs

| Équipement | Type | Fonction | Statut |
|------------|------|----------|--------|
| **Capteur 4-en-1** | Zigbee | Temp + Humid air + Humid sol + Luminosité | Obligatoire |
| **Smart Drip** | WiFi (Tuya) | Pompe irrigation 4 goutteurs | Obligatoire |
| **Prise Zigbee #1** | Zigbee | Contrôle Mars Hydro TS-1000 | Obligatoire |
| **Prise Zigbee #2** | Zigbee | Contrôle extracteur + filtre charbon | Obligatoire |
| **Dongle Zigbee** | USB | Coordinateur Zigbee (Sonoff, ConBee II, etc.) | Obligatoire |

### Équipement de culture

- **Tente** : 60x60x180 cm
- **Lampe** : Mars Hydro TS-1000 (100W LED)
- **Extraction** : Extracteur + filtre charbon 125mm 400m³/h
- **Pot** : Air Pot 12L
- **Substrat** : Light Mix BioBizz
- **Engrais** : Root Juice + Bio Grow + Bio Bloom (BioBizz)
- **pH** : Testeur + pH Down (cible : 6.5)

## 📥 Installation

### Prérequis

1. **Home Assistant installé** sur Raspberry Pi (via Docker)
2. **Zigbee configuré** (Zigbee2MQTT ou ZHA)
3. **Intégration Tuya** configurée pour Smart Drip
4. **Accès SSH** au Raspberry Pi

### Installation automatique

```bash
# 1. Cloner le repository
git clone https://github.com/klibato/MagicGarden.git
cd MagicGarden/grow-automation

# 2. Rendre le script exécutable
chmod +x install.sh

# 3. Lancer l'installation
./install.sh
```

Le script va :
- ✅ Détecter automatiquement votre installation Home Assistant
- ✅ Créer un backup de votre configuration existante
- ✅ Ajouter la configuration Magic Garden (sans écraser l'existant)
- ✅ Ajouter les automations
- ✅ Copier le dashboard
- ✅ Valider la configuration
- ✅ Redémarrer Home Assistant

### Installation manuelle

Si vous préférez installer manuellement :

```bash
# 1. Backup de votre config
cp /home/pi/homeassistant/configuration.yaml /home/pi/homeassistant/configuration.yaml.backup
cp /home/pi/homeassistant/automations.yaml /home/pi/homeassistant/automations.yaml.backup

# 2. Ajouter la config à la fin de configuration.yaml
cat configuration.yaml >> /home/pi/homeassistant/configuration.yaml

# 3. Ajouter les automations à la fin de automations.yaml
cat automations.yaml >> /home/pi/homeassistant/automations.yaml

# 4. Copier le dashboard
mkdir -p /home/pi/homeassistant/dashboards
cp dashboard.yaml /home/pi/homeassistant/dashboards/magic_garden_dashboard.yaml

# 5. Redémarrer Home Assistant
docker restart homeassistant
```

## ⚙️ Configuration

### 1. Renommer les entités

Les entités de vos capteurs doivent correspondre aux noms attendus. Allez dans **Configuration > Entités** et renommez :

**Capteur 4-en-1 Zigbee :**
- `sensor.xxx_temperature` → `sensor.capteur_4en1_temperature`
- `sensor.xxx_humidity` → `sensor.capteur_4en1_humidite_air`
- `sensor.xxx_soil_moisture` → `sensor.capteur_4en1_humidite_sol`
- `sensor.xxx_illuminance` → `sensor.capteur_4en1_luminosite`

**Smart Drip (Tuya) :**
- `switch.xxx_irrigation` → `switch.smart_drip_irrigation`
- `binary_sensor.xxx_water_alarm` → `binary_sensor.smart_drip_alarme_eau`
- `binary_sensor.xxx_clog_alarm` → `binary_sensor.smart_drip_alarme_obstruction`

**Prises Zigbee :**
- `switch.xxx_mars_hydro` → `switch.prise_mars_hydro`
- `switch.xxx_extraction` → `switch.prise_extraction`

### 2. Configurer les paramètres de culture

Allez dans le dashboard **Magic Garden** > onglet **Configuration** :

1. **Date de germination** : 30 novembre 2024 (ajustez si différent)
2. **Phase actuelle** : Plantule (jour 11)
3. **Seuils température** : Min 16°C / Max 30°C
4. **Seuil humidité air max** : 60%
5. **Seuil humidité sol critique** : 20%

Les seuils d'arrosage par phase sont déjà pré-configurés selon le guide :
- Germination : 75%
- Plantule : 70%
- Végétation : 50%
- Floraison : 40%
- Rinçage : 55%

### 3. Ajouter le dashboard

1. Allez dans **Configuration > Dashboards**
2. Cliquez sur **+ Ajouter un dashboard**
3. Nom : `Magic Garden 🌱`
4. Cliquez sur les **3 points** > **Modifier en YAML**
5. Copiez tout le contenu de `dashboards/magic_garden_dashboard.yaml`
6. Collez et **sauvegardez**

### 4. Calibrer les goutteurs

Pour calculer le débit précis de vos goutteurs :

```bash
# 1. Mettez un récipient gradué sous chaque goutteur
# 2. Activez la pompe manuellement pendant 60 secondes
# 3. Mesurez le volume total des 4 goutteurs
# 4. Volume total / 4 = débit par goutteur/min

# Exemple : 400ml en 60s pour 4 goutteurs = 100ml/min par goutteur
```

Ajustez ensuite dans **Configuration** > `Débit goutteurs`.

## 🚀 Utilisation

### Dashboard - Vue Monitoring

![Monitoring](https://via.placeholder.com/800x400?text=Screenshot+Monitoring)

- **Conditions temps réel** : Température, humidité, luminosité, VPD
- **Graphiques 24h-7j** : Évolution de tous les paramètres
- **État de santé** : Indicateur global basé sur tous les capteurs
- **Plages optimales** : Documentation des valeurs cibles par phase

### Dashboard - Vue Arrosage

![Arrosage](https://via.placeholder.com/800x400?text=Screenshot+Arrosage)

- **Configuration** : Phase, seuils, durées
- **Statistiques** : Nombre d'arrosages, besoin actuel
- **Contrôle manuel** : Override de l'arrosage automatique
- **Recette engrais** : Mise à jour automatique selon phase
- **Historique** : Graphique des arrosages sur 7 jours

### Dashboard - Vue Équipements

![Équipements](https://via.placeholder.com/800x400?text=Screenshot+Equipements)

- **Contrôles** : Mars Hydro, extracteur, Smart Drip
- **Capteurs** : État temps réel de tous les capteurs
- **Alarmes** : Smart Drip (réservoir, obstruction)
- **Historique** : Graphique ON/OFF des équipements

### Dashboard - Vue Configuration

Tous les paramètres éditables :
- Seuils température (min/max)
- Seuil humidité air max
- Seuils humidité sol par phase
- Durées arrosage par phase
- Débit goutteurs
- Activation arrosage auto / alertes

### Dashboard - Vue Guide

Documentation complète de culture intégrée au dashboard :
- Informations génétiques
- Phases détaillées (germination → récolte)
- Tableau engrais récapitulatif
- Guide séchage et affinage
- Erreurs à éviter
- Conseils pro

## 🤖 Automatisations

### Arrosage

| Automation | Déclencheur | Condition | Action |
|------------|-------------|-----------|--------|
| **Arrosage automatique** | Humidité sol < seuil (5min) | Auto ON + Pompe OFF + Réservoir OK | Arrose selon durée active |
| **Sécurité arrosage** | Auto désactivé manuellement | Pompe ON | Coupe la pompe |

### Engrais

| Automation | Déclencheur | Action |
|------------|-------------|--------|
| **MAJ recette engrais** | Changement de phase | Met à jour la recette BioBizz |

### Alertes environnement

| Automation | Déclencheur | Seuil | Durée |
|------------|-------------|-------|-------|
| **Température élevée** | Temp > max | 30°C | 10min |
| **Température basse** | Temp < min | 16°C | 30min |
| **Humidité air élevée** | Humid > max | 60% | 30min |
| **Humidité sol critique** | Humid sol < crit | 20% | 2h |
| **VPD non optimal** | VPD hors plage | 0.4-1.5 kPa | 2h |

### Alertes équipement

| Automation | Déclencheur | Action |
|------------|-------------|--------|
| **Réservoir vide** | Alarme eau ON | Coupe pompe + désactive auto |
| **Goutteurs bouchés** | Alarme obstruction ON | Coupe pompe + désactive auto |
| **Lumière faible** | Lux < 10000 (lampe ON) | Alerte vérification Mars Hydro |

### Rapports

| Automation | Déclencheur | Contenu |
|------------|-------------|---------|
| **Rapport quotidien** | 20h00 | Stats du jour + conditions + santé |

### Suggestions de phase

| Automation | Déclencheur | Suggestion |
|------------|-------------|------------|
| **Passage végétation** | Semaine > 1 (si plantule) | Passe en végé si 10cm + vraies feuilles |
| **Passage floraison** | Semaine > 3 (si végé) | Passe en flo si pistils + 20-30cm |
| **Passage rinçage** | Semaine > 8 (si flo) | Vérifie trichomes (70% laiteux) |

## 📊 Dashboard

Le dashboard Magic Garden est divisé en 5 vues :

### 1. 📊 Monitoring

**Cartes :**
- En-tête avec jour/semaine/phase/santé
- Conditions en temps réel (tous capteurs)
- Graphique température 24h + plages optimales
- Graphique humidité air 24h + plages optimales
- Graphique humidité sol 7j + seuil actif
- Graphique luminosité 24h
- Graphique VPD 24h + plages optimales

### 2. 💧 Arrosage

**Cartes :**
- Configuration arrosage (phase, date, seuils, durées)
- Statistiques arrosage (compteur, besoin, humidité)
- Contrôle manuel Smart Drip
- Seuils humidité par phase (5 sliders)
- Durées arrosage par phase (5 sliders)
- Recette engrais active (markdown)
- Historique arrosages 7j

### 3. 🔌 Équipements

**Cartes :**
- Contrôle équipements (Mars Hydro, extraction, Smart Drip)
- État capteurs (4-en-1)
- Alarmes Smart Drip
- Historique équipements 24h
- Info réglages Mars Hydro (hauteur par phase)

### 4. ⚙️ Configuration

**Cartes :**
- Phase de culture (sélecteur + date + jour/semaine)
- Seuils température (min/max + actuelle)
- Seuils humidité air (max + actuelle)
- Seuils humidité sol (5 phases + critique + actif + actuelle)
- Durées arrosage (5 phases + débit + active + volume)
- Activation fonctionnalités (auto arrosage, alertes)
- Compteurs (reset possible)

### 5. 📚 Guide

**Contenu :**
- Informations génétiques complètes
- Phase 1 : Semis (détaillée)
- Phase 2 : Plantule (détaillée)
- Phase 3 : Végétation (détaillée)
- Phase 4 : Floraison (détaillée)
- Phase 5 : Rinçage (détaillée)
- Récolte (observation trichomes)
- Séchage (10-14 jours)
- Affinage / Curing (2-8 semaines)
- Erreurs à éviter (tableau)
- Conseils pro
- Tableau engrais récapitulatif

## 🔧 Dépannage

### L'arrosage automatique ne se déclenche pas

**Causes possibles :**

1. **Arrosage auto désactivé**
   - Vérifiez : Dashboard > Arrosage > "Arrosage automatique" = ON

2. **Humidité sol au-dessus du seuil**
   - Vérifiez : Dashboard > Arrosage > Comparer "Humidité sol actuelle" vs "Seuil actif"

3. **Alarme réservoir vide ou obstruction**
   - Vérifiez : Dashboard > Équipements > Alarmes Smart Drip
   - Solution : Remplir réservoir ou déboucher goutteurs, puis réactiver arrosage auto

4. **Durée d'arrosage = 0**
   - Vérifiez : Dashboard > Arrosage > "Durée active"
   - Solution : Configuration > Durées arrosage > Ajustez selon phase

5. **Pompe déjà en cours**
   - L'automation ne se déclenche que si pompe OFF
   - Attendez la fin du cycle en cours

### Les capteurs n'affichent rien

**Causes possibles :**

1. **Entités mal nommées**
   - Vérifiez : Configuration > Entités > Recherchez vos capteurs
   - Solution : Renommez selon [Configuration](#configuration)

2. **Capteur hors ligne**
   - Vérifiez : Zigbee2MQTT ou ZHA > État du capteur
   - Solution : Vérifiez batterie, distance au coordinateur

3. **Intégration non configurée**
   - Tuya : Configuration > Intégrations > Tuya Cloud
   - Zigbee : Configuration > Intégrations > Zigbee2MQTT ou ZHA

### Les alertes ne s'affichent pas

**Causes possibles :**

1. **Alertes désactivées**
   - Vérifiez : Dashboard > Configuration > "Alertes activées" = ON

2. **Seuil pas encore atteint**
   - Les alertes ont des délais (10min, 30min, 2h selon le type)
   - Vérifiez les graphiques pour voir si le seuil est réellement dépassé

3. **Notifications désactivées dans HA**
   - Configuration > Notifications > Vérifiez les paramètres

### Le dashboard est vide

**Causes possibles :**

1. **Mauvais import YAML**
   - Vérifiez : Dashboard > 3 points > Modifier en YAML
   - Solution : Recopiez tout le contenu de `dashboard.yaml`

2. **Erreur de syntaxe YAML**
   - Vérifiez : Logs Home Assistant pour erreurs Lovelace
   - Solution : Validez le YAML avec un validateur en ligne

### VPD affiche 0

**Causes possibles :**

1. **Capteurs température ou humidité à 0**
   - Vérifiez : Dashboard > Monitoring > Conditions temps réel
   - Solution : Vérifiez connexion capteur 4-en-1

2. **Formule de calcul**
   - Le VPD nécessite temp > 0 et humidité > 0
   - Attendez que les capteurs envoient des valeurs

## ❓ FAQ

### Puis-je utiliser ce système avec d'autres plantes ?

Oui ! Ajustez simplement :
- Les seuils d'humidité sol
- Les durées d'arrosage
- Les seuils de température
- La recette d'engrais

### Puis-je utiliser d'autres capteurs ?

Oui, tant que vous renommez les entités pour correspondre aux noms attendus.

### Puis-je utiliser Home Assistant sur autre chose qu'un Raspberry Pi ?

Oui, le système fonctionne sur n'importe quelle installation Home Assistant (Docker, VM, Home Assistant OS).

### Combien de plantes puis-je gérer ?

Le système actuel est conçu pour **1 plante**. Pour plusieurs plantes :
- Dupliquez la configuration
- Ajoutez des suffixes (`_plante1`, `_plante2`)
- Créez des dashboards séparés

### Le système fonctionne-t-il hors ligne ?

Oui, tout est local sauf :
- Intégration Tuya Cloud (Smart Drip) - nécessite internet
- Notifications mobiles (si configurées)

Pour un système 100% local, remplacez le Smart Drip par une pompe contrôlée via Zigbee/Z-Wave.

### Comment désinstaller ?

```bash
# Restaurer le backup
cp /home/pi/homeassistant/backups/magic_garden_backup_XXXXXXXX/configuration.yaml.backup /home/pi/homeassistant/configuration.yaml
cp /home/pi/homeassistant/backups/magic_garden_backup_XXXXXXXX/automations.yaml.backup /home/pi/homeassistant/automations.yaml

# Redémarrer Home Assistant
docker restart homeassistant

# Supprimer le dashboard manuellement
# Configuration > Dashboards > Magic Garden > Supprimer
```

### Puis-je modifier les recettes d'engrais ?

Oui ! Modifiez l'automation `update_fertilizer_recipe` dans `automations.yaml` :

```yaml
- service: input_text.set_value
  target:
    entity_id: input_text.fertilizer_recipe
  data:
    value: >
      {% if phase == 'Végétation' %}
        Votre recette personnalisée
      {% endif %}
```

### Le système gère-t-il le cycle jour/nuit de la lampe ?

Non, pas dans cette version. Vous pouvez :
1. Programmer la prise Mars Hydro dans l'app Zigbee
2. Ajouter une automation temporelle dans Home Assistant

Exemple automation 18/6h :

```yaml
- alias: "Mars Hydro - Cycle 18/6"
  trigger:
    - platform: time
      at: "08:00:00"
  action:
    - service: switch.turn_on
      entity_id: switch.prise_mars_hydro

- alias: "Mars Hydro - OFF"
  trigger:
    - platform: time
      at: "02:00:00"
  action:
    - service: switch.turn_off
      entity_id: switch.prise_mars_hydro
```

### Combien consomme le système en électricité ?

**Consommation approximative :**
- Mars Hydro TS-1000 : 100W × 18h = 1.8 kWh/jour
- Extracteur : 50W × 24h = 1.2 kWh/jour
- Raspberry Pi : 5W × 24h = 0.12 kWh/jour
- Smart Drip : 10W × 1h = 0.01 kWh/jour

**Total : ~3.13 kWh/jour = 94 kWh/mois**

À 0.20€/kWh = ~19€/mois d'électricité

### Le capteur d'humidité sol est-il fiable ?

Les capteurs capacitifs (comme dans le 4-en-1 Zigbee) sont plus fiables que les résistifs, mais :
- Calibrez selon votre substrat
- Vérifiez toujours visuellement (soulever le pot)
- Ajustez les seuils si besoin

### Que faire si la pompe Smart Drip ne s'arrête pas ?

**Action immédiate :**
1. Coupez l'alimentation de la pompe
2. Désactivez `input_boolean.auto_watering_enabled`
3. Vérifiez l'automation `auto_watering_trigger`

**Prévention :**
- L'automation a un timer basé sur `sensor.duree_arrosage_active`
- Vérifiez que cette entité renvoie une valeur correcte

### Puis-je recevoir les alertes sur mon téléphone ?

Oui ! Configurez les notifications mobiles dans Home Assistant :

1. Installez l'app Home Assistant sur votre téléphone
2. Configuration > Companion App > Notifications
3. Modifiez les automations pour utiliser `notify.mobile_app_XXXX` au lieu de `notify.persistent_notification`

Exemple :

```yaml
action:
  - service: notify.mobile_app_mon_telephone
    data:
      title: "Alerte température"
      message: "Température élevée!"
```

## 📄 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🙏 Remerciements

- **Home Assistant** pour la plateforme domotique
- **BioBizz** pour les engrais organiques
- **Royal Queen Seeds** pour la génétique Watermelon Automatic
- **Zigbee2MQTT** / **ZHA** pour l'intégration Zigbee
- La communauté **r/microgrowery** pour les connaissances partagées

## 📞 Support

Pour toute question ou problème :

1. Consultez la section [Dépannage](#dépannage)
2. Consultez la [FAQ](#faq)
3. Ouvrez une issue sur GitHub
4. Rejoignez le Discord Home Assistant

---

**Bonne culture! 🌱**

*Rappel : Vérifiez la législation de votre pays concernant la culture de cannabis. Ce système est destiné à un usage légal uniquement.*
