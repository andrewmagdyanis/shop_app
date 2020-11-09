import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final id;
  final productId;
  final price;
  final quantity;
  final title;

  const CartItem({
    Key key,
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(id),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('please confirm deleting this item'),
                actions: [
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                  ),
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                  ),
                ],
              );
            });
      },
      background: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.red,
          padding: EdgeInsets.only(right: 10),
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.deleteItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: FittedBox(
                child: Text(
                  '\$${price}',
                  style: TextStyle(),
                ),
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total: ${price * quantity}'),
          trailing: Text(' ${quantity} x'),
        ),
      ),
    );
  }
}
