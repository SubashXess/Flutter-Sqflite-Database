import 'package:addtocart_with_provider/database/db_helper.dart';
import 'package:addtocart_with_provider/models/cart_model.dart';
import 'package:addtocart_with_provider/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  // Database Helper
  DBHelper? dbHelper = DBHelper();

  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  late Future<List<CartModel>> _cartItem;
  Future<List<CartModel>> get cartItem => _cartItem;

  late Future<List<CartModel>> _cartItemID;
  Future<List<CartModel>> get cartItemID => _cartItemID;

  Future<List<CartModel>> getData() async {
    _cartItem = dbHelper!.getCartItems();
    // notifyListeners();
    return _cartItem;
  }


  void _setPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('cart_item', _counter);
    preferences.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _counter = preferences.getInt('cart_item') ?? 0;
    _totalPrice = preferences.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  void addCounter() {
    _counter++;
    _setPreferences();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    _setPreferences();
    notifyListeners();
  }

  // dont try
  void removeAllCounterDontTry() {
    _counter = 0;
    _setPreferences();
    notifyListeners();
  }

  // dont try
  void removeAllTotalPriceDontTry() {
    _totalPrice = 0.0;
    _setPreferences();
    notifyListeners();
  }

  int getCounterValue() {
    _getPreferences();
    return _counter;
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPreferences();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    _setPreferences();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPreferences();
    return _totalPrice;
  }
}
