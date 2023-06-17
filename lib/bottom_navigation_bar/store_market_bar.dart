import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supermercati Vicini',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SupermarketList(),
    );
  }
}

class SupermarketList extends StatefulWidget {
  const SupermarketList({Key? key});

  @override
  _SupermarketListState createState() => _SupermarketListState();
}

class _SupermarketListState extends State<SupermarketList> {
  List<dynamic> supermarkets = [];

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = position.latitude;
      double lng = position.longitude;

      List<dynamic> fetchedSupermarkets = await fetchSupermarkets(lat, lng);

      setState(() {
        supermarkets = fetchedSupermarkets;
      });
    } catch (e) {
      print('Errore durante l\'ottenimento della posizione: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supermercati Vicini'),
      ),
      body: ListView.builder(
        itemCount: supermarkets.length,
        itemBuilder: (context, index) {
          final supermarket = supermarkets[index];
          return ListTile(
            title: Text(supermarket['name']),
            subtitle: Text(supermarket['vicinity']),
            trailing: Text('${supermarket['rating']}'),
          );
        },
      ),
    );
  }
}

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
