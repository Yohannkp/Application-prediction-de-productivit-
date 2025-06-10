import 'package:flutter/material.dart';

class PredictionResultsPage extends StatelessWidget {
  final double? predictedProductivity;
  final double targetedProductivity;
  final Map<String, dynamic> inputData;
  final VoidCallback onRecalculate;
  final VoidCallback onSeeHistory;
  final String? recommendation;

  const PredictionResultsPage({
    super.key,
    required this.predictedProductivity,
    required this.targetedProductivity,
    required this.inputData,
    required this.onRecalculate,
    required this.onSeeHistory,
    this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultat de la prédiction'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF8B5CF6),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Votre productivité prédite', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (predictedProductivity != null)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${(predictedProductivity! * 100).toStringAsFixed(1)}%', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                              Text('Objectif : ${(targetedProductivity * 100).toStringAsFixed(1)}%', style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Icon(
                              predictedProductivity! >= targetedProductivity ? Icons.emoji_events : Icons.trending_up,
                              color: predictedProductivity! >= targetedProductivity ? Colors.green : Colors.orange,
                              size: 36,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Résumé des données utilisées :', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6), fontSize: 17)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Productivité cible : ${inputData['targeted_productivity']}'),
                    Text('Incentive financier : ${inputData['incentive']}'),
                    Text('Tâches/projets en cours : ${inputData['wip']}'),
                    Text('Équipe : ${inputData['team']}'),
                    Text('Temps standard par tâche : ${inputData['smv']}'),
                    Text('Mois : ${inputData['month']}'),
                    Text('Département (sweing_0.0) : ${inputData['department_sweing_0_0']}'),
                    Text('Département (sweing_1.0) : ${inputData['department_sweing_1_0']}'),
                    Text('Trimestre : ${inputData['quarter_Quarter1']}'),
                    Text('Nombre de travailleurs : ${inputData['no_of_workers']}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (recommendation != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(recommendation!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onRecalculate,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Recalculer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onSeeHistory,
                    icon: const Icon(Icons.history),
                    label: const Text('Voir l\'historique'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
