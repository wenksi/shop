import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  static const url = 'https://tutorial-shop-a3ad2.firebaseio.com';

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavoriteValue(bool newValue) {
    this.isFavorite = newValue;
    this.notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    final oldStatus = isFavorite;
    final authString = '?auth=$token';
    this.isFavorite = !this.isFavorite;
    this.notifyListeners();
    try {
      final response = await http.put(url + '/userFavorites/$userId/$id.json$authString',
          body: json.encode(this.isFavorite));
      if (response.statusCode >= 400) {
        this._setFavoriteValue(oldStatus);
      }
    } catch (error) {
      this._setFavoriteValue(oldStatus);
    }
  }
}
