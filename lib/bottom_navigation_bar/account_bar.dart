import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';


class AccountBar extends StatefulWidget {
  const AccountBar({super.key});

  @override
  State<AccountBar> createState() => _AccountBar();
}

void signUserOut() {
  FirebaseAuth.instance.signOut();
}

class _AccountBar extends State<AccountBar> {
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