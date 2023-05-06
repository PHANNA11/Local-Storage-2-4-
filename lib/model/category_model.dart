import 'package:local_database/global/fields.dart';

class CategoryModel {
  int? id;
  String ?name;
  CategoryModel({this.id,this.name});
  Map<String,dynamic> toJson(){
  return {
    fCategoryId:id,
    fCategoryName:name,
    };
  }
  CategoryModel.fromJson(Map<String,dynamic> res):id=res[fCategoryId],name= res[fCategoryName];

}