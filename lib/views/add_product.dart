import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_database/views/category_screen.dart';
import 'package:local_database/views/homepage.dart';

import '../database/connection_db.dart';
import '../global/constant.dart';
import '../model/category_model.dart';
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
  List<String> items = ['item1', 'item2', 'item3'];
  String selectItem = '';
  @override
  void initState() {
    if (widget.title == 'Update Product') {
      productName.text = widget.pro!.name!;
      productPrice.text = widget.pro!.price!.toString();
      fileImage = File(widget.pro!.image.toString());
      selectItem=widget.pro!.category.toString();
    }
    // TODO: implement initState
    super.initState();
  }
 List<CategoryModel> categorylist = [];
  getCategory() async {
    await ConnectionDB().getCategoryList().then((value) {
      setState(() {
        categorylist = value;
        filterStringList();
      });
    });
  }
  filterStringList(){
    items=[];
    for(var temp in categorylist){
      items.add(temp.name.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    getCategory();
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: DropdownButtonFormField2(
                    decoration: InputDecoration(
                      //Add isDense true and zero Padding.
                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      //Add more decoration as you want here
                      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                    ),
                    isExpanded: true,
                    hint: const Text(
                      'Select category',
                      style: TextStyle(fontSize: 14),
                    ),
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                              value:item,
                              child: Text(
                               item,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),)
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'select category';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                         selectItem = value.toString();
                      });
                      //Do something when changing the item if you want.
                    },
                    onSaved: (value) {

                    },
                    buttonStyleData: const ButtonStyleData(
                      height: 60,
                      padding: EdgeInsets.only(left: 20, right: 10),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryScreen(),));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 4),
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                )
              ],
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
                              image: fileImage == null ? '' : fileImage!.path,
                              category: selectItem))
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
                              image: fileImage == null ? '' : fileImage!.path, category: selectItem))
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
