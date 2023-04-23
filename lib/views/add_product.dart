import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_database/views/homepage.dart';

import '../database/connection_db.dart';
import '../model/product_model.dart';

class AddProduct extends StatefulWidget {
  AddProduct({super.key, required this.pro, required this.title});
  ProductModel? pro;
  String title;
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final productName = TextEditingController();

  @override
  void initState() {
    if (widget.title == 'Update Product') {
      productName.text = widget.pro!.name!;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: productName,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter Product'),
            ),
          ),
          CupertinoButton(
              color: Colors.blue,
              child: const Text('Save'),
              onPressed: () async {
                if (productName.text.isNotEmpty) {
                  widget.title != 'Update Product'
                      ? ConnectionDB()
                          .insertProduct(ProductModel(
                              id: DateTime.now().microsecond,
                              name: productName.text))
                          .whenComplete(() => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                              (route) => false))
                      : ConnectionDB()
                          .updateProduct(ProductModel(
                              id: widget.pro!.id, name: productName.text))
                          .whenComplete(() => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                              (route) => false));
                }
              })
        ],
      ),
    );
  }
}
