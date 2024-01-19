import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import '../models/recipe_type_model.dart';
import '../services/recipe_service.dart';

Future<void> populateData() async {
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(IngredientAdapter());
  Hive.registerAdapter(RecipeTypeModelAdapter());

  final recipeService = RecipeService();

  var mainDishType = RecipeTypeModel(typeName: 'Plat', id: "plat");
  var dessertType = RecipeTypeModel(typeName: 'Dessert', id: "dessert");

  await recipeService.addRecipeType(mainDishType);
  await recipeService.addRecipeType(dessertType);

  var recipes = [
    Recipe(
        id: '1',
        title: 'Chili Con Carne',
        description: 'Traditional Chili Con Carne.',
        preparationTime: 120,
        ingredients: [Ingredient(name: 'Beef', quantity: '500g'), Ingredient(name: 'Kidney Beans', quantity: '400g'), Ingredient(name: 'Tomatoes', quantity: '400g')],
        preparationSteps: ['Brown the beef in a pan.', 'Add tomatoes and kidney beans and simmer for 1.5 hours.'],
        recipeTypeId: "plat",
        imagePath: 'https://assets.afcdn.com/recipe/20211222/126214_w600.jpg',
    ),
    Recipe(
        id: '2',
        title: 'Pate Carbonara',
        description: 'Creamy Pate Carbonara.',
        preparationTime: 30,
        ingredients: [Ingredient(name: 'Pasta', quantity: '500g'), Ingredient(name: 'Bacon', quantity: '200g'), Ingredient(name: 'Cream', quantity: '200ml')],
        preparationSteps: ['Cook pasta as per instructions.', 'Fry bacon, add cream and cooked pasta.'],
        recipeTypeId: "plat",
        imagePath: 'https://assets.afcdn.com/recipe/20211214/125831_w600.jpg'
    ),
    Recipe(
        id: '3',
        title: 'Rougail Saucisse',
        description: 'Spicy and savory Rougail Saucisse.',
        preparationTime: 90,
        ingredients: [Ingredient(name: 'Sausages', quantity: '4'), Ingredient(name: 'Tomatoes', quantity: '3'), Ingredient(name: 'Onion', quantity: '1'), Ingredient(name: 'Garlic', quantity: '3 cloves')],
        preparationSteps: ['Slice sausages and fry.', 'Add chopped onions, garlic, and tomatoes.', 'Simmer for 1 hour.'],
        recipeTypeId: "plat",
        imagePath: 'https://assets.afcdn.com/recipe/20200219/107902_w600.jpg'
    ),
    Recipe(
        id: '4',
        title: 'Paupiette de Veau',
        description: 'Delicious and tender Paupiette de Veau.',
        preparationTime: 60,
        ingredients: [Ingredient(name: 'Veal', quantity: '4 slices'), Ingredient(name: 'Carrots', quantity: '2'), Ingredient(name: 'Onions', quantity: '1')],
        preparationSteps: ['Wrap veal slices around filling.', 'Brown in pan with onions and carrots.', 'Simmer for 45 minutes.'],
        recipeTypeId: "plat",
        imagePath: 'https://assets.afcdn.com/recipe/20221007/135809_w600.jpg'
    ),
    Recipe(
        id: '5',
        title: 'Falafel',
        description: 'Crispy and flavorful Falafel.',
        preparationTime: 50,
        ingredients: [Ingredient(name: 'Chickpeas', quantity: '500g'), Ingredient(name: 'Onion', quantity: '1'), Ingredient(name: 'Garlic', quantity: '2 cloves')],
        preparationSteps: ['Blend chickpeas with onions and garlic.', 'Form into balls and deep fry until golden.'],
        recipeTypeId: "plat",
        imagePath: 'https://assets.afcdn.com/recipe/20170124/571_w600.jpg'
    ),
    Recipe(
        id: '6',
        title: 'Pot au Feu',
        description: 'Classic French stew, Pot au Feu.',
        preparationTime: 180,
        ingredients: [Ingredient(name: 'Beef', quantity: '1kg'), Ingredient(name: 'Carrots', quantity: '3'), Ingredient(name: 'Potatoes', quantity: '5')],
        preparationSteps: ['Boil beef in water.', 'Add chopped carrots and potatoes.', 'Simmer for 3 hours.'],
        recipeTypeId: "plat",
        imagePath: 'https://assets.afcdn.com/recipe/20131219/8538_w600.jpg'
    ),
    Recipe(
        id: '7',
        title: 'Roti au Four',
        description: 'Juicy and tender Roti au Four.',
        preparationTime: 90,
        ingredients: [Ingredient(name: 'Roast beef', quantity: '1kg'), Ingredient(name: 'Potatoes', quantity: '5'), Ingredient(name: 'Carrots', quantity: '3')],
        preparationSteps: ['Season the roast and place in oven.', 'Add potatoes and carrots halfway through cooking.', 'Roast for 1.5 hours.'],
        recipeTypeId: "plat",
        imagePath: 'https://assets.afcdn.com/recipe/20180503/79003_w600.jpg'
    ),
    Recipe(
        id: '8',
        title: 'Cote de Porc',
        description: 'Succulent Cote de Porc.',
        preparationTime: 45,
        ingredients: [Ingredient(name: 'Pork chops', quantity: '4'), Ingredient(name: 'Herbs', quantity: '1 tsp'), Ingredient(name: 'Butter', quantity: '50g')],
        preparationSteps: ['Season pork chops with herbs.', 'Fry in butter until golden and cooked through.'],
        recipeTypeId: "plat",
        imagePath: 'https://assets.afcdn.com/recipe/20200907/113953_w600.jpg'
    ),
    Recipe(
        id: '9',
        title: 'Crepe',
        description: 'Light and delicate Crepes.',
        preparationTime: 30,
        ingredients: [Ingredient(name: 'Flour', quantity: '250g'), Ingredient(name: 'Eggs', quantity: '3'), Ingredient(name: 'Milk', quantity: '500ml')],
        preparationSteps: ['Mix flour and eggs.', 'Gradually add milk to form a smooth batter.', 'Cook in a hot pan until golden.'],
        recipeTypeId: "dessert",
        imagePath: 'https://assets.afcdn.com/recipe/20211122/124598_w600.jpg'
    ),
    Recipe(
        id: '10',
        title: 'Gateau au Chocolat',
        description: 'Rich and moist chocolate cake.',
        preparationTime: 60,
        ingredients: [Ingredient(name: 'Chocolate', quantity: '200g'), Ingredient(name: 'Butter', quantity: '200g'), Ingredient(name: 'Sugar', quantity: '200g'), Ingredient(name: 'Eggs', quantity: '4')],
        preparationSteps: ['Melt chocolate and butter together.', 'Whisk in sugar and eggs.', 'Bake in a preheated oven for 45 minutes.'],
        recipeTypeId: "dessert",
        imagePath: 'https://assets.afcdn.com/recipe/20190529/93102_w600.jpg'
    ),
    Recipe(
        id: '11',
        title: 'Cookie',
        description: 'Crispy and chewy chocolate chip cookies.',
        preparationTime: 30,
        ingredients: [Ingredient(name: 'Flour', quantity: '300g'), Ingredient(name: 'Butter', quantity: '200g'), Ingredient(name: 'Sugar', quantity: '150g'), Ingredient(name: 'Chocolate Chips', quantity: '200g')],
        preparationSteps: ['Cream butter and sugar.', 'Mix in flour and chocolate chips.', 'Bake in a preheated oven for 15 minutes.'],
        recipeTypeId: "dessert",
        imagePath: 'https://assets.afcdn.com/recipe/20190529/93153_w600.jpg'
    ),
    Recipe(
        id: '12',
        title: 'Mousse au Chocolat',
        description: 'Light and airy chocolate mousse.',
        preparationTime: 120,
        ingredients: [Ingredient(name: 'Chocolate', quantity: '150g'), Ingredient(name: 'Eggs', quantity: '4'), Ingredient(name: 'Sugar', quantity: '50g')],
        preparationSteps: ['Melt chocolate.', 'Whisk eggs and sugar, fold into chocolate.', 'Chill for 2 hours.'],
        recipeTypeId: "dessert",
        imagePath: 'https://assets.afcdn.com/recipe/20210311/118509_w600.jpg'
    ),
    Recipe(
        id: '13',
        title: 'Crumble aux Pommes',
        description: 'Warm and comforting apple crumble.',
        preparationTime: 45,
        ingredients: [Ingredient(name: 'Apples', quantity: '5'), Ingredient(name: 'Flour', quantity: '200g'), Ingredient(name: 'Butter', quantity: '100g'), Ingredient(name: 'Sugar', quantity: '150g')],
        preparationSteps: ['Peel and slice apples.', 'Mix flour, butter, and sugar to make crumble.', 'Bake with apples for 30 minutes.'],
        recipeTypeId: "dessert",
        imagePath: 'https://assets.afcdn.com/recipe/20130823/26376_w600.jpg'
    ),
    Recipe(
        id: '14',
        title: 'Canelé',
        description: 'Crispy on the outside, soft in the middle Canelés.',
        preparationTime: 120,
        ingredients: [Ingredient(name: 'Milk', quantity: '500ml'), Ingredient(name: 'Flour', quantity: '250g'), Ingredient(name: 'Sugar', quantity: '200g'), Ingredient(name: 'Eggs', quantity: '2')],
        preparationSteps: ['Boil milk with butter.', 'Mix flour, sugar, and eggs, then add milk.', 'Bake in a preheated oven for 1 hour.'],
        recipeTypeId: "dessert",
        imagePath: 'https://assets.afcdn.com/recipe/20230621/143653_w600.jpg'
    )
  ];

  for (var recipe in recipes) {
    await recipeService.addRecipe(recipe);
  }

  print('Hive has been populated with sample data.');
}
