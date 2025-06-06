import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictionService {
  static const String _baseUrl = 'https://application-prediction-de-productivit.onrender.com';

  Future<double?> predictProductivity(Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/predict');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['predicted_actual_productivity']?.toDouble();
      } else {
        throw Exception('Erreur API: \\nStatus: \\${response.statusCode}\\nBody: \\${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion à l\'API: \\n$e');
    }
  }
}
