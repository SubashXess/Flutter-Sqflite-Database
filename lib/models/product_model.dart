import 'dart:convert';

class ProductModel {
  ProductModel({
    this.pId,
    this.storeId,
    this.catId,
    this.spName,
    this.subTitle,
    this.brandName,
    this.spDesc,
    this.size,
    this.spImg,
    this.basePrice,
    this.discount,
    this.discountPrice,
    this.gst,
    this.status,
  });

  String? pId;
  String? storeId;
  String? catId;
  String? spName;
  String? subTitle;
  String? brandName;
  String? spDesc;
  String? size;
  String? spImg;
  String? basePrice;
  String? discount;
  String? discountPrice;
  String? gst;
  String? status;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        pId: json["p_id"],
        storeId: json["store_id"],
        catId: json["cat_id"],
        spName: json["sp_name"],
        subTitle: json["sub_title"],
        brandName: json["brand_name"],
        spDesc: json["sp_desc"],
        size: json["size"],
        spImg: json["sp_img"],
        basePrice: json["base_price"],
        discount: json["discount"],
        discountPrice: json["discount_price"],
        gst: json["gst"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "p_id": pId,
        "store_id": storeId,
        "cat_id": catId,
        "sp_name": spName,
        "sub_title": subTitle,
        "brand_name": brandName,
        "sp_desc": spDesc,
        "size": size,
        "sp_img": spImg,
        "base_price": basePrice,
        "discount": discount,
        "discount_price": discountPrice,
        "gst": gst,
        "status": status,
      };

  static List<ProductModel> productModelFromJson(String str) =>
      List<ProductModel>.from(
          json.decode(str).map((x) => ProductModel.fromJson(x)));

  static String productModelToJson(List<ProductModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
