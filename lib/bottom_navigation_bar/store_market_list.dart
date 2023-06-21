import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marketshop_app/bottom_navigation_bar/product_list_market.dart';

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
  List<String> allowedNames = [
    'carrefour',
    'crai',
    'lidl',
    'eurospin',
    'despar',
    "in's"
  ];


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

      fetchedSupermarkets.sort((a, b) =>
          a['distance'].compareTo(
              b['distance'])); // Ordina la lista per distanza

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
              goToProductListMarket(supermarket['name']);
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
                    style: const TextStyle(color: Colors.grey),
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

  void goToProductListMarket(String supermarketName) {
    String filteredSupermarketName = allowedNames.firstWhere(
          (name) => supermarketName.toLowerCase().contains(name),
      orElse: () => '',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListMarket(filteredSupermarketName),
      ),
    );
  }

// Effettua la richiesta API per ottenere la lista dei supermercati nelle vicinanze
  Future<List<dynamic>> fetchSupermarkets(double lat, double lng) async {
    const apiKey = 'AIzaSyCKaqCw4qaOftjTRAZshAoihVZDJiDeYMI'; // Replace with your Google Places API key

    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=2000&type=supermarket&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        List<dynamic> results = data['results'];

        List<String> allowedNames = [
          'carrefour',
          'crai',
          'lidl',
          'eurospin',
          'despar',
          "in's"
        ];

        // Filter the results based on the allowed names (case-insensitive)
        List<dynamic> filteredResults = results.where((result) {
          String name = result['name'].toLowerCase();
          return allowedNames.any((allowedName) => name.contains(allowedName));
        }).toList();

        return filteredResults;
      } else {
        throw Exception('API request error: ${data['status']}');
      }
    } else {
      throw Exception('API request error: ${response.statusCode}');
    }
  }

}
