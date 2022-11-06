class CartModel {
  String uid;
  final int id;
  final String productId;
  final String vendorId;
  String? title;
  String? subtitle;
  String? photo;
  int? selectedQuantity;
  String? unitTag;
  double? initialPrice;
  double? productPrice;

  CartModel({
    required this.uid,
    required this.id,
    required this.productId,
    required this.vendorId,
    required this.title,
    required this.subtitle,
    required this.photo,
    required this.selectedQuantity,
    required this.unitTag,
    required this.initialPrice,
    required this.productPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      uid: json['uid'],
      id: json['id'],
      productId: json['productId'],
      vendorId: json['vendorId'],
      title: json['title'],
      subtitle: json['subtitle'],
      photo: json['photo'],
      unitTag: json['unitTag'],
      initialPrice: json['initialPrice'],
      productPrice: json['productPrice'],
      selectedQuantity: json['selectedQuantity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'id': id,
        'productId': productId,
        'vendorId': vendorId,
        'title': title,
        'subtitle': subtitle,
        'photo': photo,
        'unitTag': unitTag,
        'initialPrice': initialPrice,
        'productPrice': productPrice,
        'selectedQuantity': selectedQuantity,
      };
}
