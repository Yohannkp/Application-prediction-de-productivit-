import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final double productivityPercent;
  final double targetPercent;
  final int month;
  final int team;
  final int noOfWorkers;
  final VoidCallback onDataInput;
  final VoidCallback onSeePrediction;

  const DashboardPage({
    super.key,
    required this.productivityPercent,
    required this.targetPercent,
    required this.month,
    required this.team,
    required this.noOfWorkers,
    required this.onDataInput,
    required this.onSeePrediction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bienvenue !', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Votre productivité du mois', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${productivityPercent.toStringAsFixed(1)}%', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                              Text('Atteint', style: TextStyle(color: Colors.white70)),
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
                            child: Icon(Icons.emoji_events, color: Colors.deepPurple, size: 36),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _InfoIcon(icon: Icons.calendar_today, label: 'Mois', value: month.toString()),
                      _InfoIcon(icon: Icons.group, label: 'Équipe', value: team.toString()),
                      _InfoIcon(icon: Icons.people, label: 'Ouvriers', value: noOfWorkers.toString()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onDataInput,
                      icon: const Icon(Icons.edit),
                      label: const Text('Saisir mes données'),
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
                      onPressed: onSeePrediction,
                      icon: const Icon(Icons.analytics),
                      label: const Text('Voir la prédiction'),
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
              const SizedBox(height: 24),
              // TODO: Ajouter graphique camembert/barre pour productivité réelle vs prédite
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoIcon({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 32),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
