import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:local_database/database/connection_db.dart';
import 'package:local_database/model/product_model.dart';
import 'package:local_database/views/add_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

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
            child: ListTile(
                subtitle: Text('Code :${listProduct[index].id}'),
                title: Text(listProduct[index].name.toString())),
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
