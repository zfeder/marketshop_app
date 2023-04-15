import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';


class StoreMarketBar extends StatefulWidget {
  const StoreMarketBar({super.key});

  @override
  State<StoreMarketBar> createState() => _StoreMarketBar();
}

class _StoreMarketBar extends State<StoreMarketBar> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
              side: const BorderSide(width: 1.0),
              textStyle: const TextStyle(fontSize: 15),
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              )
          ),
          onPressed: () {},
          child: const Text('Button 1'),
        ),
        TextButton(
          style: TextButton.styleFrom(
              side: const BorderSide(width: 1.0),
              textStyle: const TextStyle(fontSize: 15),
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              )
          ),
          onPressed: () {},
          child: const Text('Button 2'),
        ),
        TextButton(
          style: TextButton.styleFrom(
              side: const BorderSide(width: 1.0),
              textStyle: const TextStyle(fontSize: 15),
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              )
          ),
          onPressed: () {},
          child: const Text('Button 3'),
        ),
      ],
    );
  }

}