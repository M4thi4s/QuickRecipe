import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import 'package:timeline_tile/timeline_tile.dart';

class RecipeDetailView extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailView({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(recipe.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste des recettes',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Met le texte en gras
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFF04724D),
        foregroundColor: Colors.white,
        centerTitle: false,
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
                  color: Color(0xFF04724D),
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
                  color: Color(0xFF04724D),
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
                  color: Color(0xFF04724D),
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
                      iconData: Icons.circle, // Can be a custom icon as well
                      color: Colors.white, // Icon color inside the indicator
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
