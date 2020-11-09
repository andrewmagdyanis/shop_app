import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';

class OrderItem extends StatefulWidget {
  final id;
  final double amount;
  final OrderItemModel order;

  const OrderItem({
    Key key,
    this.id,
    this.amount,
    this.order,
  }) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    List detailedList = widget.order.cartProducts
        .map((e) => Column(children: [
              Container(
                child: Card(
                  color: Colors.grey[400],
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    title: AutoSizeText(e.title,maxLines: 2,minFontSize: 10,stepGranularity: 10,
                      style: TextStyle(fontSize: 18),),
                    subtitle: AutoSizeText(e.price.toString(),maxLines: 2,minFontSize: 10,stepGranularity: 10,
                      style: TextStyle(fontSize: 18),),
                    leading: Text('x ${e.quantity}'),
                    trailing: Text((e.price * e.quantity).toString()),
                  ),
                ),
              ),

            ]))
        .toList();

    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Card(
        color: Colors.grey[200],
        child: Column(children: [
          ListTile(
            title: Text('Order of id: ${widget.id}'),
            subtitle: Text('\$${widget.amount}'),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          (_expanded)? Divider(color: Colors.black,):Container(),

          (_expanded)
              ? Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    height: min(widget.order.cartProducts.length * 25.0 + 100, 180.0),
                    child: ListView(children: detailedList),
                  ),
                )
              : Container()
        ]),
      ),
    );
  }
}
