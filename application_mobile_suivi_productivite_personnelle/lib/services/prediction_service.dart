import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictionService {
  static const String _baseUrl = 'http://192.168.1.65:8000';

  Future<double?> predictProductivity(Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/predict');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['predicted_actual_productivity']?.toDouble();
    } else {
      return null;
    }
  }
}
