import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:marketshop_app/bottom_navigation_bar/product_price.dart';
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
    String categortLower = itemController.text.toLowerCase();
    String a = barcode + categortLower;
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
          Marca: data['marca'],
          Valutazione: data['valutazione'],
          Categoria: data['categoria'],
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPrice(int.parse(scannedValue!)),
      ),
    );
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: itemController,
                      decoration: const InputDecoration(
                        labelText: 'Cerca per nome...',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey, // Colore del bordo predefinito
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey, // Colore del bordo predefinito quando non in stato di focus
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2,
                            color: Colors.green, // Colore del bordo durante lo stato di focus
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: getDataFromDatabase,
                    icon: Icon(Icons.search_outlined),
                    color: Colors.green,
                    //child: const Text('Cerca'),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: scannerOn,
                    icon: Icon(Icons.camera_alt),
                    color: Colors.green,
                  ),
                ],
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
                        subtitle: Text('Marca: ${product.Marca}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            product.Valutazione != 0
                                ? Row(
                              children: [
                                Text('${product.Valutazione}'),
                                const Icon(Icons.star, color: Colors.amber),
                              ],
                            )
                                : Text('Nessuna valutazione'),
                          ],
                        ),
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
  final String Marca;
  final int Valutazione;
  final String Categoria;

  Prodotto({
    required this.Barcode,
    required this.Nome,
    required this.Marca,
    required this.Valutazione,
    required this.Categoria,
  });
}
