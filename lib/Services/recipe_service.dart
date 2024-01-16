import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:quickrecipe/models/recipe_type_model.dart';
import '../models/recipe_model.dart';


class RecipeService extends ChangeNotifier {
  static const String _boxName = "recipesBox";

  String getProviderTitle() => "Recipe Service";

  Future<Box<Recipe>> _openBox() async {
    return await Hive.openBox<Recipe>(_boxName);
  }

  Future<List<Recipe>> getRecipes() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<List<RecipeTypeModel>> getRecipeTypes() async {
    final box = await _openBox();
    return box.values.map((recipe) => recipe.recipeType).toSet().toList();
  }

  Future<void> addRecipe(Recipe recipe) async {
    final box = await _openBox();
    await box.put(recipe.id, recipe);
    notifyListeners(); // Notify widgets to rebuild
  }

  Future<void> updateRecipe(String id, Recipe recipe) async {
    final box = await _openBox();
    await box.put(id, recipe);
    notifyListeners(); // Notify widgets to rebuild
  }

  Future<void> deleteRecipe(String id) async {
    final box = await _openBox();
    await box.delete(id);
    notifyListeners(); // Notify widgets to rebuild
  }

  // Additional methods to handle image paths and recipe types could be added here.

  // Don't forget to close the box when it's no longer needed.
  Future<void> close() async {
    final box = await Hive.openBox<Recipe>(_boxName);
    await box.close();
  }
}
