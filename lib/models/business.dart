import 'dart:convert';

import 'category.dart';

class Business {
  final double rating;
  final String price;
  final String phone;
  final String id;
  final String name;

  final double latitude;
  final double longitude;
  final double distance;

  final String alias;
  final bool isClosed;
  final int reviewCount;
  final List<Category> categories;

  final String url;
  final String imageUrl;

  final String address1;
  final String address2;
  final String address3;
  final String city;
  final String state;
  final String country;
  final String zip;

  Business(
      {this.rating,
      this.price,
      this.phone,
      this.id,
      this.name,
      this.latitude,
      this.longitude,
      this.distance,
      this.alias,
      this.isClosed,
      this.reviewCount,
      this.categories,
      this.url,
      this.imageUrl,
      this.address1,
      this.address2,
      this.address3,
      this.city,
      this.state,
      this.country,
      this.zip});

  factory Business.fromJson(Map<String, dynamic> json) {
    String arrayObjsText = jsonEncode(json['categories']);
    var categoryObjsJson = jsonDecode(arrayObjsText) as List;
    List<Category> _categoriesList = categoryObjsJson
        .map((categoryJson) => Category.fromJson(categoryJson))
        .toList();

    return Business(
      rating: json['rating'],
      price: json['price'],
      phone: json['phone'],
      id: json['id'],
      name: json['name'],
      latitude: json['coordinates']['latitude'],
      longitude: json['coordinates']['longitude'],
      distance: json['distance'],
      alias: json['alias'],
      isClosed: json['is_closed'],
      reviewCount: json['review_count'],
      categories: _categoriesList,
      url: json['url'],
      imageUrl: json['image_url'],
      address1: json['location']['address1'],
      address2: json['location']['address2'],
      address3: json['location']['address3'],
      city: json['location']['city'],
      state: json['location']['state'],
      country: json['location']['country'],
      zip: json['location']['zip_code'],
    );
  }

  @override
  String toString() {
    return '$name';
  }
}
