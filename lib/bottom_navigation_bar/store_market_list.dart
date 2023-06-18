import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  // Ottiene la posizione attuale dell'utente
  void getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = position.latitude;
      double lng = position.longitude;

      setState(() {
        supermarkets = []; // Svuota la lista dei supermercati
      });

      List<dynamic> fetchedSupermarkets = await fetchSupermarkets(lat, lng);

      // Calcola la distanza tra la tua posizione e la posizione dei supermercati
      for (var supermarket in fetchedSupermarkets) {
        double distance = Geolocator.distanceBetween(
          lat,
          lng,
          supermarket['geometry']['location']['lat'],
          supermarket['geometry']['location']['lng'],
        );
        // Aggiungi la distanza al supermercato
        supermarket['distance'] = distance;
      }

      fetchedSupermarkets.sort((a, b) => a['distance'].compareTo(b['distance'])); // Ordina la lista per distanza

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
      body: ListView.builder(
        itemCount: supermarkets.length,
        itemBuilder: (context, index) {
          final supermarket = supermarkets[index];
          final distanceInMeters = supermarket['distance'];

          String distanceText;
          if (distanceInMeters < 1000) {
            distanceText = '${distanceInMeters.toStringAsFixed(0)} m';
          } else {
            final distanceInKm = distanceInMeters / 1000;
            distanceText = '${distanceInKm.toStringAsFixed(1)} km';
          }

          return InkWell(
            onTap: () {
              // Esegui azioni quando l'elemento viene cliccato
              print('Hai cliccato su ${supermarket['name']}');
            },
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(supermarket['name']),
                  Text(
                    supermarket['vicinity'],
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              trailing: Text(distanceText),
            ),
          );
        },
      ),
    );
  }
}

// Effettua la richiesta API per ottenere la lista dei supermercati nelle vicinanze
Future<List<dynamic>> fetchSupermarkets(double lat, double lng) async {
  const apiKey = 'AIzaSyCKaqCw4qaOftjTRAZshAoihVZDJiDeYMI'; // Sostituisci con la tua chiave API di Google Places

  final url =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=2000&type=supermarket&key=$apiKey';

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
