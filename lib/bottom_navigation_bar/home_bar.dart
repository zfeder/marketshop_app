import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';


class HomeBar extends StatefulWidget {
  const HomeBar({super.key});

  @override
  State<HomeBar> createState() => _HomeBar();
}

void signUserOut() {
  FirebaseAuth.instance.signOut();
}

class _HomeBar extends State<HomeBar> {
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