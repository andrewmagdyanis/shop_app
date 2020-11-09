import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product extends ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavourite = false,
  });

  Future<void> toggleFavButton(String authToken, String userId) async {
    isFavourite = !isFavourite;
    notifyListeners();
    final url = 'https://shopapp-fe8ab.firebaseio.com/FavouriteStatus/$userId/$id'
        '.json?auth=$authToken';

    final response = await http.put(url, body: json.encode(isFavourite)).catchError((e) {
      throw e;
    });
    if (response.statusCode >= 400) {
      print('error status code greater than 400');
      //reset the old state of isFavourite (toggle it again)
      isFavourite = !isFavourite;
      notifyListeners();
    }
  }
}
