import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:marketshop_app/bottom_navigation_bar/add_price_product.dart';
import 'package:marketshop_app/bottom_navigation_bar/item_bar.dart';
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

  void addPrice(int barcode, String productName, String brand){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddPriceProduct(barcode, productName, brand)
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
            title: const Text('Success'),
            content: const Text('Data saved successfully.'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    addPrice(widget.productBarcode, productName, brand);
                  },
                  child: const Text('Aggiungi prezzo')
              ),
              TextButton(
                child: const Text('Close'),
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
        title: const Text('Add Product to Database'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Product Barcode: ${widget.productBarcode}'),
              const SizedBox(height: 20.0),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
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
                  labelText: 'Brand',
                  border: OutlineInputBorder(),
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
                  labelText: 'Select a category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (productName.isNotEmpty &&
                      brand.isNotEmpty &&
                      selectedValue.isNotEmpty) {
                    saveDataToDatabase(productName, brand, selectedValue);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
