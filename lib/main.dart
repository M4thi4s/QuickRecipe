import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

import 'Models/recipe_type_model.dart';
import 'models/ingredient_model.dart' as ingredient_model;
import 'models/recipe_model.dart' as recipe_model;
import 'Views/home_view.dart';
import 'models/recipe_model.dart';
import 'models/ingredient_model.dart';
import 'services/recipe_service.dart';

import 'Dev_data/populate_hive.dart';

void main() async {
  // Initialize Hive for Flutter and open the necessary boxes
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);

  // Populate with fake data
  await populateData();

  if (!Hive.isAdapterRegistered(RecipeAdapter().typeId)) {
    Hive.registerAdapter(recipe_model.RecipeAdapter());
  }
  if (!Hive.isAdapterRegistered(IngredientAdapter().typeId)) {
    Hive.registerAdapter(ingredient_model.IngredientAdapter());
  }
  if (!Hive.isAdapterRegistered(RecipeTypeModelAdapter().typeId)) {
    Hive.registerAdapter(RecipeTypeModelAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecipeService>(
        create: (_) => RecipeService(),
        builder: (context, child) {
          var app = MaterialApp(
            title: 'Quick Recipes',
            theme: ThemeData(
              primarySwatch: Colors.green,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: const HomeView(),
            // If you have defined routes, you can add them here as well.
          );
          return app;
        });
  }
}
