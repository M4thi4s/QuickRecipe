import 'package:hive/hive.dart';
part 'ingredient_model.g.dart';

@HiveType(typeId: 1)
class Ingredient extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String quantity;

  Ingredient({
    required this.name,
    required this.quantity,
  });
}
