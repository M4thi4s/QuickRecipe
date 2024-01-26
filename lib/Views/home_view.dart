import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Configs/Config.dart';
import '../models/recipe_type_model.dart';
import '../widgets/recipe_card.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';
import 'add_recipe_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  RecipeTypeModel? selectedType = RecipeTypeModel.getNonRecipeType();

  Widget buildRecipeTypeDropdown(Future<List<RecipeTypeModel>> recipeTypes) {
    return FutureBuilder(
        future: recipeTypes,
        builder: (BuildContext context,
            AsyncSnapshot<List<RecipeTypeModel>> snapshot) {
          if (snapshot.hasData) {

            List<RecipeTypeModel> recipeTypes = snapshot.data!;
            var recipesTypeWithNonValue = [...recipeTypes, RecipeTypeModel.getNonRecipeType()];

            return DropdownButton<RecipeTypeModel>(
              value: selectedType,
              style: const TextStyle(color: Colors.white),
              dropdownColor: Config.primaryColor,
              iconEnabledColor: Colors.white,
              onChanged: (newValue) {
                setState(() {
                  selectedType = newValue!;
                });
              },
              items: recipesTypeWithNonValue.map<DropdownMenuItem<RecipeTypeModel>>((RecipeTypeModel value) {
                return DropdownMenuItem<RecipeTypeModel>(
                  value: value,
                  child: Text(value.typeName),
                );
              }).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final recipeService = Provider.of<RecipeService>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Quick Recipes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Config.primaryColor,
          foregroundColor: Colors.white,
          centerTitle: false,
          actions: [
            buildRecipeTypeDropdown(recipeService.getRecipeTypes()),
            const SizedBox(width: 16.0)
          ]),
      body: FutureBuilder<List<Recipe>>(
        future: recipeService.getRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final recipes = snapshot.data ?? [];
            if (selectedType != null && !selectedType!.isNon) {
              recipes.retainWhere((recipe) => recipe.recipeTypeId == selectedType?.id);
            }
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return RecipeCard(recipe: recipes[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipePage()),
          );
        },
        backgroundColor: Config.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
