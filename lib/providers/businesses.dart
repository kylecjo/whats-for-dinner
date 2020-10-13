import '../models/business.dart';
import 'package:flutter/foundation.dart';

class Businesses with ChangeNotifier {
  List<Business> _businesses = [];
  List<Business> _hidden = [];
  List<Business> _search = [];

  List<Business> get businesses {
    return [..._businesses];
  }

  List<Business> get hidden {
    return [..._hidden];
  }

  List<Business> get search {
    return [..._search];
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



  Business findById(String id) {
    return _businesses.where((business) => business.id == id) as Business;
  }

}
