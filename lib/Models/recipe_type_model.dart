import 'package:hive/hive.dart';
part 'recipe_type_model.g.dart';

@HiveType(typeId: 2)
class RecipeTypeModel extends HiveObject {
  @HiveField(0)
  late final String typeName;

  @HiveField(1)
  late final String id;

  bool _isNon = false;

  RecipeTypeModel({required this.typeName, required this.id});

  static RecipeTypeModel getNonRecipeType() {
    var a = RecipeTypeModel(typeName: "Tous", id: "nonTypeId");
    a._isNon = true;
    return a;
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
