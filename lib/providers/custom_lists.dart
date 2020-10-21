import 'dart:convert';

import 'package:whats_for_dinner/models/custom_list.dart';
import 'package:whats_for_dinner/models/http_exception.dart';
import 'package:whats_for_dinner/services/api_keys.dart';

import '../models/business.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class CustomLists with ChangeNotifier {
  // TODO loading screens on fetching favorites and custom lists
  // TODO drag down to update custom lists
  List<CustomList> _customLists;
  final String authToken;
  var uuid = Uuid();

  CustomLists(this.authToken, this._customLists);

  List<CustomList> get customLists {
    return [..._customLists];
  }

  Future<void> addCustomList(String uid, String email, String listName) async {
    // TODO need to do the error checking on this in the widget tree so you can throw an error
    CustomList customList = CustomList(
        id: uuid.v4(), uid: uid, email: email, name: listName, businesses: []);
    final url =
        '${APIKeys.firebase}/customLists/${customList.id}/items.json?auth=$authToken';

    try {
      await http.patch(
        '${APIKeys.firebase}/users/$uid/lists.json?auth=$authToken',
        body: json.encode({customList.id: true}),
      );
      await http.put(
        '${APIKeys.firebase}/customLists/${customList.id}.json?auth=$authToken',
        body: json.encode({'admin': uid}),
      );
      final response = await http.put(
        url,
        body: json.encode(customList),
      );
      print(response.body);
    } on Exception catch (e) {
      print(e);
      throw e;
    }

    _customLists.add(customList);
    notifyListeners();
  }

  Future<void> addToCustomList(
      CustomList customList, Business business, String uid) async {
    try {
      customList.businesses.add(business);
      String customListUrl =
          '${APIKeys.firebase}/customLists/${customList.id}/items.json?auth=$authToken';
      await http.patch(customListUrl, body: json.encode(customList));
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> removeFromCustomList(
      String uid, CustomList customList, Business business) async {
    try {
      customList.businesses.removeWhere((element) => element.id == business.id);
      notifyListeners();
      String customListUrl =
          '${APIKeys.firebase}/customLists/${customList.id}/items.json?auth=$authToken';
      final response =
          await http.patch(customListUrl, body: json.encode(customList));
      print(response.body);
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> removeCustomList(
      String authUid, String id, String listUid) async {
    try {
      _customLists.removeWhere((element) => element.id == id);
      notifyListeners();
      //if user is owner of list then delete list from all users' lists and the list itself
      if (authUid == listUid) {
        final members = await http.get(
            '${APIKeys.firebase}/customLists/$id/members.json?auth=$authToken');
        final membersData = json.decode(members.body) as Map<String, dynamic>;
        membersData.keys.forEach((key) async {
          await http.delete(
            '${APIKeys.firebase}/users/$key/lists/$id.json?auth=$authToken',
          );
        });
        await http
            .delete('${APIKeys.firebase}/customLists/$id.json?auth=$authToken');
        await http.delete(
            '${APIKeys.firebase}/users/$authUid/lists/$id.json?auth=$authToken');
      } else {
        await http.delete(
            '${APIKeys.firebase}/customLists/$id/members/$authUid.json?auth=$authToken');
        await http.delete(
            '${APIKeys.firebase}/users/$authUid/lists/$id.json?auth=$authToken');
      }

      //otherwise just delete the list from the users lists and the user from members

    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> shareList(String uid, CustomList myList, String email) async {
    // first have to take email and find the correct userid on the server
    final url = '${APIKeys.firebase}/users.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final shareUid = responseData.keys.firstWhere(
          (element) => responseData[element]['email'] == email,
          orElse: null);
      print(shareUid);
      if (shareUid != null) {
        final members = await http.get(
          '${APIKeys.firebase}/customLists/${myList.id}/members.json?auth=$authToken',
        );
        final membersData = json.decode(members.body) as Map<String, dynamic>;

        // if the shareUid is not in members then add it otherwise, throw an exception
        if (shareUid == myList.uid) {
          throw HttpException('This list belongs to you');
        } else if (membersData == null ||
            !membersData.keys.contains(shareUid)) {
          await http.patch(
            '${APIKeys.firebase}/customLists/${myList.id}/members.json?auth=$authToken',
            body: json.encode({'$shareUid': true}),
          );
          await http.patch(
            '${APIKeys.firebase}/users/$shareUid/lists.json?auth=$authToken',
            body: json.encode({myList.id: true}),
          );
        } else if(membersData.keys.contains(shareUid)) {
          throw HttpException('List is already shared with $email');
        }
      } 
    } catch (e) {
      throw e;
    }

    // add that user id to the lists' member thing
    // give permission for all users in that member thing to read write onto that list
  }

  Future<void> fetchAndSetCustomLists(String uid) async {
    final url = '${APIKeys.firebase}/users/$uid/lists.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final allowedLists =
          json.decode(response.body) as Map<String, dynamic> ?? {};
      final List<CustomList> loadedCustomLists = [];

      if (allowedLists.keys.isNotEmpty) {
        allowedLists.keys.forEach((id) async {
          final list = await http.get(
              '${APIKeys.firebase}/customLists/$id/items.json?auth=$authToken');
          // print(list.body);
          final listData = json.decode(list.body) as Map<String, dynamic>;
          if (listData != null) {
            loadedCustomLists.add(CustomList.fromJson(listData));
          }
        });
      }

      _customLists = loadedCustomLists;
      notifyListeners();
    } on Exception catch (e) {
      throw (e);
    }
  }
}
