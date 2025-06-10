import 'package:flutter/material.dart';
import '../services/prediction_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _predictedProductivity;
  double _targetedProductivity = 0.85;
  double _incentive = 0.2;
  double _wip = 1200.0;
  double _smv = 28.5;
  double _departmentSweing00 = 1.0;
  double _departmentSweing10 = 0.0;
  double _quarterQuarter1 = DateTime.now().month <= 3 ? 1.0 : 0.0;
  bool _loading = false;
  String? _error;
  List<double> _history = [];

  // Automatique : month, team, no_of_workers
  double get _month => DateTime.now().month.toDouble();
  double get _team => 1.0; // À remplacer par la vraie équipe si besoin
  double get _noOfWorkers => 30.0; // À remplacer par la vraie valeur si besoin

  Map<String, dynamic> _collectProductivityData() {
    return {
      'targeted_productivity': _targetedProductivity,
      'incentive': _incentive,
      'wip': _wip,
      'team': _team,
      'smv': _smv,
      'month': _month,
      'department_sweing_0_0': _departmentSweing00,
      'department_sweing_1_0': _departmentSweing10,
      'quarter_Quarter1': _quarterQuarter1,
      'no_of_workers': _noOfWorkers,
    };
  }

  Future<void> _analyzeProductivity() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final data = _collectProductivityData();
    try {
      final prediction = await PredictionService().predictProductivity(data);
      setState(() {
        _predictedProductivity = prediction;
        if (prediction != null) {
          _history.add(prediction);
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildManualInput({required String label, required double value, required void Function(String) onChanged, String? helper}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        initialValue: value.toString(),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          helperText: helper,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (v) => onChanged(v),
      ),
    );
  }

  Widget _buildRecommendation() {
    if (_predictedProductivity == null) return SizedBox.shrink();
    if (_predictedProductivity! >= _targetedProductivity) {
      return const Text('Bravo ! Vous avez atteint ou dépassé votre objectif. Continuez ainsi !', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold));
    } else if (_predictedProductivity! >= _targetedProductivity * 0.8) {
      return const Text('Vous êtes proche de votre objectif. Essayez d’optimiser vos pauses ou d’augmenter votre incentive.', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold));
    } else {
      return const Text('Votre productivité est en dessous de l’objectif. Révisez vos méthodes de travail ou demandez conseil à votre équipe.', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
    }
  }

  Widget _buildHistory() {
    if (_history.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        const Text('Historique des prédictions :', style: TextStyle(fontWeight: FontWeight.bold)),
        ..._history.map((v) => Text('${(v * 100).toStringAsFixed(1)}%', style: const TextStyle(color: Colors.blue))).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suivi Productivité')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Champs manuels
                _buildManualInput(
                  label: 'Objectif de productivité',
                  value: _targetedProductivity,
                  helper: 'Exemple : 0.85',
                  onChanged: (v) => setState(() => _targetedProductivity = double.tryParse(v) ?? _targetedProductivity),
                ),
                _buildManualInput(
                  label: 'Incentive',
                  value: _incentive,
                  helper: 'Prime d’incitation (0.0 à 1.0)',
                  onChanged: (v) => setState(() => _incentive = double.tryParse(v) ?? _incentive),
                ),
                _buildManualInput(
                  label: 'WIP',
                  value: _wip,
                  helper: 'Travail en cours',
                  onChanged: (v) => setState(() => _wip = double.tryParse(v) ?? _wip),
                ),
                _buildManualInput(
                  label: 'SMV',
                  value: _smv,
                  helper: 'Standard Minute Value',
                  onChanged: (v) => setState(() => _smv = double.tryParse(v) ?? _smv),
                ),
                _buildManualInput(
                  label: 'Département sweing_0_0',
                  value: _departmentSweing00,
                  helper: '1 si sweing_0.0, sinon 0',
                  onChanged: (v) => setState(() => _departmentSweing00 = double.tryParse(v) ?? _departmentSweing00),
                ),
                _buildManualInput(
                  label: 'Département sweing_1_0',
                  value: _departmentSweing10,
                  helper: '1 si sweing_1.0, sinon 0',
                  onChanged: (v) => setState(() => _departmentSweing10 = double.tryParse(v) ?? _departmentSweing10),
                ),
                _buildManualInput(
                  label: 'Quarter 1',
                  value: _quarterQuarter1,
                  helper: '1 si Q1, sinon 0',
                  onChanged: (v) => setState(() => _quarterQuarter1 = double.tryParse(v) ?? _quarterQuarter1),
                ),
                const SizedBox(height: 16),
                // Résultat et recommandations
                if (_predictedProductivity != null)
                  Column(
                    children: [
                      Text('Votre productivité prédite :', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text('${(_predictedProductivity! * 100).toStringAsFixed(1)}%', style: TextStyle(fontSize: 32, color: Colors.green, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _buildRecommendation(),
                    ],
                  ),
                if (_error != null)
                  Text(_error!, style: TextStyle(color: Colors.red)),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                ElevatedButton.icon(
                  onPressed: _loading ? null : _analyzeProductivity,
                  icon: const Icon(Icons.analytics),
                  label: const Text('Analyser ma productivité'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                _buildHistory(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
