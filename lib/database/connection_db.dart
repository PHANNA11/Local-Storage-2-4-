import 'dart:io';
import 'package:local_database/global/fields.dart';
import 'package:local_database/model/category_model.dart';
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
          'CREATE TABLE $productTable($fId INTEGER PRIMARY KEY, $fName TEXT,$fImage TEXT,$fPrice REAL,$procategory TEXT)',
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
  //========== CRUD CATEGORY ===========
  Future<Database> initializeCategory() async {
    final Directory tempDir = await getTemporaryDirectory();
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'categoryDb.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE $categoryTable($fCategoryId INTEGER PRIMARY KEY, $fCategoryName TEXT)',
        );
      },
      version: 1,
    );
  }
  Future<void> insertCategory(CategoryModel category)async{
    var db = await  initializeCategory();
    await  db.insert(categoryTable, category.toJson());

  }
  Future<List<CategoryModel>> getCategoryList() async {
    var db = await initializeCategory();
    List<Map<String, dynamic>> result = await db.query(categoryTable);
    return result.map((e) => CategoryModel.fromJson(e)).toList();
  }
  Future<void>  updateCategory(CategoryModel category)async{
     var db = await  initializeCategory();
     await db.update(categoryTable, category.toJson(),where: '$fCategoryId=?',whereArgs: [category.id]);
  }
  Future<void> deleteCategory({int? categoryId})async{
       var db = await  initializeCategory();
       await db.delete(categoryTable,where: '$fCategoryId=?',whereArgs: [categoryId]);
  }
}
