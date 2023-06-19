import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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

  void saveDataToDatabase(String productName, String brand, String category) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    String barcode = 'barcode/$category/$brand';

    databaseReference.child(barcode).set({
      'barcode': widget.productBarcode,
      'nome': brand,
    }).then((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Data saved successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
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
            title: Text('Error'),
            content: Text('An error occurred while saving data.'),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
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
                decoration: InputDecoration(
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
                decoration: InputDecoration(
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
                decoration: InputDecoration(
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
