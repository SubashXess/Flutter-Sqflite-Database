import 'package:addtocart_with_provider/constants/constants.dart';
import 'package:addtocart_with_provider/models/product_model.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;

class Services {
  Future<List<ProductModel>> getProduct() async {
    Client client = http.Client();
    Uri uri = Uri.parse(API.product_api);
    try {
      Response response = await client.get(uri);
      if (response.statusCode == 200) {
        String json = response.body;
        return ProductModel.productModelFromJson(json);
      } else {
        return Future.error('Connection Error');
      }
    } catch (e) {
      return Future.error('Unexpected Error $e');
    }
  }

  static Future<List<ProductModel>> getSingleProduct(String id) async {
    Client client = http.Client();
    Uri uri = Uri.parse(API.product_api);
    try {
      Response response = await client.get(uri);
      if (response.statusCode == 200) {
        String json = response.body;
        return ProductModel.productModelFromJson(json).where((item) {
          final lowerId = item.pId!.toLowerCase().toString();
          return lowerId.contains(id);
        }).toList();
      } else {
        return Future.error('Connection Error');
      }
    } catch (e) {
      return Future.error('Unexpected Error $e');
    }
  }
}
