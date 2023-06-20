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
        );
      }).toList();

      setState(() {
        // Aggiorna lo stato per visualizzare i prodotti nel carrello
      });
    }
  }

  void removeProduct(int index) {
    setState(() {
      prodotto.removeAt(index);
    });
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
                child: ListView.builder(
                  itemCount: prodotto.length,
                  itemBuilder: (context, index) {
                    final product = prodotto[index];

                    return ListTile(
                      leading: Text(product.Nome),
                      title: Text(product.Supermercato),
                      subtitle: Text('Prezzo totale: ${product.Prezzo * product.Quantita}€\nPrezzo per articolo: ${product.Prezzo}€'),
                      trailing: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Quantità: ${product.Quantita}'),
                            ElevatedButton(
                              onPressed: () => removeProduct(index),
                              child: const Text('Rimuovi'),
                            ),
                          ],
                        ),
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
  final String Nome;
  final String Supermercato;
  final double Prezzo;
  final int Quantita;

  Prodotto({
    required this.Nome,
    required this.Supermercato,
    required this.Prezzo,
    required this.Quantita,
  });
}