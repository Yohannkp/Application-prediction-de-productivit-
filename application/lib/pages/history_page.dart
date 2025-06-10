import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/prediction_history_service.dart';

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final VoidCallback onBack;

  const HistoryPage({super.key, required this.history, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suivi des objectifs')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Text('Historique des performances', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            // Légende pour le graphique
            if (history.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 16, height: 16, color: Colors.green),
                  const SizedBox(width: 6),
                  const Text('Prédiction atteinte'),
                  const SizedBox(width: 16),
                  Container(width: 16, height: 16, color: Color(0xFF8B5CF6)),
                  const SizedBox(width: 6),
                  const Text('Objectif'),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 260,
                child: _BarChartWithTouch(history: history),
              ),
              const SizedBox(height: 16),
            ],
            ElevatedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Retour'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Effacer l\'historique ?'),
                    content: const Text('Voulez-vous vraiment supprimer tout l\'historique des prédictions ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await PredictionHistoryService().clearHistory();
                          if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
                        },
                        child: const Text('Effacer'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete),
              label: const Text('Effacer l\'historique'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// Ajout du widget interactif pour le graphique
class _BarChartWithTouch extends StatefulWidget {
  final List<Map<String, dynamic>> history;
  const _BarChartWithTouch({required this.history});

  @override
  State<_BarChartWithTouch> createState() => _BarChartWithTouchState();
}

class _BarChartWithTouchState extends State<_BarChartWithTouch> {
  int? touchedGroup;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceBetween,
        maxY: 1.2,
        minY: 0,
        groupsSpace: 18,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            // tooltipBgColor: Colors.white,
            // tooltipRoundedRadius: 12,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final entry = widget.history[group.x.toInt()];
              return BarTooltipItem(
                rodIndex == 0
                  ? 'Prédiction: ${(entry['predicted'] * 100).toStringAsFixed(1)}%\n'
                  : 'Objectif: ${(entry['targeted'] * 100).toStringAsFixed(1)}%',
                TextStyle(
                  color: rodIndex == 0 ? Colors.green : Color(0xFF8B5CF6),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              );
            },
          ),
          touchCallback: (event, response) {
            setState(() {
              if (response == null || response.spot == null) {
                touchedGroup = null;
              } else {
                touchedGroup = response.spot!.touchedBarGroupIndex;
              }
            });
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text('${(value * 100).toInt()}%', style: const TextStyle(fontSize: 13, color: Colors.black54)),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= widget.history.length) return const SizedBox.shrink();
                final date = widget.history[idx]['date'] ?? '';
                return Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(date.split(' ').first, style: const TextStyle(fontSize: 11, color: Colors.black54)),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 0.2),
        borderData: FlBorderData(show: false),
        barGroups: [
          for (int i = 0; i < widget.history.length; i++)
            BarChartGroupData(
              x: i,
              barsSpace: 4,
              barRods: [
                BarChartRodData(
                  toY: (widget.history[i]['predicted'] as num).toDouble(),
                  color: touchedGroup == i ? Colors.green.shade700 : Colors.green,
                  width: touchedGroup == i ? 20 : 14,
                  borderRadius: BorderRadius.circular(6),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 1.0,
                    color: Colors.green.withOpacity(0.08),
                  ),
                ),
                BarChartRodData(
                  toY: (widget.history[i]['targeted'] as num).toDouble(),
                  color: touchedGroup == i ? Color(0xFF6D28D9) : Color(0xFF8B5CF6),
                  width: touchedGroup == i ? 20 : 14,
                  borderRadius: BorderRadius.circular(6),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 1.0,
                    color: Color(0xFF8B5CF6).withOpacity(0.08),
                  ),
                ),
              ],
              showingTooltipIndicators: touchedGroup == i ? [0, 1] : [],
            ),
        ],
      ),
    );
  }
}
