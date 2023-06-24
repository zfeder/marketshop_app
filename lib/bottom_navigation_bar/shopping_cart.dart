import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<Prodotto> prodotto = [];

  @override
  void initState() {
    super.initState();
    getDataFromFirebase();
  }

  Future<void> getDataFromFirebase() async {
    var value = FirebaseDatabase.instance.ref();
    String? uidUser = FirebaseAuth.instance.currentUser?.uid;
    String carrello = 'carrello/$uidUser/';
    var getValue = await value.child(carrello).once();
    dynamic showData = getValue.snapshot.value;
    if (showData != null && showData is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> dataMap = showData;
      List<dynamic> keyList = dataMap.keys.toList();

      prodotto = keyList.map<Prodotto>((key) {
        final productData = dataMap[key];
        return Prodotto(
          Nome: productData['nome'],
          Supermercato: productData['supermercato'],
          Prezzo: productData['prezzo'].toDouble(),
          Quantita: productData['quantità'],
          Barcode: productData['barcode'],
        );
      }).toList();

      setState(() {
        // Aggiorna lo stato per visualizzare i prodotti nel carrello
      });
    }
  }

  void showRemoveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Il prodotto è stato rimosso dal carrello.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialog
              },
              child: const Text('OK'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void removeProduct(int index, int barcode, String supermercato) async {
    String? uidUser = FirebaseAuth.instance.currentUser?.uid;
    String supermarketLower = supermercato.toLowerCase();
    String valueSuperBar = '$barcode$supermarketLower';
    String path = 'carrello/$uidUser/$valueSuperBar/';

    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    await databaseReference.child(path).remove();
    setState(() {
      prodotto.removeAt(index);
    });

    showRemoveDialog(); // Mostra il dialog dopo la rimozione del prodotto
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
              const Text(
                'Carrello',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: prodotto.isNotEmpty
                    ? ListView.builder(
                  itemCount: prodotto.length,
                  itemBuilder: (context, index) {
                    final product = prodotto[index];

                    return ListTile(
                      title: Text(product.Nome),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${product.Supermercato}'),
                          Text('Quantità: ${product.Quantita}'),
                          Text('Prezzo totale: ${(product.Prezzo * product.Quantita).toStringAsFixed(2)}€'),
                          Text('Prezzo per articolo: ${product.Prezzo.toStringAsFixed(2)}€'),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => removeProduct(index, product.Barcode, product.Supermercato),
                            child: const Text('Rimuovi'),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
                    : const Center(
                  child: Text('Il carrello è vuoto'),
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
  final String Nome;
  final String Supermercato;
  final double Prezzo;
  final int Quantita;
  final int Barcode;

  Prodotto({
    required this.Nome,
    required this.Supermercato,
    required this.Prezzo,
    required this.Quantita,
    required this.Barcode,
  });
}
