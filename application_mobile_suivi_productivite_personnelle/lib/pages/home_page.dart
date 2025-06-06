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
  bool _loading = false;
  String? _error;

  Map<String, dynamic> _collectAutoProductivityData() {
    return {
      'targeted_productivity': _targetedProductivity.toDouble(),
      'incentive': 0.2,
      'wip': 1200.0,
      'team': 1.0,
      'smv': 28.5,
      'month': DateTime.now().month.toDouble(),
      'department_sweing_0_0': 1.0,
      'department_sweing_1_0': 0.0,
      'quarter_Quarter1': DateTime.now().month <= 3 ? 1.0 : 0.0,
      'no_of_workers': 30.0,
    };
  }

  Future<void> _analyzeProductivity() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final data = _collectAutoProductivityData();
    try {
      final prediction = await PredictionService().predictProductivity(data);
      setState(() {
        _predictedProductivity = prediction;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suivi Productivité')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_predictedProductivity != null)
                Column(
                  children: [
                    Text('Votre productivité prédite :', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text('${(_predictedProductivity! * 100).toStringAsFixed(1)}%', style: TextStyle(fontSize: 32, color: Colors.green, fontWeight: FontWeight.bold)),
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
            ],
          ),
        ),
      ),
    );
  }
}
