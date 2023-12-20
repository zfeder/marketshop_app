import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:core';


import 'package:marketshop_app/bottom_navigation_bar/product_price.dart';

class ProductListMarket extends StatefulWidget {
  final String supermarketName;
  const ProductListMarket(this.supermarketName, {Key? key}) : super(key: key);

  @override
  _ProductListMarketState createState() => _ProductListMarketState();
}

class _ProductListMarketState extends State<ProductListMarket> {
  late List<Prodotto> prodotto;
  bool isLoading = true;

  _ProductListMarketState() {
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

  Future<double> getValutazioneFromDatabase(int barcode) async {
    var value = FirebaseDatabase.instance.ref();
    String barcodePath = 'supermercato/$barcode/valutazione';
    var getValue = await value.child(barcodePath).once();
    dynamic showData = getValue.snapshot.value;

    if (showData != null) {
      double valutazioneData = showData.toDouble();
      return valutazioneData;
    }

    return 0.0; // Valutazione predefinita se non presente nel database
  }

  Future<void> getDataFromDatabase() async {
    var value = FirebaseDatabase.instance.ref();

    String supermercato = 'supermercato/';
    var getValue = await value.child(supermercato).once();
    dynamic showData = getValue.snapshot.value;

    if (showData != null && showData is Map<dynamic, dynamic>) {
      String supermercato2 = widget.supermarketName.capitalize();
      Map<dynamic, dynamic> dataMap = showData;
      List<dynamic> keyList = [];
      List<dynamic> valueList = [];

      dataMap.forEach((key, value) {
        value.forEach((supermercato, prodotto) {
          if (supermercato == supermercato2) {
            keyList.add(key);
            valueList.add(prodotto);
          }
        });
      });

      List<Prodotto> prodotti = [];

      for (int i = 0; i < keyList.length; i++) {
        final data = valueList[i];
        int barcode = data['barcode'];

        double valutazione = await getValutazioneFromDatabase(barcode);

        prodotti.add(
          Prodotto(
            Barcode: barcode,
            Nome: data['nome'],
            Categoria: data['categoria'],
            Marca: data['marca'],
            Prezzo: data['prezzo'].toDouble(),
            Supermercato: data['supermercato'],
            Valutazione: valutazione,
          ),
        );
      }

      setState(() {
        prodotto = prodotti;
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.supermarketName.capitalize(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            Text('Prezzo: ${product.Prezzo}'),
                          ],
                        ),
                        Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: product.Valutazione != 0
                                  ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    product.Valutazione.toStringAsFixed(2),
                                  ),
                                  Icon(Icons.star, color: Colors.amber),
                                ],
                              )
                                  : Container(),
                            )
                        ),
                        TextButton(
                          child: const Text('Altri prezzi'),
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
  final String Categoria;
  final String Marca;
  final String Nome;
  final double Prezzo;
  final String Supermercato;
  final int Barcode;
  double Valutazione;

  Prodotto({
    required this.Categoria,
    required this.Marca,
    required this.Nome,
    required this.Prezzo,
    required this.Supermercato,
    required this.Barcode,
    this.Valutazione = 1,
  });
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}
