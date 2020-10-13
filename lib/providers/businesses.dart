import 'dart:convert';

import 'package:whats_for_dinner/models/custom_list.dart';
import 'package:whats_for_dinner/services/api_keys.dart';

import '../models/business.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Businesses with ChangeNotifier {
  List<Business> _businesses = [];
  List<Business> _hidden = [];
  List<Business> _favorites = [];
  List<Business> _search = [];
  List<CustomList> _customLists = [];

  List<Business> get businesses {
    return [..._businesses];
  }

  List<Business> get hidden {
    return [..._hidden];
  }

  List<Business> get search {
    return [..._search];
  }

  List<CustomList> get customLists {
    return [..._customLists];
  }

  bool isFavorite(Business business) {
    for (Business b in _favorites) {
      if (business.alias == b.alias) {
        return true;
      }
    }

    return false;
  }

  void initBusinesses(List<Business> businesses) {
    _businesses = businesses;
    notifyListeners();
  }

  void initSearch(List<Business> businesses) {
    _search = businesses;
    notifyListeners();
  }

  void addBusiness(Business business) {
    _businesses.add(business);
    notifyListeners();
  }

  void addHidden(Business business) {
    _hidden.add(business);
    notifyListeners();
  }

  void removeHidden(Business business) {
    _hidden.removeWhere((element) => element == business);
    _businesses.insert(0, business);
    notifyListeners();
  }


  void addSearch(Business business) {
    _search.add(business);
    notifyListeners();
  }

  void removeSearch(Business business) {
    _search.removeWhere((element) => element.id == business.id);
    notifyListeners();
  }

  void removeBusiness(Business businessToRemove) {
    _businesses.removeWhere((business) => business.id == businessToRemove.id);
    notifyListeners();
  }

  Future<void> addCustomList(String listName) async {
    // TODO need to do the error checking on this in the widget tree so you can throw an error
    CustomList customList = CustomList(name: listName, businesses: []);
    const url = '${APIKeys.firebase}/customLists.json';
    try {
      await http.post(
        url,
        body: json.encode(customList),
      );
    } on Exception catch (e) {
      print(e);
      throw e;
    }

    _customLists.add(customList);
    notifyListeners();
  }

  Future<void> addToCustomList(CustomList customList, Business business) async {
    String url =
        '${APIKeys.firebase}/customLists.json?orderBy="name"&equalTo="${customList.name}"&limitToFirst=1';
    try {
      final response = await http.get(url);
      customList.businesses.add(business);
      Map<String, dynamic> map =
          json.decode(response.body) as Map<String, dynamic>;
      String docId = map.keys.first;
      String customListUrl = '${APIKeys.firebase}/customLists/$docId.json';
      await http.patch(customListUrl, body: json.encode(customList));
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> removeFromCustomList(
      CustomList customList, Business business) async {
    String url =
        '${APIKeys.firebase}/customLists.json?orderBy="name"&equalTo="${customList.name}"&limitToFirst=1';
    try {
      customList.businesses.removeWhere((element) => element.id == business.id);
      _customLists
          .singleWhere((element) => element.name == customList.name)
          .businesses
          .removeWhere((element) => element.id == business.id);
      notifyListeners();
      final response = await http.get(url);

      Map<String, dynamic> map =
          json.decode(response.body) as Map<String, dynamic>;
      String docId = map.keys.first;
      String customListUrl = '${APIKeys.firebase}/customLists/$docId.json';
      await http.patch(customListUrl, body: json.encode(customList));
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  void removeCustomList(String name) {
    _customLists.removeWhere((element) => element.name == name);
    notifyListeners();
  }

  Business findById(String id) {
    return _businesses.where((business) => business.id == id) as Business;
  }

  Future<void> fetchAndSetCustomLists() async {
    const url = '${APIKeys.firebase}/customLists.json';
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic> ?? {};
      final List<CustomList> loadedCustomLists = [];

      if (data.isNotEmpty) {
        data.forEach((id, customListJson) {
          loadedCustomLists.add(CustomList.fromJson(customListJson));
        });
      }

      _customLists = loadedCustomLists;
      notifyListeners();
    } on Exception catch (e) {
      throw (e);
    }
  }

  Future<void> fetchAndSetFavorites() async {
    const url = '${APIKeys.firebase}/favorites.json';
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
