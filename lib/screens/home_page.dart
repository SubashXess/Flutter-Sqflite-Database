// ignore_for_file: avoid_print

import 'package:addtocart_with_provider/database/db_helper.dart';
import 'package:addtocart_with_provider/models/product_model.dart';
import 'package:addtocart_with_provider/providers/cart_provider.dart';
import 'package:addtocart_with_provider/providers/getdata_provider.dart';
import 'package:addtocart_with_provider/screens/cart_page.dart';
import 'package:addtocart_with_provider/screens/details_page.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// ScrollController
  final ScrollController _scrollController = ScrollController();

  // Database Helper
  DBHelper? dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProductProvider>(context, listen: false).getProductsList();
    });
  }

  final int id = 1; // for db delete

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print('reload');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          // temp icon for delete db
          Consumer<CartProvider>(builder: (context, value, child) {
            return IconButton(
              onPressed: () {
                dbHelper!.deleteAllDatabaseDontTry();
                value.removeAllCounterDontTry();
                value.removeAllTotalPriceDontTry();
              },
              icon: const Icon(
                Icons.delete_rounded,
                size: 20.0,
                color: Colors.white,
              ),
            );
          }),
          Consumer<CartProvider>(builder: (context, value, child) {
            return Badge(
              showBadge: value.getCounterValue() != 0 ? true : false,
              badgeContent: Text(
                value.getCounterValue().toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.0),
              ),
              elevation: 0.0,
              badgeColor: Colors.red,
              position: BadgePosition.topEnd(end: 10.0, top: 6.0),
              child: IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                splashRadius: 20.0,
                visualDensity:
                    const VisualDensity(vertical: -4.0, horizontal: -4.0),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CartPage())),
                icon: const Icon(
                  Icons.shopping_bag_rounded,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            );
          }),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Products',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Consumer<ProductProvider>(builder: (context, value, child) {
                      final List<ProductModel> item = value.products;
                      if (item.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        itemCount: item.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        controller: _scrollController,
                        itemExtent: 100.0,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DetailsPage(
                                            id: item[index].pId.toString(),
                                            index: index,
                                          ))),
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
                                        color: Colors.black.withOpacity(0.04),
                                        elevation: 0.0,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              item[index].spImg.toString(),
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
                                            item[index].spName.toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          const SizedBox(height: 6.0),
                                          Text(
                                            item[index].subTitle.toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
