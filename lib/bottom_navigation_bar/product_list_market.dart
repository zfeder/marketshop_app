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

      prodotto = valueList.map<Prodotto>((item) {
        final String categoria = item['categoria']; // Assicura che la categoria non sia null
        final String marca = item['marca']; // Assicura che la marca non sia null
        final String nome = item['nome']; // Assicura che il nome non sia null
        final double prezzo = item['prezzo']?.toDouble(); // Assicura che il prezzo non sia null
        final String supermercato = item['supermercato']; // Assicura che il supermercato non sia null

        return Prodotto(
          Categoria: categoria,
          Marca: marca,
          Nome: nome,
          Prezzo: prezzo,
          Supermercato: supermercato,
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

  Prodotto({
    required this.Categoria,
    required this.Marca,
    required this.Nome,
    required this.Prezzo,
    required this.Supermercato,
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