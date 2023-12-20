import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'favourite_product_list.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void goToFavourite() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavouriteProductList(),
      ),
    );
  }

  void closeAccount() {
    // Aggiungi qui la logica per chiudere l'account utente
    // Esempio: FirebaseAuth.instance.currentUser?.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Benvenuto, ${user.displayName}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          goToFavourite();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        child: const Text('Prodotti preferiti'),
                      ),
                    ],
                  );
                } else {
                  return const Text('Utente non identificato');
                }
              },
            ),
            const SizedBox(height: 16),
            Expanded(child: Container()), // Spazio vuoto per spingere i pulsanti in basso
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: signUserOut,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: const Text('Logout'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: closeAccount,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // Colore rosso per il bottone di chiusura dell'account
                    ),
                    child: const Text('Chiudi account'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Settings Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AccountSettings(),
    );
  }
}
