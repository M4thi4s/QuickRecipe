// lib/views/home_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/recipe_card.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';
import 'add_recipe_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {
    final recipeService = Provider.of<RecipeService>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quick Recipes',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Met le texte en gras
          ),
        ),
        backgroundColor: const Color(0xFF04724D),
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      body: FutureBuilder<List<Recipe>>(
        future: recipeService.getRecipes(),
        builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final recipes = snapshot.data ?? [];
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
        backgroundColor: const Color(0xFF04724D),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
