import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:local_database/database/connection_db.dart';
import 'package:local_database/global/constant.dart';
import 'package:local_database/model/product_model.dart';
import 'package:local_database/views/add_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Testing
class _HomePageState extends State<HomePage> {
  List<ProductModel> listProduct = [];
  fetchDatabase() async {
    await ConnectionDB().getProductList().then((value) {
      setState(() {
        listProduct = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      body: ListView.builder(
        itemCount: listProduct.length,
        itemBuilder: (context, index) => Card(
          child: Slidable(
            key: const ValueKey(0),
            endActionPane: ActionPane(
              // A motion is a widget used to control how the pane animates.
              motion: const ScrollMotion(),

              // A pane can dismiss the Slidable.
              dismissible: DismissiblePane(onDismissed: () async {
                await ConnectionDB()
                    .deleteProduct(listProduct[index].id!)
                    .whenComplete(() => fetchDatabase());
              }),
              dragDismissible: false,

              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: (value) async {
                    await ConnectionDB()
                        .deleteProduct(listProduct[index].id!)
                        .whenComplete(() => fetchDatabase());
                  },
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: (value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddProduct(
                            title: 'Update Product',
                            pro: listProduct[index],
                          ),
                        ));
                  },
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.edit_document,
                  label: 'Edit',
                ),
              ],
            ),
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: listProduct[index].image!.isEmpty
                        ? SizedBox(
                            height: double.infinity,
                            child: Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(emptyImage.toString())),
                          )
                        : SizedBox(
                            height: double.infinity,
                            child: Image(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(listProduct[index].image.toString()),
                              ),
                            ),
                          ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  listProduct[index].name.toString(),
                                  style: const TextStyle(fontSize: 26),
                                ),
                                Text(
                                  '\$ ${listProduct[index].price}',
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children:const [
                                Text(
                                  'Drink',

                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            // child: ListTile(
            //     subtitle: Text('Code :${listProduct[index].id}'),
            //     title: Text(listProduct[index].name.toString())),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProduct(
                    title: 'Add Product',
                    pro: null,
                  ),
                ));
          },
          child: const Icon(Icons.add)),
    );
  }
}
