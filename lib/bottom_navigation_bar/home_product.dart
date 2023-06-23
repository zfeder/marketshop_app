import 'package:flutter/material.dart';
import 'package:marketshop_app/bottom_navigation_bar/product_list_market.dart';
import 'package:path/path.dart' as path;

class HomeProduct extends StatelessWidget {
  const HomeProduct({Key? key});


  void goToProductList(BuildContext context, String imagePath) {
    String imageNameWithoutExtension = path.basenameWithoutExtension(imagePath);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductListMarket(imageNameWithoutExtension.capitalize())
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome back',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16), // Spazio vuoto tra il testo e la griglia
            GridView.count(
              crossAxisCount: 3, // Numero di colonne nella griglia
              crossAxisSpacing: 8, // Spaziatura orizzontale tra i riquadri
              mainAxisSpacing: 8, // Spaziatura verticale tra i riquadri
              padding: const EdgeInsets.all(8), // Spazio esterno della griglia
              shrinkWrap: true, // Adatta la griglia alle dimensioni dei suoi elementi
              physics: const NeverScrollableScrollPhysics(), // Disabilita lo scorrimento della griglia
              children: [
                _buildGridItem(context, 'assets/images/carrefour.jpg'),
                _buildGridItem(context, 'assets/images/despar.jpg'),
                _buildGridItem(context, 'assets/images/ins.png'),
                _buildGridItem(context, 'assets/images/crai.jpg'),
                _buildGridItem(context, 'assets/images/lidl.png'),
                _buildGridItem(context, 'assets/images/eurospin.jpg'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String imagePath) {
    return InkWell(
      onTap: () {
        goToProductList(context, imagePath);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue, // Colore di sfondo del riquadro
          borderRadius: BorderRadius.circular(8), // Bordi arrotondati
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
