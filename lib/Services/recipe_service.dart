import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/recipe_type_model.dart';
import '../models/recipe_model.dart';

class RecipeService extends ChangeNotifier {
  static const String _recipesBoxName = "recipesBox";
  static const String _recipeTypesBoxName = "recipeTypesBox";

  Future<Box<Recipe>> _getRecipeBox() async {
    return await Hive.openBox<Recipe>(_recipesBoxName);
  }

  Future<Box<RecipeTypeModel>> _getRecipeTypeBox() async {
    return await Hive.openBox<RecipeTypeModel>(_recipeTypesBoxName);
  }

  Future<List<Recipe>> getRecipes() async {
    final box = await _getRecipeBox();
    return box.values.toList();
  }

  Future<List<RecipeTypeModel>> getRecipeTypes() async {
    final recipeTypeBox = await _getRecipeTypeBox();
    return recipeTypeBox.values.toList();
  }

  Future<void> addRecipe(Recipe recipe) async {
    final recipeBox = await _getRecipeBox();
    final recipeTypeBox = await _getRecipeTypeBox();

    if (recipeTypeBox.values.where((element) => element.id == recipe.recipeTypeId).isEmpty) {
      throw Exception("Recipe Type Id is not valid");
    }

    await recipeBox.put(recipe.id, recipe);
    notifyListeners();
  }

  Future<void> addRecipeType(RecipeTypeModel recipeType) async {
    final recipeTypeBox = await _getRecipeTypeBox();
    await recipeTypeBox.put(recipeType.id, recipeType);
    notifyListeners();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final recipeBox = await _getRecipeBox();
    //final recipeTypeBox = await _getRecipeTypeBox();

    var a = recipeBox.values.firstWhere((element) => element == recipe);
    await recipeBox.put(a.key, recipe);
    notifyListeners();
  }

  Future<void> deleteRecipe(String id) async {
    final box = await _getRecipeBox();
    await box.delete(id);
    notifyListeners();
  }

  Future<void> setFavorite(String id, bool isFavorite) async {
    final box = await _getRecipeBox();
    final recipe = box.get(id);
    if (recipe != null) {
      recipe.updateFavorite(isFavorite);
      await box.put(id, recipe);
      notifyListeners();
    }
  }

  Future<void> close() async {
    final recipesBox = await _getRecipeBox();
    await recipesBox.close();
    final recipeTypesBox = await _getRecipeTypeBox();
    await recipeTypesBox.close();
  }
}
