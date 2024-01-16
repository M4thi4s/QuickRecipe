import 'package:hive/hive.dart';
import 'ingredient_model.dart';
import 'recipe_type_model.dart';

part 'recipe_model.g.dart';

@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int preparationTime;

  @HiveField(4)
  final List<Ingredient> ingredients;

  @HiveField(5)
  final List<String> preparationSteps;

  @HiveField(6)
  final RecipeTypeModel recipeType;

  @HiveField(7) // New field for the image path
  final String imagePath;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.preparationTime,
    required this.ingredients,
    required this.preparationSteps,
    required this.recipeType,
    this.imagePath = '', // default value for imagePath is an empty string
  });
}
