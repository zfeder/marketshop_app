import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchSupermarkets(double lat, double lng) async {
  const apiKey = 'AIzaSyCKaqCw4qaOftjTRAZshAoihVZDJiDeYMI'; // Sostituisci con la tua API key di Google Places

  final url =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=5000&type=supermarket&key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      return data['results'];
    } else {
      throw Exception('Errore nella richiesta API: ${data['status']}');
    }
  } else {
    throw Exception('Errore nella richiesta API: ${response.statusCode}');
  }
}
