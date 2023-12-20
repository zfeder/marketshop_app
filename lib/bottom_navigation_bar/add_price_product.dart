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
      'barcode' : widget.productBarcode,
    }).then((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Prezzo aggiunto correttamente'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  backToHome();
                },
                child: const Text(
                  'Chiudi',
                  style: TextStyle(color: Colors.green),
                ),
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
                child: Text('Chiudi'),
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
        title: const Text(
          'Aggiungi Prezzo',
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                labelText: 'Seleziona una supermercato',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _prezzoController,
              decoration: const InputDecoration(
                labelText: 'Prezzo',
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
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String supermercato = _selectedSupermercato;
                double prezzo = double.parse(_prezzoController.text);
                savePriceToDatabase(supermercato, prezzo);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: const Text('Aggiungi'),
            ),
          ],
        ),
      ),
    );
  }
}
