import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Orders with ChangeNotifier {
  final String idToken;
  final String userId;
  final Orders prevOrders;

  Orders({this.idToken, this.userId, this.prevOrders});

  List<OrderItemModel> _orders = [];

  List<OrderItemModel> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetData() async {
    final url = 'https://shopapp-fe8ab.firebaseio.com/Orders/$userId.json?auth=$idToken';
    try {
      _orders = [];
      final response = await http.get(url);
      Map<String, dynamic> loadedOrders = json.decode(response.body) as Map<String, dynamic>;
      if (loadedOrders != null) {
        loadedOrders.forEach((key, value) {
          _orders.add(OrderItemModel(
            id: key,
            amount: value['amount'],
            dateTime: DateTime.parse(value['dateTime']),
            cartProducts: (value['cartProducts'] as List<dynamic>).map((element) {
              return CartItemModel(
                title: element['title'],
                price: element['price'],
                id: element['id'],
                quantity: element['quantity'],
              );
            }).toList(),
          ));
        });
      }
      notifyListeners();
    } catch (e) {
      print('error is:' + e.toString());
      throw e;
    }
  }

  Future<void> addOrder(double amount, List<CartItemModel> cartProducts) async {
    final now = DateTime.now();
    final url = 'https://shopapp-fe8ab.firebaseio.com/Orders/$userId.json?auth=$idToken';

    Map<String, dynamic> cartProductsAsMap = {};
    int index = 0;
    cartProducts.forEach((element) {
      cartProductsAsMap.putIfAbsent(index.toString(), () => element.toJson());
      index++;
    });
    print(cartProductsAsMap);

    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': amount,
            'cartProducts': cartProductsAsMap,
            'dateTime': now.toIso8601String(),
          }));
      _orders.insert(
          0,
          OrderItemModel(
            id: json.decode(response.body)['name'],
            amount: amount,
            cartProducts: cartProducts,
            dateTime: now,
          ));
      notifyListeners();
    } catch (e) {
      print('Adding order error: ' + e.toString());
      throw e;
    }
  }

  void deleteOrder(id) {
    _orders.remove(id);
    notifyListeners();
  }
}

class OrderItemModel {
  final id;
  final double amount;
  final List<CartItemModel> cartProducts;
  final DateTime dateTime;

  OrderItemModel({
    @required this.id,
    @required this.amount,
    @required this.cartProducts,
    @required this.dateTime,
  });
}
