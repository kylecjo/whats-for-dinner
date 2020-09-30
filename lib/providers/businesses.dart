import '../models/business.dart';
import 'package:flutter/foundation.dart';


class Businesses with ChangeNotifier{ 
  List<Business> _businesses = [];
  List<Business> _hidden = [];
  List<Business> _favorites = [];
  List<Business> _search = [];

  List<Business> get businesses {
    return [..._businesses];
  }

  List<Business> get hidden {
    return [..._hidden];
  }

  List<Business> get favorites {
    return [..._favorites];
  }

  List<Business> get search {
    return [..._search];
  }

  bool isFavorite(Business business){
    for (Business b in _favorites){
      if(business.id == b.id){
        return true;
      }
    }

    return  false;
  }

  void initBusinesses(List<Business> businesses){
    _businesses = businesses;
    notifyListeners();
  }

  void initSearch(List<Business> businesses){
    _search = businesses;
    notifyListeners();
  }

  void addHidden(Business business){
    _hidden.add(business);
    notifyListeners();  
  }

  void removeHidden(Business business){
    _hidden.removeWhere((element) => element == business);
    _businesses.insert(0, business);
    notifyListeners();
  }

  void addFavorite(Business business){
    _favorites.add(business);
    notifyListeners();
  }

  void removeFavorite(Business business){
    _favorites.removeWhere((element) => element == business);
    notifyListeners();
  }

  void addSearch(Business business){
    _search.add(business);
    notifyListeners();
  }

  void removeSearch(Business business){
    _search.removeWhere((element) => element == business);
    notifyListeners();
  }

  void removeBusiness(Business businessToRemove){
    _businesses.removeWhere((business) => business == businessToRemove);
    notifyListeners();
  }



  Business findById(String id){
    return _businesses.where((business) => business.id == id) as Business;
  }

}