// scripts/populate_hive.dart

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import '../models/recipe_type_model.dart';
import '../services/recipe_service.dart';

Future<void> populateData() async {
  // Initialize Hive
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Register Adapters
  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(IngredientAdapter());
  Hive.registerAdapter(RecipeTypeModelAdapter());

  // Assuming RecipeService takes care of opening and closing the box
  final recipeService = RecipeService();

  // Create sample RecipeTypeModel
  var dessertType = RecipeTypeModel(typeName: 'Dessert');

  // Create sample RecipeTypeModel
  var mainDishType = RecipeTypeModel(typeName: 'MainDish');

  // Create sample ingredients
  var sugar = Ingredient(name: 'Sugar', quantity: '100g');
  var flour = Ingredient(name: 'Flour', quantity: '200g');

  // Create sample Recipe
  var cakeRecipe = Recipe(
      id: '1',
      title: 'Chocolate Cake',
      description: 'A rich chocolate cake recipe.',
      preparationTime: 60,
      ingredients: [sugar, flour],
      preparationSteps: [
        'Preheat oven to 350 degrees F (175 degrees C).',
        'Grease and flour two nine-inch round pans.',
        'Cream the sugar and butter in a large mixing bowl until light and fluffy.'
        // Add more steps as needed
      ],
      recipeType: dessertType,
      imagePath: 'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&webp=true&resize=600,545'
  );

  var pasta = Ingredient(name: 'Pasta', quantity: '250g');
  var lettuce = Ingredient(name: 'Lettuce', quantity: '1 cup');
  var tomatoes = Ingredient(name: 'Tomatoes', quantity: '2');
  var cucumbers = Ingredient(name: 'Cucumbers', quantity: '1');
  var bellPeppers = Ingredient(name: 'Bell Peppers', quantity: '1');
  var blackOlives = Ingredient(name: 'Black Olives', quantity: '1/2 cup');
  var fetaCheese = Ingredient(name: 'Feta Cheese', quantity: '1/2 cup');

  // Create sample Recipes
  var chickenCurry = Recipe(
      id: '3',
      title: 'Chicken Curry',
      description: 'A delicious and flavorful chicken curry recipe.',
      preparationTime: 45,
      ingredients: [pasta, lettuce, tomatoes, cucumbers, bellPeppers, blackOlives, fetaCheese],
      preparationSteps: [
        'Cut the chicken into bite-sized pieces.',
        'Peel and chop the onions and tomatoes.',
        'Grate the ginger and garlic.',
        'In a large pot, heat the oil over medium heat.',
        'Add the onions and cook until softened, about 5 minutes.',
        'Add the ginger, garlic, and curry powder and cook for 1 minute more, until fragrant.',
        'Add the chicken and cook until browned on all sides.',
        'Add the tomatoes, turmeric powder, garam masala, coconut milk, salt, and pepper.',
        'Bring to a boil, then reduce heat and simmer for 20 minutes, or until the chicken is cooked through.',
        'Serve over rice or naan bread.',
      ],
      recipeType: mainDishType,
      imagePath: 'https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fpublic-assets.meredithcorp.io%2F00080cfee447d4d939ef6edcad71fb21%2F1694703261110IMG_9898.jpeg&q=60&c=sc&orient=true&poi=auto&h=512'
  );



  // Add the sample data to Hive using the service
  await recipeService.addRecipe(cakeRecipe);
  await recipeService.addRecipe(chickenCurry);

  print('Hive has been populated with sample data.');

  // No need to explicitly close the box as it should be handled by the service
}
