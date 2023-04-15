import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:marketshop_app/account_page.dart';
import 'firebase_options.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    Scaffold(
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  labelText: 'Username',
                  icon: Icon(Icons.account_box),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  labelText: 'Password',
                  icon: Icon(Icons.visibility_off),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                style: TextButton.styleFrom(
                    side: const BorderSide(width: 1.0),
                    textStyle: const TextStyle(fontSize: 15),
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )
                ),
                onPressed: () {},
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    ),

    ListView(
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
    ),

    const Text(
      'Index : Lista Prodotti',
      style: optionStyle,
    ),

    Container(

    ),

  ];



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'INPUT',
                ),
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.room),
            label: 'Market Vicini',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Lista Prodotti',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey[800],
        onTap: _onItemTapped,
      ),
    );
  }
// prova commit
}