import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'add_price_product.dart';
import 'add_product_database.dart';

class ProductPrice extends StatefulWidget {
  final int productBarcode;
  const ProductPrice(this.productBarcode, {Key? key}) : super(key: key);

  @override
  _ProductPriceState createState() => _ProductPriceState();
}

class _ProductPriceState extends State<ProductPrice> {
  final itemController = TextEditingController();
  late List<Prodotto> prodotto = [];
  String nomeProd = '';
  bool isLoading = true;
  String data = '';
  bool isPopupVisible = false;
  double rating = 0.0; // Valutazione iniziale

  void addDataToFirebase(String nomeProdotto, double prezzo, int quantita, int barcode, String supermercato, String marca) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    String? uidUser = FirebaseAuth.instance.currentUser?.uid;

    String carrello = 'carrello/$uidUser/$barcode';
    String productNameLowercase = supermercato.toLowerCase().replaceAll(' ', '_');
    String path = carrello + productNameLowercase;

    databaseReference.child(path).set({
      'supermercato': supermercato,
      'prezzo': prezzo.toDouble(), // Conversione da int a double
      'nome': nomeProdotto,
      'quantità': quantita,
      'marca': marca,
      'barcode' : barcode,
    }).then((_) {
      setState(() {
        isPopupVisible = true;
      });

      Timer(const Duration(seconds: 1), () {
        setState(() {
          isPopupVisible = false;
        });
      });
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Errore'),
            content: const Text('Si è verificato un errore durante l\'aggiunta del prodotto al carrello.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Chiudi'),
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

  Future<void> getDataFromDatabase(int barcode) async {
    var value = FirebaseDatabase.instance.ref();

    String supermercato = 'supermercato/$barcode/';
    String a = supermercato + itemController.text;
    var getValue = await value.child(a).once();
    dynamic showData = getValue.snapshot.value;

    if (showData != null && showData is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> dataMap = showData;
      List<dynamic> keyList = dataMap.keys.toList();

      prodotto = keyList.map<Prodotto>((key) {
        final data = dataMap[key];
        nomeProd = data['nome'];
        return Prodotto(
          nome: data['nome'],
          Barcode: barcode,
          Marca: data['marca'],
          Supermercato: data['supermercato'],
          Categoria : data['categoria'],
          Prezzo: data['prezzo'].toDouble(), // Modifica per convertire il valore in double
          Quantita: 0,
          Valutazione: data.containsKey('rating') ? data['rating'].toDouble() : 0.0,
        );
      }).toList();

      setState(() {
        isLoading = false;
      });
    }

    if (prodotto.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddProductDatabase(widget.productBarcode),
        ),
      );
    }
  }

  void saveRatingToFirebase(double valutazione) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    String? uidUser = FirebaseAuth.instance.currentUser?.uid;

    if (uidUser != null) {
      String path = 'barcode/${prodotto[0].Categoria}/${prodotto[0].Barcode}';
      databaseReference.child(path).update({
        'valutazione': valutazione,
      }).then((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Successo'),
              content: const Text('Valutazione salvata con successo.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Chiudi'),
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
              title: const Text('Errore'),
              content: const Text('Si è verificato un errore durante il salvataggio della valutazione.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Chiudi'),
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
  }

  void addProductPrice(int barcode, String productName, String brand, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddPriceProduct(barcode, productName, brand, category)
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    getDataFromDatabase(widget.productBarcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          nomeProd,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              addProductPrice(prodotto[0].Barcode, prodotto[0].nome, prodotto[0].Marca, prodotto[0].Categoria);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),

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
                      title: Text(product.Supermercato),
                      subtitle: Text('Prezzo: ${product.Prezzo}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (product.Quantita > 0) {
                                  product.Quantita--;
                                }
                              });
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text('${product.Quantita}'),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                product.Quantita++;
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () {
                              addDataToFirebase(product.nome, product.Prezzo, product.Quantita, product.Barcode, product.Supermercato, product.Marca);
                            },
                            icon: const Icon(Icons.add_shopping_cart_outlined),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Visibility(
                visible: isPopupVisible,
                child: Container(
                  width: 200,
                  height: 100,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text(
                      'Prodotto aggiunto al carrello!',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: StarRating(
                  starCount: 5,
                  rating: rating,
                  color: Colors.amber,
                  size: 30.0,
                  onRatingChanged: (newRating) {
                    setState(() {
                      rating = newRating;
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  saveRatingToFirebase(rating);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: const Text('Salva valutazione'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Prodotto {
  final String nome;
  final int Barcode;
  final String Supermercato;
  final double Prezzo;
  final String Marca;
  String Categoria;
  int Quantita;
  double Valutazione;

  Prodotto({
    required this.nome,
    required this.Barcode,
    required this.Supermercato,
    required this.Prezzo,
    required this.Marca,
    this.Categoria = '',
    this.Quantita = 0,
    this.Valutazione = 0.0,
  });
}

class StarRating extends StatefulWidget {
  final int starCount;
  final double rating;
  final Color color;
  final double size;
  final Function(double) onRatingChanged;

  StarRating({
    required this.starCount,
    required this.rating,
    required this.color,
    required this.size,
    required this.onRatingChanged,
  });

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.starCount, (index) {
        bool highlighted = index < widget.rating;
        return GestureDetector(
          onTap: () => widget.onRatingChanged(index + 1.0),
          child: Icon(
            highlighted ? Icons.star : Icons.star_border,
            color: widget.color,
            size: widget.size,
          ),
        );
      }),
    );
  }
}
