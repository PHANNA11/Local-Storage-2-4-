import 'package:local_database/global/fields.dart';

class ProductModel {
  int? id;
  String? name;
  double? price;
  String? image;
  String? category;

  ProductModel({this.id, this.name, this.image, this.price,this.category});
  Map<String, dynamic> toMap() {
    return {fId!: id, fName!: name, fImage!: image, fPrice!: price,procategory!:category};
  }

  ProductModel.fromMap(Map<String, dynamic> res)
      : id = res[fId],
        name = res[fName],
        image = res[fImage],
        price = res[fPrice],category=res[procategory];
}
