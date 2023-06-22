import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:marketshop_app/bottom_navigation_bar/add_price_product.dart';
import 'package:marketshop_app/home_page.dart';

class AddProductDatabase extends StatefulWidget {
  final int productBarcode;

  const AddProductDatabase(this.productBarcode, {Key? key}) : super(key: key);

  @override
  _AddProductDatabaseState createState() => _AddProductDatabaseState();
}

class _AddProductDatabaseState extends State<AddProductDatabase> {
  String selectedValue = '';
  String productName = '';
  String brand = '';
  List<String> dropdownValues = [
    'Acqua',
    'Bevande',
    'Carne',
    'Frutta e Verdura',
    'Latticini e Uova',
    'Pane',
    'Pesce',
    'Snack',
    'Surgelati',
  ];

  void backToItemBar(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage()
      ),
    );
  }

  void addPrice(int barcode, String productName, String brand, String category){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddPriceProduct(barcode, productName, brand, category)
      ),
    );

  }



  void saveDataToDatabase(String productName, String brand, String category) {

    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    String barcode = 'barcode/$category/${widget.productBarcode}';
    String supermercato = 'supermercato/${widget.productBarcode}';

    databaseReference.child(supermercato).set({
    });

    databaseReference.child(barcode).set({
      'barcode': widget.productBarcode,
      'nome': productName,
      'marca': brand,
      'valutazione': 0,
      'categoria': category,
    }).then((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Prodotto aggiunto correttamente'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  addPrice(widget.productBarcode, productName, brand, category);
                },
                child: const Text(
                  'Aggiungi prezzo',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              TextButton(
                child: const Text(
                  'Chiudi',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  backToItemBar();
                },
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
            title: const Text('Error'),
            content: const Text('An error occurred while saving data.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
          'Aggiungi Prodotto',
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

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Barcode: ${widget.productBarcode}'),
              const SizedBox(height: 20.0),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nome Prodotto',
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
                onChanged: (value) {
                  setState(() {
                    productName = value;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Marca',
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
                onChanged: (value) {
                  setState(() {
                    brand = value;
                  });
                },
              ),



              const SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: selectedValue.isNotEmpty ? selectedValue : null,
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: dropdownValues.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Seleziona una categoria',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.green),
                  ),
                ),
              ),

              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                    saveDataToDatabase(productName, brand, selectedValue);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: const Text('Aggiungi'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
