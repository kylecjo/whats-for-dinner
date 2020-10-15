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

  Future<void> addFavorite(Business business) async {
    final url = '${APIKeys.firebase}/favorites.json?auth=$authToken';
    try {
      await http.post(
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

  Future<void> removeFavorite(Business business) async {
    final url =
        '${APIKeys.firebase}/favorites.json?orderBy="name"&equalTo="${business.name}"&limitToFirst=1?auth=$authToken';
    try {
      final response = await http.get(url);
      Map<String, dynamic> map =
          json.decode(response.body) as Map<String, dynamic>;
      String docId = map.keys.first;
      String deleteUrl = '${APIKeys.firebase}/favorites/$docId.json';
      await http.delete(deleteUrl);
      _favorites.removeWhere((element) => element.id == business.id);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> fetchAndSetFavorites() async {
    final url = '${APIKeys.firebase}/favorites.json?auth=$authToken';
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
