import 'package:hive/hive.dart';
part 'recipe_type_model.g.dart';
@HiveType(typeId: 2)
class RecipeTypeModel extends HiveObject {
  @HiveField(0)
  late final String typeName;

  bool _isNon = false;

  RecipeTypeModel({required this.typeName});

  static RecipeTypeModel getNonRecipeType() {
    var nonValue = RecipeTypeModel(typeName: "Tous");
    nonValue._isNon = true;
    return nonValue;
  }

  bool get isNon => _isNon;

  @override
  bool operator ==(dynamic other) =>
      other != null && other is RecipeTypeModel && typeName == other.typeName;

  @override
  int get hashCode => typeName.hashCode;

  @override
  String toString() {
    return 'RecipeTypeModel{typeName: $typeName}';
  }
}