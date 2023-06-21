import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:marketshop_app/home_page.dart';

class AddPriceProduct extends StatefulWidget {
  final int productBarcode;
  final String productName;
  final String brand;
  final String category;
  const AddPriceProduct(this.productBarcode, this.productName, this.brand, this.category, {Key? key}) : super(key: key);

  @override
  _AddPriceProductState createState() => _AddPriceProductState();
}

class _AddPriceProductState extends State<AddPriceProduct> {
  String _selectedSupermercato = 'Carrefour';
  TextEditingController _prezzoController = TextEditingController();

  @override
  void dispose() {
    _prezzoController.dispose();
    super.dispose();
  }

  void backToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const HomePage()
      ),
    );
  }

  void savePriceToDatabase(String supermercato, double prezzo) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    String superMarket = 'supermercato/${widget.productBarcode}/$supermercato';
    databaseReference.child(superMarket).set({
      'supermercato': supermercato,
      'prezzo': prezzo,
      'marca': widget.brand,
      'nome': widget.productName,
      'categoria' : widget.category,
    }).then((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Price saved successfully.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  backToHome();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while saving the price.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  backToHome();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Price Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedSupermercato,
              onChanged: (newValue) {
                setState(() {
                  _selectedSupermercato = newValue!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'Carrefour',
                  child: Text('Carrefour'),
                ),
                DropdownMenuItem(
                  value: 'Crai',
                  child: Text('Crai'),
                ),
                DropdownMenuItem(
                  value: 'Lidl',
                  child: Text('Lidl'),
                ),
                DropdownMenuItem(
                  value: 'Eurospin',
                  child: Text('Eurospin'),
                ),
                DropdownMenuItem(
                  value: 'Despar',
                  child: Text('Despar'),
                ),
                DropdownMenuItem(
                  value: "iN's",
                  child: Text("iN's"),
                ),
              ],
              decoration: const InputDecoration(
                labelText: 'Supermercato',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _prezzoController,
              decoration: const InputDecoration(
                labelText: 'Prezzo',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String supermercato = _selectedSupermercato;
                double prezzo = double.parse(_prezzoController.text);
                savePriceToDatabase(supermercato, prezzo);
              },
              child: Text('Salva'),
            ),
          ],
        ),
      ),
    );
  }
}
