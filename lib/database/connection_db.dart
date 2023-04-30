import 'dart:io';
import 'package:local_database/global/fields.dart';
import 'package:local_database/model/product_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ConnectionDB {
  Future<Database> initializeDatabase() async {
    final Directory tempDir = await getTemporaryDirectory();
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'procducts.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE $productTable($fId INTEGER PRIMARY KEY, $fName TEXT,$fImage TEXT,$fPrice REAL)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertProduct(ProductModel product) async {
    var db = await initializeDatabase();
    await db.insert(productTable, product.toMap());
    print('product was added');
  }

  Future<List<ProductModel>> getProductList() async {
    var db = await initializeDatabase();
    List<Map<String, dynamic>> result = await db.query(productTable);
    return result.map((e) => ProductModel.fromMap(e)).toList();
  }

  Future<void> deleteProduct(int productCode) async {
    var db = await initializeDatabase();
    await db.delete(productTable, where: '$fId=?', whereArgs: [productCode]);
  }

  Future<void> updateProduct(ProductModel pro) async {
    var db = await initializeDatabase();
    await db.update(productTable, pro.toMap(),
        where: '$fId=?', whereArgs: [pro.id]);
  }
}
