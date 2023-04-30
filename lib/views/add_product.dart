import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_database/views/homepage.dart';

import '../database/connection_db.dart';
import '../global/constant.dart';
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
  final productPrice = TextEditingController();
  File? fileImage;

  @override
  void initState() {
    if (widget.title == 'Update Product') {
      productName.text = widget.pro!.name!;
      productPrice.text = widget.pro!.price!.toString();
      fileImage = File(widget.pro!.image.toString());
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                selectImage();
              },
              icon: const Icon(Icons.camera_alt))
        ],
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: productPrice,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter Price'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              elevation: 0,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: fileImage == null
                        ? DecorationImage(
                            image: NetworkImage(emptyImage.toString()))
                        : DecorationImage(
                            image: FileImage(File(fileImage!.path)))),
              ),
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
                              name: productName.text,
                              price: double.parse(productPrice.text),
                              image: fileImage == null ? '' : fileImage!.path))
                          .whenComplete(() => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                              (route) => false))
                      : ConnectionDB()
                          .updateProduct(ProductModel(
                              id: widget.pro!.id,
                              name: productName.text,
                              price: double.parse(productPrice.text),
                              image: fileImage == null ? '' : fileImage!.path))
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

  void selectImage() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      fileImage = File(image!.path);
    });
  }
}
