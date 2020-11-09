import 'dart:convert';

import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  Map<String, CartItemModel> _items = {};
  final String idToken;
  final Cart prevCart;

  Cart({this.idToken, this.prevCart });

  Map<String, CartItemModel> get items {
    return {..._items};
  }

  double get total {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  int get cartCount {
    return _items.length;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // increase quantity:
      _items.update(
          productId,
          (previousValue) => CartItemModel(
                id: previousValue.id,
                title: previousValue.title,
                price: previousValue.price,
                quantity: previousValue.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItemModel(
                id: DateTime.now(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void deleteItem(String productId) {
    // used in dismissed by swiping
    _items.remove(productId);
    notifyListeners();
  }

  void deleteSingleQuantity(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId].quantity > 1) {
        _items[productId] = CartItemModel(
          id: _items[productId].id,
          title: _items[productId].title,
          price: _items[productId].price,
          quantity: _items[productId].quantity - 1,
        );
      } else {
        deleteItem(productId);
      }
    }
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}

class CartItemModel {
  final id;
  final double price;
  final String title;
  final int quantity;

  CartItemModel({
    this.quantity,
    this.id,
    this.price,
    this.title,
  });

  Map toJson() =>
      {'id': id.toString(), 'price': price, 'title': title.toString(), 'quantity': quantity};
}
