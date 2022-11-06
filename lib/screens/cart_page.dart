// ignore_for_file: avoid_print

import 'package:addtocart_with_provider/database/db_helper.dart';
import 'package:addtocart_with_provider/models/cart_model.dart';
import 'package:addtocart_with_provider/providers/cart_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ScrollController _scrollController = ScrollController();
  DBHelper? dbHelper = DBHelper();

  final String uid = 'USER100';
  final String vendorId = 'VEN101';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final cartItem = Provider.of<CartProvider>(context);

    print('reload cart page');
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20.0,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          fit: StackFit.expand,
          children: [
            FutureBuilder<List<CartModel>>(
                future: dbHelper!.getCartItems(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.separated(
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 10.0),
                              cacheExtent: 100.0,
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: size.width,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: size.width / 4,
                                            height: 100.0,
                                            child: Card(
                                              margin: EdgeInsets.zero,
                                              color: Colors.black
                                                  .withOpacity(0.04),
                                              elevation: 0.0,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              child: CachedNetworkImage(
                                                imageUrl: snapshot
                                                    .data![index].photo
                                                    .toString(),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  snapshot.data![index].title
                                                      .toString(),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                                const SizedBox(height: 6.0),
                                                Text(
                                                  snapshot.data![index].subtitle
                                                      .toString(),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 13.0,
                                                  ),
                                                ),
                                                const SizedBox(height: 6.0),
                                                Text(
                                                  '\u{20B9}${double.parse(snapshot.data![index].initialPrice.toString()).toStringAsFixed(2).toString()}',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Consumer<CartProvider>(
                                              builder: (context, value, child) {
                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Visibility(
                                                  visible: snapshot.data![index]
                                                              .selectedQuantity! >
                                                          1
                                                      ? true
                                                      : false,
                                                  replacement: MaterialButton(
                                                    onPressed: () {
                                                      dbHelper!
                                                          .deleteItemFromCart(
                                                        int.parse(snapshot
                                                            .data![index]
                                                            .productId),
                                                      );
                                                      value.removeCounter();
                                                      value.removeTotalPrice(
                                                          double.parse(snapshot
                                                              .data![index]
                                                              .productPrice
                                                              .toString()));
                                                      setState(() {});
                                                    },
                                                    color: Colors.red.shade300,
                                                    textColor: Colors.white,
                                                    shape: const CircleBorder(),
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    padding: EdgeInsets.zero,
                                                    elevation: 0.0,
                                                    highlightElevation: 0.0,
                                                    visualDensity:
                                                        const VisualDensity(
                                                            horizontal: -4.0,
                                                            vertical: -4.0),
                                                    height: 48.0,
                                                    minWidth: 48.0,
                                                    child: const Icon(
                                                        Icons.delete,
                                                        size: 16.0),
                                                  ),
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                      int quantity = snapshot
                                                          .data![index]
                                                          .selectedQuantity!;
                                                      double price =
                                                          double.parse(snapshot
                                                              .data![index]
                                                              .initialPrice!
                                                              .toStringAsFixed(
                                                                  2)
                                                              .toString());
                                                      quantity--;
                                                      double? newPrice =
                                                          price * quantity;

                                                      dbHelper!
                                                          .updateQuantity(
                                                        CartModel(
                                                          uid: uid,
                                                          id: index,
                                                          productId: snapshot
                                                              .data![index]
                                                              .productId,
                                                          vendorId: vendorId,
                                                          title: snapshot
                                                              .data![index]
                                                              .title,
                                                          subtitle: snapshot
                                                              .data![index]
                                                              .subtitle,
                                                          photo: snapshot
                                                              .data![index]
                                                              .photo,
                                                          selectedQuantity:
                                                              quantity,
                                                          unitTag: snapshot
                                                              .data![index]
                                                              .unitTag,
                                                          initialPrice: snapshot
                                                              .data![index]
                                                              .initialPrice,
                                                          productPrice:
                                                              newPrice,
                                                        ),
                                                      )
                                                          .then((_) {
                                                        newPrice = 0.0;
                                                        quantity = 0;
                                                        value.removeCounter();
                                                        value.removeTotalPrice(
                                                            snapshot
                                                                .data![index]
                                                                .initialPrice!);
                                                        setState(() {});
                                                      }).onError((error,
                                                              stackTrace) {
                                                        print('Error : $error');
                                                      });
                                                    },
                                                    color: Colors
                                                        .deepPurple.shade50,
                                                    textColor: Colors
                                                        .deepPurple.shade800,
                                                    shape: const CircleBorder(),
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    padding: EdgeInsets.zero,
                                                    elevation: 0.0,
                                                    highlightElevation: 0.0,
                                                    visualDensity:
                                                        const VisualDensity(
                                                            horizontal: -4.0,
                                                            vertical: -4.0),
                                                    height: 48.0,
                                                    minWidth: 48.0,
                                                    child: const Icon(
                                                        Icons.remove,
                                                        size: 18.0),
                                                  ),
                                                ),
                                                const SizedBox(width: 6.0),
                                                Text(
                                                  snapshot.data![index]
                                                      .selectedQuantity
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14.0),
                                                ),
                                                const SizedBox(width: 6.0),
                                                MaterialButton(
                                                  onPressed: () {
                                                    int quantity = snapshot
                                                        .data![index]
                                                        .selectedQuantity!;
                                                    double price = double.parse(
                                                        snapshot.data![index]
                                                            .initialPrice!
                                                            .toStringAsFixed(2)
                                                            .toString());
                                                    quantity++;
                                                    double? newPrice =
                                                        price * quantity;

                                                    dbHelper!
                                                        .updateQuantity(
                                                      CartModel(
                                                        uid: uid,
                                                        id: index,
                                                        productId: snapshot
                                                            .data![index]
                                                            .productId,
                                                        vendorId: vendorId,
                                                        title: snapshot
                                                            .data![index].title,
                                                        subtitle: snapshot
                                                            .data![index]
                                                            .subtitle,
                                                        photo: snapshot
                                                            .data![index].photo,
                                                        selectedQuantity:
                                                            quantity,
                                                        unitTag: snapshot
                                                            .data![index]
                                                            .unitTag,
                                                        initialPrice: snapshot
                                                            .data![index]
                                                            .initialPrice,
                                                        productPrice: newPrice,
                                                      ),
                                                    )
                                                        .then((_) {
                                                      newPrice = 0.0;
                                                      quantity = 0;
                                                      value.addCounter();
                                                      value.addTotalPrice(
                                                          snapshot.data![index]
                                                              .initialPrice!);
                                                      setState(() {});
                                                    }).onError((error,
                                                            stackTrace) {
                                                      print('Error : $error');
                                                    });
                                                  },
                                                  color: Colors.deepPurple,
                                                  textColor: Colors.white,
                                                  shape: const CircleBorder(),
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  padding: EdgeInsets.zero,
                                                  elevation: 0.0,
                                                  highlightElevation: 0.0,
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal: -4.0,
                                                          vertical: -4.0),
                                                  height: 48.0,
                                                  minWidth: 48.0,
                                                  child: const Icon(Icons.add,
                                                      size: 18.0),
                                                ),
                                              ],
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                            ),
                          ],
                        ),
                      );
                    } else {
                      print('No Data found');
                      return const Center(
                        child: Text('No Data Found'),
                      );
                    }
                  } else {
                    print('Circular Indicator');
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            Positioned(
              bottom: 0,
              child: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Visibility(
                    visible:
                        value.getTotalPrice().toStringAsFixed(2).toString() ==
                                    '0.00' ||
                                value.getTotalPrice().toString() == '0'
                            ? false
                            : true,
                    child: Column(
                      children: [
                        ReusableWidget(
                            title: 'Sub Total',
                            value:
                                '\u{20B9}${value.getTotalPrice().toStringAsFixed(2).toString()}'),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  const ReusableWidget({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toString(),
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10.0),
        Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
