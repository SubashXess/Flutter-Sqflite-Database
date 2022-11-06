// ignore_for_file: avoid_print

import 'package:addtocart_with_provider/database/db_helper.dart';
import 'package:addtocart_with_provider/models/cart_model.dart';
import 'package:addtocart_with_provider/models/product_model.dart';
import 'package:addtocart_with_provider/providers/cart_provider.dart';
import 'package:addtocart_with_provider/services/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.id, required this.index});

  final String id;
  final int index;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<List<ProductModel>>? product;

  // Database
  DBHelper? dbHelper = DBHelper();

  // Variables
  bool isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    product = Services.getSingleProduct(widget.id);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CartProvider>(context, listen: false);
    });
  }

  // bool checkItemAddedToCart(id) {
  //   return cartItems.indexWhere((element) => element.productId == id) > -1;
  // }

  final String uid = 'USER100';
  final String vendorId = 'VEN101';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print('reload');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Page'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20.0,
          ),
        ),
      ),
      body: FutureBuilder<List<ProductModel>>(
          future: product,
          builder: (context, snap) {
            // bool isAdded = checkItemAddedToCart(widget.id);

            print('object');
            if (!snap.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: size.width,
                          height: size.height * 0.2,
                          child: Stack(
                            fit: StackFit.passthrough,
                            children: [
                              Card(
                                margin: EdgeInsets.zero,
                                elevation: 0.0,
                                color: Colors.black.withOpacity(0.04),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: CachedNetworkImage(
                                  imageUrl: snap.data![0].spImg.toString(),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ClipOval(
                                    child: Material(
                                      color: Colors.deepPurple.shade200,
                                      elevation: 0.0,
                                      child: InkWell(
                                        onTap: () {},
                                        child: const SizedBox(
                                          width: 34.0,
                                          height: 34.0,
                                          child: Icon(
                                            Icons.favorite_border_rounded,
                                            color: Colors.white,
                                            size: 16.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 16.0, left: 16.0, bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              snap.data![0].spName.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              snap.data![0].subTitle.toString(),
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "\u{20B9}${double.parse(snap.data![0].discountPrice.toString()).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 16.0),
                                Text(
                                  "\u{20B9}${double.parse(snap.data![0].basePrice.toString()).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const Spacer(),
                                Consumer<CartProvider>(
                                    builder: (context, value, child) {
                                  return MaterialButton(
                                    onPressed: () {
                                      dbHelper!
                                          .insertToDB(
                                        CartModel(
                                          uid: uid,
                                          id: widget.index,
                                          productId:
                                              snap.data![0].pId.toString(),
                                          vendorId: vendorId,
                                          title: snap.data![0].spName,
                                          subtitle: snap.data![0].subTitle,
                                          photo: snap.data![0].spImg.toString(),
                                          selectedQuantity: 1,
                                          unitTag: snap.data![0].size,
                                          initialPrice: double.parse(snap
                                              .data![0].discountPrice
                                              .toString()),
                                          productPrice: double.parse(snap
                                              .data![0].discountPrice
                                              .toString()),
                                        ),
                                      )
                                          .then((_) {
                                        print('Product is added to cart');
                                        value.addTotalPrice(double.parse(snap
                                            .data![0].discountPrice
                                            .toString()));
                                        value.addCounter();
                                        setState(() {
                                          isAddingToCart =
                                              !isAddingToCart; // true
                                        });
                                      }).onError((error, stackTrace) {
                                        print('Error $error');
                                        setState(() {
                                          isAddingToCart = false;
                                        });
                                      });
                                    },
                                    color: isAddingToCart
                                        ? Colors.deepPurple.shade50
                                        : Colors.deepPurple,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0)),
                                    elevation: 0.0,
                                    highlightElevation: 0.0,
                                    minWidth: size.width / 2.6,
                                    height: 52.0,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    splashColor: Colors.white24,
                                    highlightColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    visualDensity: const VisualDensity(
                                        horizontal: -4.0, vertical: -4.0),
                                    child: isAddingToCart
                                        ? const Text(
                                            'Go To Cart',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600),
                                          )
                                        : Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text(
                                                'Add To Cart',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(width: 6.0),
                                              Icon(
                                                Icons.shopping_cart_rounded,
                                                size: 16.0,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                  );
                                }),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'Desciption',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              snap.data![0].spDesc.toString(),
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
