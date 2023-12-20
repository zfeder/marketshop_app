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
    bool serviceEnabled;
    LocationPermission permission;

    // Controlla se il servizio di localizzazione è abilitato
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Il servizio di localizzazione non è abilitato, mostra un messaggio all'utente o richiedi l'attivazione
      return;
    }

    // Controlla lo stato dell'autorizzazione alla posizione
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // L'autorizzazione alla posizione è stata negata in precedenza, richiedi l'autorizzazione all'utente
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // L'utente ha rifiutato l'autorizzazione alla posizione, mostra un messaggio o gestisci il caso di mancata autorizzazione
        return;
      }
    }

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
      body: Column(
        children: [
          const SizedBox(height: 16), // Aggiunge uno spazio vuoto di 16 pixel
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
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
            ),
          ),
        ],
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
    const apiKey = 'AIzaSyCKaqCw4qaOftjTRAZshAoihVZDJiDeYMI';

    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=2000&type=supermarket&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        List<dynamic> results = data['results'];

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
