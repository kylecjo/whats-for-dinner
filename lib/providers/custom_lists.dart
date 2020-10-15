import 'dart:convert';

import 'package:whats_for_dinner/models/custom_list.dart';
import 'package:whats_for_dinner/services/api_keys.dart';

import '../models/business.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CustomLists with ChangeNotifier {
  List<CustomList> _customLists;
  final String authToken;

  CustomLists(this.authToken, this._customLists);

  List<CustomList> get customLists {
    return [..._customLists];
  }

  Future<void> addCustomList(String listName) async {
    // TODO need to do the error checking on this in the widget tree so you can throw an error
    CustomList customList = CustomList(name: listName, businesses: []);
    final url = '${APIKeys.firebase}/customLists.json?auth=$authToken';
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
        '${APIKeys.firebase}/customLists.json?auth=$authToken';
    try {
      final response = await http.get(url);
      customList.businesses.add(business);
      Map<String, dynamic> map =
          json.decode(response.body) as Map<String, dynamic>;
      String docId = map.keys.firstWhere((element) => map[element]['name'] == customList.name);
      String customListUrl = '${APIKeys.firebase}/customLists/$docId.json?auth=$authToken';
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
        '${APIKeys.firebase}/customLists.json?auth=$authToken';
    try {
      customList.businesses.removeWhere((element) => element.id == business.id);
      _customLists
          .singleWhere((element) => element.name == customList.name)
          .businesses
          .removeWhere((element) => element.id == business.id);
      notifyListeners();
      String customListUrl = await getCustomListUrl(customList.name, url);
      await http.patch(customListUrl, body: json.encode(customList));
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> removeCustomList(String name) async {
    String url =
        '${APIKeys.firebase}/customLists.json?auth=$authToken';
    try {
      _customLists.removeWhere((element) => element.name == name);
      notifyListeners();
      String customListUrl = await getCustomListUrl(name, url);
      await http.delete(customListUrl);
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<String> getCustomListUrl(String name, String url) async {
    final response = await http.get(url);

    Map<String, dynamic> map =
        json.decode(response.body) as Map<String, dynamic>;
    String docId = map.keys.firstWhere((element) => map[element]['name'] == name);
    return  '${APIKeys.firebase}/customLists/$docId.json?auth=$authToken';
  }

  Future<void> fetchAndSetCustomLists() async {
    final url = '${APIKeys.firebase}/customLists.json?auth=$authToken';
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
}
