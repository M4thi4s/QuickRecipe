import 'package:flutter/material.dart';
import '../models/recipe_model.dart';

class RecipeForm extends StatefulWidget {
  final Recipe? recipe; // If null, it's for creating a new recipe.

  const RecipeForm({Key? key, this.recipe}) : super(key: key);

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  // Form controllers and state would go here.

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          TextFormField(


            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            initialValue: widget.recipe?.title,
// You will need to set up a TextEditingController
// or use the onChanged callback to update the state.
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            initialValue: widget.recipe?.description,
// Controller or onChanged callback.
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Preparation Time (in minutes)',
              border: OutlineInputBorder(),
            ),
            initialValue: widget.recipe?.preparationTime.toString(),
            keyboardType: TextInputType.number,
// Controller or onChanged callback.
          ),
          const SizedBox(height: 16.0),
// If editing, display current ingredients and allow removal.
// For adding new ingredients, show a dialog or another screen.
// ... buildIngredientsList(),
// Same for preparation steps.
// ... buildPreparationStepsList(),
          ElevatedButton(
            onPressed: () {
// TODO: Implement save functionality.
            },
            child: Text(widget.recipe != null ? 'Update Recipe' : 'Add Recipe'),
          ),
        ],
      ),
    );
  }

// Helper method to build the ingredients list.
// This is just a placeholder for illustration.
  List<Widget> buildIngredientsList() {
    return widget.recipe?.ingredients.map((ingredient) => ListTile(
      title: Text(ingredient.name),
      trailing: Text(ingredient.quantity),
      onLongPress: () {
// TODO: Implement deletion or editing of the ingredient.
      },
    )).toList() ?? [];
  }

// Helper method to build the preparation steps list.
// This is just a placeholder for illustration.
  List<Widget> buildPreparationStepsList() {
    return widget.recipe?.preparationSteps.map((step) => ListTile(
      title: Text(step),
      onLongPress: () {
// TODO: Implement deletion or editing of the step.
      },
    )).toList() ?? [];
  }
}