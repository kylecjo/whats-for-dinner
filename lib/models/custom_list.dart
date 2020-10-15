import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:whats_for_dinner/models/business.dart';

class CustomList {
  final String id;
  final String name;
  List<Business> businesses = [];

  // CustomList({@required this.id, @required this.name});
  CustomList({@required this.id, @required this.name, @required this.businesses});

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'businesses': json.encode(this.businesses),
    };
  }

  factory CustomList.fromJson(Map<String, dynamic> data) {
    List<dynamic> list = json.decode(data['businesses']) as List<dynamic>;
    List<Business> businessList = list.map((i) => Business.fromJsonFireBase(i)).toList();

    return CustomList(
      id: data['id'],
      name: data['name'],
      businesses: businessList,
    );


  }
}
