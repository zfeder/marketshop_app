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
      Map<dynamic, dynamic> dataMap = showData;
      List<dynamic> keyList = dataMap.keys.toList();
      List<dynamic> valueList = dataMap.values.toList();
      //valueList.removeWhere((element) => element != 'Carrefour');
      String supermercato2 = widget.supermarketName.capitalize();
      for (int i = 0; i < valueList.length; i++) {
        valueList[i].removeWhere((key, value) => value['supermercato'] != supermercato2);
      }

      valueList.removeWhere((element) {
        if (element is Map<dynamic, dynamic>) {
          return element.isEmpty;
        }
        return false;
      });


      prodotto = keyList.map<Prodotto>((key) {
        final data = dataMap[key];
        return Prodotto(
          Barcode: data['barcode'],
          Categoria: data['categoria'],
          Marca: data['marca'],
          Nome: data['nome'],
          Prezzo: data['prezzo'].toDouble(),
          Supermercato: data['supermercato'], // Imposta il valore desiderato per key
        );
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
              subtitle: Text('Price: \$${product.Prezzo.toStringAsFixed(2)}'),
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