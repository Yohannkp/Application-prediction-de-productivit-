# Application de Prédiction de Productivité d'une équipe

Ce projet est une solution complète pour le suivi et la prédiction de la productivité personnelle, combinant une application Flutter multi-plateforme (mobile, web, desktop) et un workspace avancé de Machine Learning.

## Fonctionnalités principales

### 1. Application Flutter
- **Suivi de la productivité** : Interface moderne pour saisir, visualiser et suivre ses activités et indicateurs de productivité.
- **Multi-plateforme** : Fonctionne sur Android, iOS, Web, Windows, Linux, macOS.
- **Navigation intuitive** : UI pastel, navigation à onglets, multi-écrans.
- **Visualisations** : Graphiques, historiques, statistiques personnalisées.
- **Intégration du modèle ML** : Prédiction en temps réel de la productivité à partir des données saisies.

### 2. Workspace Machine Learning
- **Exploration et visualisation des données** : Notebooks pour l’analyse exploratoire, visualisations thématiques (histogrammes, heatmaps, etc.).
- **Nettoyage et Feature Engineering** : Imputation, gestion des outliers, création et sélection automatique de variables.
- **Modélisation avancée** : Implémentation et optimisation de modèles (Régression Linéaire, Random Forest, XGBoost).
- **Évaluation et interprétation** : Analyse des performances (MAE, RMSE, R²), importance des variables, interprétation métier.
- **Automatisation** : Scripts pour pipeline ML, possibilité d’intégrer MLflow ou d’autres outils.
- **Déploiement** : Modèle exporté et intégré dans l’application Flutter pour une utilisation directe.

## Structure du projet

- `application/` : Code source Flutter (mobile/web/desktop)
- `API/` : API Python pour servir le modèle ML (optionnel)
- `ML/` ou `Machine Learning/` : Workspace de data science (notebooks, scripts, modèles, données)
- `data/` : Jeux de données bruts et traités
- `model/` : Modèles entraînés (ex : `xgb_top10.pkl`)
- `notebooks/` : Analyses et modélisation (Jupyter)
- `scripts/` : Scripts Python pour le traitement et l’automatisation

## Installation rapide

### Application Flutter
1. Cloner le dépôt et ouvrir le dossier `application/`
2. Installer les dépendances :  
   ```sh
   flutter pub get