import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String idToken;
  final Products prevProducts;
  final String userId;

  Products({this.idToken, this.prevProducts, this.userId});

  bool _showFavOnly = false;
  Product lastDeletedItem;
  List<Product> _items = [];
  List<Product> _authorItems = [];

  List<Product> get items {
    print('get items called');
    if (_showFavOnly) {
      return _items.where((element) => element.isFavourite).toList();
    } else {
      return [..._items];
    }
  }

  List<Product> get authorItems {
    print('get Author items called');
    return [..._authorItems];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product getProductById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void clearProducts() {
    _items = [];
  }

  Future<void> fetchAndSetData({isFilteredByUser = false}) async {
    final filterString = (isFilteredByUser) ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = 'https://shopapp-fe8ab.firebaseio.com/Products'
        '.json?auth=$idToken&$filterString';
    // try {
    //_items = [];
    //_authorItems = [];
    (isFilteredByUser)? _authorItems=[]: _items=[];
    final response = await http.get(url);
    Map<String, dynamic> loadedProducts = json.decode(response.body) as Map<String, dynamic>;
    final favUrl = 'https://shopapp-fe8ab.firebaseio.com/FavouriteStatus/$userId'
        '.json?auth=$idToken';
    final favResponse = await http.get(favUrl);
    Map<String, dynamic> loadedUserFavStatus =
        json.decode(favResponse.body) as Map<String, dynamic>;

    print(loadedUserFavStatus);

    if (loadedProducts != null) {
      loadedProducts.forEach((key, value) {
        if (isFilteredByUser) {
          _authorItems.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavourite: (loadedUserFavStatus == null) ? false : loadedUserFavStatus[key] ?? false,
          ));
        } else {
          _items.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavourite: (loadedUserFavStatus == null) ? false : loadedUserFavStatus[key] ?? false,
          ));
        }
      });
    }
    notifyListeners();
    // } catch (e) {
    //   print('error is:' + e.toString());
    //_items = prevProducts.items;
    //  throw e;
    // }
  }

  Future<void> addItem(Product item, {int index}) async {
    final url = 'https://shopapp-fe8ab.firebaseio.com/Products.json?auth=$idToken';

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': item.title,
            'price': item.price,
            'description': item.description,
            'imageUrl': item.imageUrl,
            'creatorId': userId,
            'isFavourite': item.isFavourite,
          }));
      final newItem = Product(
          id: json.decode(response.body)['name'],
          title: item.title,
          description: item.description,
          imageUrl: item.imageUrl,
          price: item.price);
      if (index != null && index < items.length) {
        _items.insert(index, newItem);
      } else {
        _items.add(newItem);
      }
      notifyListeners();
    } catch (e) {
      print('error is:' + e.toString());
      throw e;
    }
  }

  Future<void> updateItem(String itemId, Product newItem) async {
    final url = 'https://shopapp-fe8ab.firebaseio.com/Products/$itemId.json?auth=$idToken';
    await http.patch(url,
        body: json.encode({
          'title': newItem.title,
          'description': newItem.description,
          'price': newItem.price,
          'imageUrl': newItem.imageUrl,
        }));
    int index = _items.indexWhere((element) => element.id == itemId);
    if (index >= 0) {
      _items[index] = newItem;
      notifyListeners();
    } else {
      print(' item to be updated is not found ');
    }
  }

  Future<void> deleteItem(String itemId) async {
    final url = 'https://shopapp-fe8ab.firebaseio.com/Products/$itemId.json?auth=$idToken';
    int indexOfItem = _items.indexWhere((element) => element.id == itemId);
    Product item = _items[indexOfItem];

    _items.removeAt(indexOfItem);
    notifyListeners();

    await http.delete(url).then((response) {
      print('http.delete response status code:' + response.statusCode.toString());
      if (response.statusCode >= 400) {
        print('Error in  server');
        // _items.insert(indexOfItem, item); // return the deleted item if error occurred
        // notifyListeners();
        throw Exception('Error in  server');
      }
      item = null;
    }).catchError((e) {
      print('deleting error: ' + e.toString());
      _items.insert(indexOfItem, item); // return the deleted item if error occurred
      notifyListeners();
      throw e;
    });
  }
}
