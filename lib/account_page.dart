import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPage();
}

void signUserOut() {
  FirebaseAuth.instance.signOut();
}

class _AccountPage extends State<AccountPage> {
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