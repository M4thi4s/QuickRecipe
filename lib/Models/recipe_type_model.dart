import 'package:hive/hive.dart';
part 'recipe_type_model.g.dart';

@HiveType(typeId: 2)
class RecipeTypeModel extends HiveObject {
  @HiveField(0)
  final String typeName;

  RecipeTypeModel({required this.typeName});
}