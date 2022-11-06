// ignore_for_file: avoid_print

import 'package:addtocart_with_provider/models/product_model.dart';
import 'package:addtocart_with_provider/services/services.dart';
import 'package:flutter/foundation.dart';

class ProductProvider with ChangeNotifier {
  final Services _services = Services();
  bool isLoading = false;
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  Future<void> getProductsList() async {
    isLoading = true;
    final List<ProductModel> response = await _services.getProduct();
    _products = response;
    isLoading = false;
    notifyListeners();
  }
}
