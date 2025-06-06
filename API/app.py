from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import numpy as np
import pickle
import os
import pandas as pd
import uvicorn

# Charger le modèle XGBoost entraîné (top 10 vars)
MODEL_PATH = os.path.join(os.path.dirname(__file__), 'model/xgb_top10.pkl')
with open(MODEL_PATH, 'rb') as f:
    model = pickle.load(f)

# Liste des 10 variables attendues (dans le même ordre que lors de l'entraînement)
TOP10_VARS = [
    'targeted_productivity',
    'incentive',
    'wip',
    'team',
    'smv',
    'month',
    'department_sweing_0.0',
    'department_sweing_1.0',
    'quarter_Quarter1',
    'no_of_workers'
]

app = FastAPI(title="API de Prédiction de Productivité (XGBoost)")

class PredictionRequest(BaseModel):
    targeted_productivity: float
    incentive: float
    wip: float
    team: float
    smv: float
    month: float
    department_sweing_0_0: float
    department_sweing_1_0: float
    quarter_Quarter1: float
    no_of_workers: float

@app.post("/predict")
def predict_productivity(data: PredictionRequest):
    try:
        # Adapter les noms pour matcher les colonnes du modèle
        input_dict = data.dict()
        # Correction des noms pour les colonnes avec des points
        input_dict['department_sweing_0.0'] = input_dict.pop('department_sweing_0_0')
        input_dict['department_sweing_1.0'] = input_dict.pop('department_sweing_1_0')
        X = pd.DataFrame([input_dict])[TOP10_VARS]
        # Prédiction
        y_pred = model.predict(X)[0]
        return {"predicted_actual_productivity": float(y_pred)}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/")
def root():
    return {"message": "API de prédiction de productivité (XGBoost top 10 vars) opérationnelle."}




if __name__ == "__main__":
    port = os.getenv("PORT", 8000)  # Utilise la variable d'environnement PORT ou 8000 par défaut
    uvicorn.run("app:app", host="0.0.0.0", port=int(port), reload=True)

