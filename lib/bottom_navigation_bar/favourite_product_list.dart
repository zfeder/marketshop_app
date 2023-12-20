import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:core';

import 'package:marketshop_app/bottom_navigation_bar/product_price.dart';

class FavouriteProductList extends StatefulWidget {
  const FavouriteProductList({Key? key}) : super(key: key);

  @override
  _FavouriteProductList createState() => _FavouriteProductList();
}

class _FavouriteProductList extends State<FavouriteProductList> {
  late List<Prodotto> prodotto;
  bool isLoading = true;

  _FavouriteProductList() {
    prodotto = []; // Inizializza la variabile prodotto come una lista vuota
  }

  @override
  void initState() {
    super.initState();
    getDataFromDatabase();
  }

  void backToOtherPrice(int barcode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPrice(barcode),
      ),
    );
  }


  Future<void> getDataFromDatabase() async {
    var value = FirebaseDatabase.instance.ref();
    String? uidUser = FirebaseAuth.instance.currentUser?.uid;
    String preferiti = 'preferiti/$uidUser/';
    var getValue = await value.child(preferiti).once();
    dynamic showData = getValue.snapshot.value;

    if (showData != null && showData is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> dataMap = showData;
      List<dynamic> keyList = dataMap.keys.toList();

      prodotto = keyList.expand<Prodotto>((key) {
        final data = dataMap[key];
        if (data is Map<dynamic, dynamic>) {
            return [
              Prodotto(
                Nome: data['nome'],
                Barcode: data['barcode'],
                Marca: data['marca'],
              )
            ];
        }
        return [];
      }).toList();

      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Preferiti',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16), // Aggiunge uno spazio vuoto di 16 pixel
          Expanded(
            child: Center(
              child: isLoading
                  ? null // Rimuove il CircularProgressIndicator
                  : ListView.builder(
                itemCount: prodotto.length,
                itemBuilder: (context, index) {
                  final product = prodotto[index];
                  return ListTile(
                    title: Text(product.Nome),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Marca: ${product.Marca}'),
                          ],
                        ),
                        TextButton(
                          child: const Text('Visualizza prezzi'),
                          onPressed: () {
                            backToOtherPrice(product.Barcode);
                          },
                        ),
                      ],
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
}

class Prodotto {
  final String Marca;
  final String Nome;
  final int Barcode;

  Prodotto({
    required this.Marca,
    required this.Nome,
    required this.Barcode,
  });
}

