import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:core';



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

      List<Prodotto> prodotti = keyList.map<Prodotto>((key) {
        final data = valueList[keyList.indexOf(key)];
        return Prodotto(
          Barcode: data['barcode'],
          Nome: data['nome'],
          Categoria: data['categoria'],
          Marca: data['marca'],
          Prezzo: data['prezzo'].toDouble(),
          Supermercato: data['supermercato'],
        );
      }).toList();

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
        title: const Text('Product List - AAAAA'),
      ),
      body: Center(
        child: isLoading
            ? null // Rimuove il CircularProgressIndicator
            : ListView.builder(
          itemCount: prodotto.length,
          itemBuilder: (context, index) {
            final product = prodotto[index];
            return ListTile(
              title: Text(product.Nome),
              subtitle: Text('Prezzo: ${product.Prezzo}'),
            );
          },
        ),
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

  Prodotto({
    required this.Categoria,
    required this.Marca,
    required this.Nome,
    required this.Prezzo,
    required this.Supermercato,
    required this.Barcode,
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