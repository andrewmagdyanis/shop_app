import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Build: CartScreen');
    var cart = Provider.of<Cart>(context);
    Orders ordersData = Provider.of<Orders>(context, listen: true);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: AutoSizeText('Your cart',
          maxLines: 1,
          style: TextStyle(fontSize: 30),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          wrapWords: true,
          minFontSize: 0,
          stepGranularity: 0.1,

        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Text('Total: '),
                    SizedBox(
                      width: 10,
                    ),
                    Chip(
                      label: Text(cart.total.toStringAsFixed(2)),
                      backgroundColor: Colors.grey,
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                    ),
                    Spacer(),
                    OrderNowButton(ordersData: ordersData, cart: cart)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) => CartItem(
                productId: cart.items.keys.toList()[index],
                title: cart.items.values.toList()[index].title,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
                id: cart.items.values.toList()[index].id,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderNowButton extends StatefulWidget {
  const OrderNowButton({
    Key key,
    @required this.ordersData,
    @required this.cart,
  }) : super(key: key);

  final Orders ordersData;
  final Cart cart;

  @override
  _OrderNowButtonState createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.items.length<=0 || isLoading)?null:() async {
        setState(() {
          isLoading = true;
        });
        await widget.ordersData.addOrder(widget.cart.total, widget.cart.items.values.toList());
        widget.cart.clearCart();
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => OrderScreen()),
        );
      },
      color: Colors.yellow[300],
      child: isLoading? Center(child: Container(
          padding: EdgeInsets.all(5), child: CircularProgressIndicator()),): Text(
        'Order now',
        style: TextStyle(color: Colors.yellow[900]),
      ),
    );
  }
}
