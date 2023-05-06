import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_database/database/connection_db.dart';
import 'package:local_database/model/category_model.dart';
import 'package:local_database/views/homepage.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final categoryName = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'.toUpperCase()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: categoryName,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter Category'),
            ),
          ),
          CupertinoButton(
              color: Theme.of(context).primaryColor,
              child: const Text('Save'),
              onPressed: () async {
                if (categoryName.text.isNotEmpty) {
                  await ConnectionDB()
                      .insertCategory(CategoryModel(
                          id: DateTime.now().microsecond,
                          name: categoryName.text))
                      .whenComplete(() => Navigator.pop(context));
                }
              })
        ],
      ),
    );
  }
}
