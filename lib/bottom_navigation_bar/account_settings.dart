import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettings();
}

void signUserOut() {
  FirebaseAuth.instance.signOut();
}

class _AccountSettings extends State<AccountSettings> {
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