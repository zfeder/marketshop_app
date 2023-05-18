import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(const StoreMarketBar());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      home: StoreMarketBar(),
    );
  }
}

class StoreMarketBar  extends StatefulWidget {
  const StoreMarketBar({Key? key}) : super(key: key);

  @override
  State<StoreMarketBar> createState() => _StoreMarketBar();
}

class _StoreMarketBar extends State<StoreMarketBar> {
  /*
  serviceEnabled and permissionGranted are used
  to check if location service is enable and permission is granted
  */
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  LocationData? _userLocation;

  // This function will get user location
  Future<void> _getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await location.getLocation();
    setState(() {
      _userLocation = locationData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Vicini'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: _getUserLocation,
                  child: const Text('Check Location')),
              const SizedBox(height: 25),
              // Display latitude & longtitude
              _userLocation != null
                  ? Wrap(
                children: [
                  Text('Your latitude: ${_userLocation?.latitude}'),
                  const SizedBox(width: 10),
                  Text('Your longtitude: ${_userLocation?.longitude}')
                ],
              )
                  : const Text(
                  'Please enable location service and grant permission')
            ],
          ),
        ),
      ),
    );
  }
}