import '../providers/cart.dart' show Cart;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'card_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text("\$${cart.totalAmount.toStringAsFixed(2)}"),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id as String,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price as double,
                cart.items.values.toList()[i].quantity as int,
                cart.items.values.toList()[i].title as String),
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isloading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        // textColor: Theme.of(context).primaryColor,
        onPressed: (widget.cart.totalAmount <= 0 || _isloading)
            ? null
            : () async {
                setState(() {
                  _isloading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);
                setState(() {
                  _isloading = false;
                });

                widget.cart.clear();
              },
        child: _isloading ? CircularProgressIndicator() : Text("Order Now"));
  }
}
