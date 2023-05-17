import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'dart:developer';

class ItemBar extends StatefulWidget {
  const ItemBar({super.key});

  @override
  State<ItemBar> createState() => _ItemBar();
}

void signUserOut() {
  FirebaseDatabase.instance.reference().child("users").push().set({
    "name": "John Smith",
    "age": 30
  });

  log('SONO DENTROOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO');
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