import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Configs/Config.dart';
import '../services/recipe_service.dart';
import '../views/recipe_detail_view.dart';
import '../models/recipe_model.dart';
import 'automatic_image.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  void setFavorite(Recipe recipe, RecipeService recipeService) {
    recipeService.setFavorite(recipe.id, !recipe.isFavorite());
  }

  void onTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailView(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var recipeService = Provider.of<RecipeService>(context, listen: false);

    return InkWell(
      onTap: () => onTapped(context),
      child: Container(
        height: 150.0, // Fixed height for the card
        margin: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
// Use a Stack to overlay the image and the icon
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                  child: AutomaticImage(
                    imagePath: recipe.imagePath,
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 5,
                  bottom: 5,
                  child: GestureDetector(
                    onTap: () => setFavorite(recipe, recipeService),
                    child: Icon(
                      recipe.isFavorite()
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
// SizedBox(width: 8.0),
// Recipe Info
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                decoration: const BoxDecoration(
                  color: Config.primaryColor, // Green background from the image
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Description
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          recipe.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    // Divider Line
                    const Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                    // Duration with Clock Icon
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            color: Colors.white.withOpacity(0.6)), // Clock icon
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.preparationTime} minutes',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
