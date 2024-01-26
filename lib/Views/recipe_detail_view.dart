import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Configs/Config.dart';
import '../services/recipe_service.dart';
import '../models/recipe_model.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:share/share.dart';

class RecipeDetailView extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailView({Key? key, required this.recipe}) : super(key: key);

  void _shareRecipe() {
    final String content = "Découvrez cette recette : ${recipe.title}\n${recipe.description}\n${recipe.preparationSteps.join("\n")}";
    Share.share(content);
  }

  void _deleteRecipe(BuildContext context, RecipeService recipeService) async {
    final bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text('Voulez-vous vraiment supprimer cette recette ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    ) ?? false;

    if (confirm) {
      await recipeService.deleteRecipe(recipe.id);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeService = Provider.of<RecipeService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste des recettes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Config.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareRecipe,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFFE5757)),
            onPressed: () => _deleteRecipe(context, recipeService),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                recipe.title,
                style: const TextStyle(
                  fontSize: 27.0,
                  fontWeight: FontWeight.w900,
                  color: Config.primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                recipe.description,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Ingrédients',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Config.primaryColor,
                ),
              ),
            ),
            ...List.generate(recipe.ingredients.length, (index) {
              return ListTile(
                title: Text(recipe.ingredients[index].name),
                trailing: Text(recipe.ingredients[index].quantity),
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4)
              );
            }),
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Préparation',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Config.primaryColor,
                ),
              ),
            ),

            // Preparation steps with a timeline
            ...recipe.preparationSteps.map((step) => TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1, // Adjust line position
                  isFirst: recipe.preparationSteps.indexOf(step) == 0,
                  isLast: recipe.preparationSteps.indexOf(step) ==
                      recipe.preparationSteps.length - 1,
                  startChild: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  endChild: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      step,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  beforeLineStyle: const LineStyle(
                    color: Colors.green, // Line color
                  ),
                  indicatorStyle: IndicatorStyle(
                    width: 20, // Indicator size
                    color: Colors.green, // Indicator color
                    iconStyle: IconStyle(
                      iconData: Icons.circle,
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
