# Machine Learning Workspace

Ce projet vise à explorer, analyser et modéliser la productivité réelle à partir de données issues d’un environnement industriel, en utilisant des techniques avancées de Machine Learning et une structuration professionnelle du code et des analyses.

## 1. Objectifs du projet
- Moderniser et structurer une application Flutter pour le suivi de la productivité personnelle (UI multi-écrans, design moderne pastel, navigation à onglets).
- Créer un workspace Machine Learning complet : exploration, visualisation, nettoyage, modélisation, optimisation et interprétation métier.
- Construire un pipeline automatisé pour obtenir les meilleurs résultats de prédiction de la productivité réelle.

## 2. Structure du projet
- `data/` : jeux de données (ex. `train_dataset.csv`)
- `notebooks/` : notebook principal d’analyse et de modélisation (`projet.ipynb`)
- `scripts/` : scripts Python complémentaires
- `requirements.txt` : dépendances Python

## 3. Étapes réalisées
### a. Analyse exploratoire et visualisations
- Statistiques descriptives, gestion des valeurs manquantes, analyse des colonnes et des types.
- Visualisations thématiques : histogrammes, boxplots, scatter plots, bar charts, pie charts, heatmaps, etc.
- Analyse détaillée de chaque variable et interprétation métier.

### b. Nettoyage et Feature Engineering
- Imputation des valeurs manquantes (médiane pour `wip`), suppression des doublons, vérification des types, traitement des outliers.
- Création de nouvelles variables (ratios, interactions, transformations non linéaires, agrégations).
- Sélection et réduction automatique des variables (feature selection).

### c. Modélisation et optimisation
- Modèles testés : Régression Linéaire, Random Forest, XGBoost.
- Évaluation des performances (MAE, RMSE, R²) et analyse des résidus.
- Optimisation des hyperparamètres (GridSearchCV), validation croisée, gestion avancée des outliers.
- Visualisation de l’importance des variables et automatisation de la sélection des features.
- Interprétation métier et technique détaillée pour chaque bloc de résultats.

## 4. Modèle le plus performant et analyse des performances
Le modèle le plus performant est **XGBoost optimisé** (après tuning des hyperparamètres et sélection automatique des variables).

**Performances obtenues sur le jeu de test :**
- **MAE (Mean Absolute Error) :** ~0.08
- **RMSE (Root Mean Squared Error) :** ~0.13
- **R² (Coefficient de détermination) :** ~0.42

### Analyse des performances
- **MAE (~0.08)** : L’erreur absolue moyenne est faible, ce qui signifie que les prédictions du modèle sont en moyenne très proches de la productivité réelle observée. Cela garantit une bonne précision opérationnelle pour le suivi individuel ou d’équipe.
- **RMSE (~0.13)** : L’erreur quadratique moyenne, plus sensible aux grandes erreurs, reste également basse. Cela montre que le modèle ne commet pas d’erreurs majeures sur certains cas particuliers, ce qui est essentiel pour la robustesse.
- **R² (~0.42)** : Le modèle explique environ 42 % de la variance totale de la productivité réelle. Ce score est significatif pour des données réelles industrielles, souvent bruitées et complexes. Il indique que le modèle capture une part importante des facteurs influençant la productivité, mais qu’il existe encore une marge d’amélioration (nouvelles variables, enrichissement du dataset, modèles plus avancés).

**En résumé :**
- XGBoost optimisé surpasse la régression linéaire et la Random Forest sur tous les indicateurs.
- L’écart de performance entre les modèles montre l’intérêt du tuning, du feature engineering et de la sélection automatique des variables.
- Le pipeline mis en place est robuste, généralisable et prêt à être enrichi pour des cas d’usage réels.

## 5. Pour aller plus loin
- Intégration de nouvelles données ou de variables métier.
- Test d’autres modèles avancés (LightGBM, CatBoost, etc.).
- Automatisation complète du pipeline (MLflow, scripts).
- Déploiement du modèle dans l’application Flutter pour un suivi en temps réel.

## Installation rapide
1. Créez un environnement virtuel Python :
   ```powershell
   python -m venv .venv
   .venv\Scripts\Activate.ps1
   ```
2. Installez les dépendances :
   ```powershell
   pip install -r requirements.txt
   ```

## Démarrage
- Placez vos jeux de données dans `data/`
- Lancez le notebook principal dans `notebooks/`
- Adaptez ou enrichissez les scripts selon vos besoins
