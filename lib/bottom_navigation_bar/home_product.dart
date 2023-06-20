import 'package:flutter/material.dart';

class HomeProduct extends StatelessWidget {
  const HomeProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome to Home Product!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
