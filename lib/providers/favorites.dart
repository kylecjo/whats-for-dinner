import 'dart:convert';

import '../services/api_keys.dart';

import '../models/business.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Favorites with ChangeNotifier {
  List<Business> _favorites;
  final String authToken;

  Favorites(this.authToken, this._favorites);

  List<Business> get favorites {
    return [..._favorites];
  }

  bool isFavorite(Business business) {
    for (Business b in _favorites) {
      if (business.alias == b.alias) {
        return true;
      }
    }

    return false;
  }

  Future<void> addFavorite(Business business, String uid) async {
    final url = '${APIKeys.firebase}/favorites/$uid/${business.id}.json?auth=$authToken';
    try {
      await http.put(
        url,
        body: json.encode(business),
      );
      _favorites.add(business);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> removeFavorite(Business business, String uid) async {
    try {
      final deleteUrl = '${APIKeys.firebase}/favorites/$uid/${business.id}.json?auth=$authToken';
      await http.delete(deleteUrl);
      _favorites.removeWhere((element) => element.id == business.id);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> fetchAndSetFavorites(String uid) async {
    final url = '${APIKeys.firebase}/favorites/$uid.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic> ?? {};
      final List<Business> loadedFavorites = [];
      if (data.isNotEmpty) {
        data.forEach((id, business) {
          loadedFavorites.add(Business.fromJsonFireBase(business));
        });
      }
      _favorites = loadedFavorites;
      notifyListeners();
    } on Exception catch (e) {
      throw (e);
    }
  }
}
