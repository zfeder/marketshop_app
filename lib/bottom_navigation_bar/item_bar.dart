import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:marketshop_app/bottom_navigation_bar/product_price.dart';
import '../components_login/button_textfield.dart';
import 'package:marketshop_app/bottom_navigation_bar/scanner_code.dart';


class ItemBar extends StatefulWidget {
  final Function(String)? onScannerResult;
  final String dataBarcode;

  const ItemBar({required this.dataBarcode, Key? key, this.onScannerResult}) : super(key: key);

  @override
  _ItemBarState createState() => _ItemBarState();
}

class _ItemBarState extends State<ItemBar> {
  final itemController = TextEditingController();
  late List<Prodotto> prodotto;
  bool isLoading = true;
  String data = '';
  late Prodotto? selectedProduct;

  Future<void> getDataFromDatabase() async {
    var value = FirebaseDatabase.instance.ref();
    String barcode = 'barcode/';
    String a = barcode + itemController.text;
    var getValue = await value.child(a).once();
    dynamic showData = getValue.snapshot.value;
    if (showData != null && showData is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> dataMap = showData;
      List<dynamic> keyList = dataMap.keys.toList();

      prodotto = keyList.map<Prodotto>((key) {
        final data = dataMap[key];
        return Prodotto(
          Barcode: data['barcode'],
          Nome: data['nome'],
          Peso: data['peso'],
          Valutazione: data['valutazione'],
        );
      }).toList();

      setState(() {
        isLoading = false;
      });
    }
  }

  void scannerOn() async {
    final String? scannedValue = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScannerCode(),
      ),
    );
    print("*************************************** Valore: $scannedValue");
  }

  void onTap(Prodotto product) {
    setState(() {
      selectedProduct = product;
    });
    print("Selected Product: ${selectedProduct?.Barcode}");
    int productBarcode = product.Barcode;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPrice(productBarcode),
      ),
    );

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
              MyTextField(
                controller: itemController,
                hintText: 'Cerca per nome',
                obscureText: false,
              ),
              ElevatedButton(
                onPressed: getDataFromDatabase,
                child: const Text('Cerca'),
              ),
              ElevatedButton(
                onPressed: scannerOn,
                child: const Text('Scansiona BARCODE'),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const Expanded(child: Text(''))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: prodotto.length,
                    itemBuilder: (context, index) {
                      final product = prodotto[index];
                      return ListTile(
                        onTap: () {
                          onTap(product);
                        },
                        title: Text(product.Nome),
                        subtitle: Text('Peso: ${product.Peso}'),
                        trailing: Text('Valutazione: ${product.Valutazione}'),
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
  final String Nome;
  final String Peso;
  final int Valutazione;

  Prodotto({
    required this.Barcode,
    required this.Nome,
    required this.Peso,
    required this.Valutazione,
  });
}
