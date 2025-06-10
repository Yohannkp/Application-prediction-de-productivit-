import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/data_input_page.dart';
import 'pages/prediction_results_page.dart';
import 'pages/history_page.dart';
import 'services/prediction_service.dart';
import 'services/prediction_history_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // État global pour la navigation et les données
  int _pageIndex = 0;
  Map<String, dynamic> _inputData = {
    'targeted_productivity': 0.85,
    'incentive': 0.2,
    'wip': 1200.0,
    'smv': 28.5,
    'department_sweing_0_0': 1.0,
    'department_sweing_1_0': 0.0,
    'quarter_Quarter1': DateTime.now().month <= 3 ? 1.0 : 0.0,
    'team': 1.0,
    'no_of_workers': 30.0,
    'month': DateTime.now().month.toDouble(),
  };
  double? _predictedProductivity;
  String? _recommendation;
  List<Map<String, dynamic>> _history = [];
  final PredictionHistoryService _historyService = PredictionHistoryService();
  bool _loading = false;
  String? _error;

  void _goTo(int index) => setState(() => _pageIndex = index);

  Future<void> _loadHistory() async {
    final loaded = await _historyService.loadHistory();
    setState(() {
      _history = loaded;
    });
  }

  Future<void> _addToHistory(Map<String, dynamic> entry) async {
    await _historyService.addEntry(entry);
    await _loadHistory();
  }

  void _onDataInput(Map<String, dynamic> data) async {
    setState(() {
      _inputData = data;
      _loading = true;
      _error = null;
    });
    try {
      print('Données envoyées à l\'API : ' + data.toString());
      final prediction = await PredictionService().predictProductivity(data);
      print('Résultat API : $prediction');
      final entry = {
        'predicted': prediction,
        'targeted': data['targeted_productivity'],
        'date': DateTime.now().toString().substring(0, 16),
      };
      await _addToHistory(entry);
      setState(() {
        _predictedProductivity = prediction;
        _recommendation = _getRecommendation(prediction, data['targeted_productivity']);
        _pageIndex = 2;
        _loading = false; // Correction : on arrête le chargement après succès
      });
    } catch (e) {
      print('Erreur API : $e');
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String _getRecommendation(double? predicted, double targeted) {
    if (predicted == null) return '';
    if (predicted >= targeted) {
      return 'Bravo ! Vous avez atteint ou dépassé votre objectif. Continuez ainsi !';
    } else if (predicted >= targeted * 0.8) {
      return 'Vous êtes proche de votre objectif. Essayez d’optimiser vos pauses ou d’augmenter votre incentive.';
    } else {
      return 'Votre productivité est en dessous de l’objectif. Révisez vos méthodes de travail ou demandez conseil à votre équipe.';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suivi Productivité',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF8B5CF6)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F0FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF3F0FF),
          foregroundColor: Color(0xFF8B5CF6),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF8B5CF6),
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.1,
          ),
          iconTheme: IconThemeData(color: Color(0xFF8B5CF6)),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF8B5CF6)),
          helperStyle: const TextStyle(color: Colors.grey),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5CF6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 28),
            elevation: 2,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF8B5CF6),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 12,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF8B5CF6)),
          bodyMedium: TextStyle(fontSize: 17, color: Colors.black87),
          bodySmall: TextStyle(fontSize: 15, color: Colors.black54),
        ),
      ),
      home: Scaffold(
        body: _buildPage(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: (index) => setState(() => _pageIndex = index),
          selectedItemColor: Color(0xFF8B5CF6),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              label: 'Saisie',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Résultat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Historique',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() { _error = null; _pageIndex = 1; }),
              child: const Text('Retour à la saisie'),
            ),
          ],
        ),
      );
    }
    switch (_pageIndex) {
      case 0:
        return DashboardPage(
          productivityPercent: (_predictedProductivity ?? 0.0) * 100,
          targetPercent: (_inputData['targeted_productivity'] ?? 0.85) * 100,
          month: (_inputData['month'] as double).toInt(),
          team: (_inputData['team'] as double).toInt(),
          noOfWorkers: (_inputData['no_of_workers'] as double).toInt(),
          onDataInput: () => setState(() => _pageIndex = 1),
          onSeePrediction: () => setState(() => _pageIndex = 2),
        );
      case 1:
        return DataInputPage(
          targetedProductivity: _inputData['targeted_productivity'],
          incentive: _inputData['incentive'],
          wip: _inputData['wip'],
          smv: _inputData['smv'],
          departmentSweing00: _inputData['department_sweing_0_0'],
          departmentSweing10: _inputData['department_sweing_1_0'],
          quarterQuarter1: _inputData['quarter_Quarter1'],
          team: _inputData['team'],
          noOfWorkers: _inputData['no_of_workers'],
          month: (_inputData['month'] as double).toInt(),
          onSubmit: _onDataInput,
        );
      case 2:
        return PredictionResultsPage(
          predictedProductivity: _predictedProductivity,
          targetedProductivity: _inputData['targeted_productivity'],
          inputData: _inputData,
          onRecalculate: () => setState(() => _pageIndex = 1),
          onSeeHistory: () => setState(() => _pageIndex = 3),
          recommendation: _recommendation,
        );
      case 3:
        return HistoryPage(
          history: _history,
          onBack: () => setState(() => _pageIndex = 0),
        );
      default:
        return const Center(child: Text('Page inconnue'));
    }
  }
}
