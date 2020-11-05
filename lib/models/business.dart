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
  final String location;
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
      this.location,
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

  factory Business.fromJsonFireBase(Map<String, dynamic> business) {
    List<dynamic> cats = json.decode(business['categories']) as List<dynamic>;
    List<Category> categoriesList =
        cats.map((categoryJson) => Category.fromJson(categoryJson)).toList();
    
    return Business(
      rating: business['rating'],
      price: business['price'],
      phone: business['phone'],
      id: business['id'],
      name: business['name'],
      latitude: business['latitude'],
      longitude: business['longitude'],
      distance: business['distance'],
      alias: business['alias'],
      isClosed: business['isClosed'],
      reviewCount: business['reviewCount'],
      categories: categoriesList,
      url: business['url'],
      imageUrl: business['imageUrl'],
      address1: business['address1'],
      address2: business['address2'],
      address3: business['address3'],
      city: business['city'],
      state: business['state'],
      country: business['country'],
      zip: business['zip'],
    );
  }

  factory Business.fromJsonYelp(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    return {
      'rating': this.rating,
      'price': this.price,
      'phone': this.phone,
      'id': this.id,
      'name': this.name,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'distance': this.distance,
      'alias': this.alias,
      'isClosed': this.isClosed,
      'reviewCount': this.reviewCount,
      'categories': json.encode(this.categories),
      'url': this.url,
      'imageUrl': this.imageUrl,
      'address1': this.address1,
      'address2': this.address2,
      'address3': this.address3,
      'city': this.city,
      'state': this.state,
      'country': this.country,
      'zip': this.zip,
    };
  }

  @override
  String toString() {
    return '$name';
  }
}
