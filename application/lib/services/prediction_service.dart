import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictionService {
  static const String _baseUrl = 'https://application-prediction-de-productivit.onrender.com';

  Future<double?> predictProductivity(Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/predict');
    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        // Pour debug : print la réponse brute
        print('Réponse API: ${response.body}');
        return decoded['predicted_actual_productivity']?.toDouble();
      } else {
        print('Erreur API: Status: ${response.statusCode} Body: ${response.body}');
        throw Exception('Erreur API: Status: ${response.statusCode} Body: ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Délai d’attente dépassé : le serveur met trop de temps à répondre.');
    } catch (e) {
      throw Exception('Erreur de connexion à l\'API : $e');
    }
  }
}
