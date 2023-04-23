import 'package:local_database/global/fields.dart';

class ProductModel {
  int? id;
  String? name;
  ProductModel({this.id, this.name});
  Map<String, dynamic> toMap() {
    return {fId!: id, fName!: name};
  }

  ProductModel.fromMap(Map<String, dynamic> res)
      : id = res[fId],
        name = res[fName];
}
