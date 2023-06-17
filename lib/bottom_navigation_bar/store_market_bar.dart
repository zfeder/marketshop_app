import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supermercati Vicini',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SupermarketList(),
    );
  }
}

class SupermarketList extends StatefulWidget {
  @override
  _SupermarketListState createState() => _SupermarketListState();
}

class _SupermarketListState extends State<SupermarketList> {
  List<dynamic> supermarkets = [];

  @override
  void initState() {
    super.initState();
    fetchSupermarkets(40.7128, -74.0060).then((data) {
      setState(() {
        supermarkets = data;
      });
    }).catchError((error) {
      print('Errore nella richiesta API: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supermercati Vicini'),
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
