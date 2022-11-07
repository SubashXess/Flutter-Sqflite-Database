import 'package:addtocart_with_provider/models/cart_model.dart';
import 'package:addtocart_with_provider/models/product_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    return _database = await initializeDatabase();
  }

  Future<Database> initializeDatabase() async {
    io.Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE cart(uid VARCHAR, id INTEGER, productId VARCHAR PRIMARY KEY, vendorId VARCHAR, title TEXT, subtitle TEXT, photo TEXT, unitTag TEXT, selectedQuantity INTEGER, initialPrice DOUBLE, productPrice DOUBLE)");
  }

  Future<CartModel> insertToDB(CartModel cart) async {
    Database? dbClient = await database;
    await dbClient!.insert('cart', cart.toJson());
    return cart;
  }

// getting all the items in the list from the database
  Future<List<CartModel>> getCartItems() async {
    Database? dbClient = await database;
    final List<Map<String, dynamic>> queryResult =
        await dbClient!.query('cart');
    return queryResult.map((result) => CartModel.fromJson(result)).toList();
  }

  // getting individual item with productId
  Future<CartModel?> getItemWithId(String productId) async {
    Database? dbClient = await database;
    final List<Map<String, Object?>> response = await dbClient!
        .query('cart', where: 'productId = ?', whereArgs: [productId]);
    if (response.isNotEmpty) {
      return CartModel.fromJson(response.first);
    } else {
      return null;
    }
  }

  Future<int> deleteItemFromCart(int productId) async {
    Database? dbClient = await database;
    return await dbClient!
        .delete('cart', where: 'productId=?', whereArgs: [productId]);
  }

  Future<int> updateQuantity(CartModel cart) async {
    Database? dbClient = await database;
    return await dbClient!.update(
      'cart',
      cart.toJson(),
      where: 'productId=?',
      whereArgs: [cart.productId],
    );
  }

  Future<int> deleteDatabaseDontTry(int id) async {
    Database? dbClient = await database;
    return await dbClient!.delete('cart');
  }

  Future<void> deleteAllDatabaseDontTry() async {
    Database? dbClient = await database;
    dbClient!.rawDelete('DELETE FROM cart');
  }
}
