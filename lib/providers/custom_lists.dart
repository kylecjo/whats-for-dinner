import 'dart:convert';

import 'package:whats_for_dinner/models/custom_list.dart';
import 'package:whats_for_dinner/services/api_keys.dart';

import '../models/business.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class CustomLists with ChangeNotifier {
  List<CustomList> _customLists;
  final String authToken;
  var uuid = Uuid();

  CustomLists(this.authToken, this._customLists);

  List<CustomList> get customLists {
    return [..._customLists];
  }

  Future<void> addCustomList(String uid, String listName) async {
    // TODO need to do the error checking on this in the widget tree so you can throw an error
    CustomList customList = CustomList(id: uuid.v4(), name: listName, businesses: []);
    final url = '${APIKeys.firebase}/customLists/$uid/${customList.id}.json?auth=$authToken';
    try {
      await http.put(
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

  Future<void> addToCustomList(CustomList customList, Business business, String uid) async {
    try {
      customList.businesses.add(business);
      String customListUrl = '${APIKeys.firebase}/customLists/$uid/${customList.id}.json?auth=$authToken';
      await http.patch(customListUrl, body: json.encode(customList));
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> removeFromCustomList(String uid,
      CustomList customList, Business business) async {
    try {
      customList.businesses.removeWhere((element) => element.id == business.id);
      notifyListeners();
      String customListUrl = '${APIKeys.firebase}/customLists/$uid/${customList.id}.json?auth=$authToken';
      await http.patch(customListUrl, body: json.encode(customList));
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> removeCustomList(String uid, String id) async {
    try {
      _customLists.removeWhere((element) => element.id == id);
      notifyListeners();
      String customListUrl =  '${APIKeys.firebase}/customLists/$uid/$id.json?auth=$authToken';
      await http.delete(customListUrl);
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> fetchAndSetCustomLists(String uid) async {
    final url = '${APIKeys.firebase}/customLists/$uid.json?auth=$authToken';
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
