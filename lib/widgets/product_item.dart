import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl as String,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).cardColor,
              onPressed: () {
                product.toggleFavoriteStatus(
                    authData.token as String, authData.userId);
              },
            ),
          ),
          title: Text(
            product.title as String,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(product.id as String, product.price as double,
                  product.title as String);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Add Item to cart",
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    cart.removeItem(product.id as String);
                  },
                ),
              ));
            },
            color: Theme.of(context).cardColor,
          ),
        ),
      ),
    );
  }
}
