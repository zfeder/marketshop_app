import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';


class ItemBar extends StatefulWidget {
  const ItemBar({super.key});

  @override
  State<ItemBar> createState() => _ItemBar();
}

void signUserOut() {
  FirebaseAuth.instance.signOut();
}

class _ItemBar extends State<ItemBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const IconButton(
        onPressed: signUserOut,
        icon: Icon(Icons.logout),
      ),
    );
  }

}