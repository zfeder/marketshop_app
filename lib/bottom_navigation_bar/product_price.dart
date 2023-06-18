import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:marketshop_app/bottom_navigation_bar/item_bar.dart';
import '../components_login/button_textfield.dart';
import 'package:marketshop_app/bottom_navigation_bar/scanner_code.dart';

class ProductPrice extends StatefulWidget {
  final int productBarcode;
  const ProductPrice(this.productBarcode, {Key? key}) : super(key: key);

  @override
  _ProductPriceState createState() => _ProductPriceState();
}

class _ProductPriceState extends State<ProductPrice> {
  final itemController = TextEditingController();
  late List<Prodotto> prodotto = [];
  bool isLoading = true;
  String data = '';
  late Prodotto? selectedProduct;

  Future<void> getDataFromDatabase(int barcode) async {
    var value = FirebaseDatabase.instance.ref();

    String supermercato = 'supermercato/8012666060740/';
    String a = supermercato + itemController.text;
    var getValue = await value.child(a).once();
    dynamic showData = getValue.snapshot.value;
    if (showData != null && showData is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> dataMap = showData;
      List<dynamic> keyList = dataMap.keys.toList();

      prodotto = keyList.map<Prodotto>((key) {
        final data = dataMap[key];
        return Prodotto(
          Barcode: 8012666060740,
          Supermercato: data['supermercato'],
          Prezzo: data['prezzo'],
        );
      }).toList();

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDataFromDatabase(widget.productBarcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: prodotto.length,
                  itemBuilder: (context, index) {
                    final product = prodotto[index];
                    return ListTile(
                      onTap: () {},
                      title: Text(product.Supermercato),
                      subtitle: Text('Peso: ${product.Prezzo}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Prodotto {
  final int Barcode;
  final String Supermercato;
  final String Prezzo;

  Prodotto({
    required this.Barcode,
    required this.Supermercato,
    required this.Prezzo,
  });
}
