import 'package:flutter/material.dart';

class DataInputPage extends StatefulWidget {
  final double targetedProductivity;
  final double incentive;
  final double wip;
  final double smv;
  final double departmentSweing00;
  final double departmentSweing10;
  final double quarterQuarter1;
  final double team;
  final double noOfWorkers;
  final int month;
  final void Function(Map<String, dynamic>) onSubmit;

  const DataInputPage({
    super.key,
    required this.targetedProductivity,
    required this.incentive,
    required this.wip,
    required this.smv,
    required this.departmentSweing00,
    required this.departmentSweing10,
    required this.quarterQuarter1,
    required this.team,
    required this.noOfWorkers,
    required this.month,
    required this.onSubmit,
  });

  @override
  State<DataInputPage> createState() => _DataInputPageState();
}

class _DataInputPageState extends State<DataInputPage> {
  late final TextEditingController _targetedProductivityController = TextEditingController(text: widget.targetedProductivity.toString());
  late final TextEditingController _incentiveController = TextEditingController(text: widget.incentive.toString());
  late final TextEditingController _wipController = TextEditingController(text: widget.wip.toString());
  late final TextEditingController _smvController = TextEditingController(text: widget.smv.toString());
  late double _departmentSweing00 = widget.departmentSweing00;
  late double _departmentSweing10 = widget.departmentSweing10;
  late double _quarterQuarter1 = widget.quarterQuarter1;
  late final TextEditingController _teamController = TextEditingController(text: widget.team.toString());
  late final TextEditingController _noOfWorkersController = TextEditingController(text: widget.noOfWorkers.toString());
  late final TextEditingController _monthController = TextEditingController(text: widget.month.toString());

  @override
  void dispose() {
    _targetedProductivityController.dispose();
    _incentiveController.dispose();
    _wipController.dispose();
    _smvController.dispose();
    _teamController.dispose();
    _noOfWorkersController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrée des données'),
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
                  Text('Saisie de vos données', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Remplissez les champs pour obtenir une prédiction personnalisée.', style: TextStyle(color: Colors.white70, fontSize: 15)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitle('Objectifs de productivité'),
            _styledField(_targetedProductivityController, 'Objectif de productivité à atteindre', 'Exemple : 0.85'),
            const SizedBox(height: 16),
            _sectionTitle('Paramètres de travail'),
            _styledField(_incentiveController, 'Prime ou incitation financière', 'Exemple : 0.2'),
            _styledField(_wipController, 'Nombre de tâches ou projets en cours', 'Exemple : 1200'),
            _styledField(_smvController, 'Temps standard alloué pour chaque tâche', 'Exemple : 28.5'),
            const SizedBox(height: 16),
            _sectionTitle('Informations du département'),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Département sweing_0.0'),
                    value: _departmentSweing00 == 1.0,
                    onChanged: (v) => setState(() {
                      _departmentSweing00 = v! ? 1.0 : 0.0;
                      if (v) _departmentSweing10 = 0.0;
                    }),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    activeColor: Color(0xFF8B5CF6),
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Département sweing_1.0'),
                    value: _departmentSweing10 == 1.0,
                    onChanged: (v) => setState(() {
                      _departmentSweing10 = v! ? 1.0 : 0.0;
                      if (v) _departmentSweing00 = 0.0;
                    }),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    activeColor: Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
            CheckboxListTile(
              title: const Text('Indicateur du trimestre de l\'année (Q1)'),
              value: _quarterQuarter1 == 1.0,
              onChanged: (v) => setState(() => _quarterQuarter1 = v! ? 1.0 : 0.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              activeColor: Color(0xFF8B5CF6),
            ),
            const SizedBox(height: 16),
            _sectionTitle('Informations générales'),
            _styledField(_teamController, 'Identification de l\'équipe', 'Exemple : 1'),
            _styledField(_noOfWorkersController, 'Nombre de travailleurs', 'Exemple : 30'),
            _styledField(_monthController, 'Mois de l\'année', 'Exemple : 6'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                widget.onSubmit({
                  'targeted_productivity': double.tryParse(_targetedProductivityController.text) ?? 0.0,
                  'incentive': double.tryParse(_incentiveController.text) ?? 0.0,
                  'wip': double.tryParse(_wipController.text) ?? 0.0,
                  'smv': double.tryParse(_smvController.text) ?? 0.0,
                  'department_sweing_0_0': _departmentSweing00,
                  'department_sweing_1_0': _departmentSweing10,
                  'quarter_Quarter1': _quarterQuarter1,
                  'team': double.tryParse(_teamController.text) ?? 0.0,
                  'no_of_workers': double.tryParse(_noOfWorkersController.text) ?? 0.0,
                  'month': double.tryParse(_monthController.text) ?? 0.0,
                });
              },
              icon: const Icon(Icons.check),
              label: const Text('Valider et prédire'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF8B5CF6))),
      );

  Widget _styledField(TextEditingController controller, String label, String helper) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            helperText: helper,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      );
}
