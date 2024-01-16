import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import '../Widgets/image_picker_button.dart';
import '../services/recipe_service.dart';
import 'package:quickrecipe/models/ingredient_model.dart';
import 'package:quickrecipe/models/recipe_model.dart';
import 'package:quickrecipe/models/recipe_type_model.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({Key? key}) : super(key: key);

  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();
  final _typeController = TextEditingController();
  final _ingredientNameController = TextEditingController();
  final _ingredientQuantityController = TextEditingController();
  final _stepController = TextEditingController();

  final List<Ingredient> _ingredients = [];
  final List<String> _preparationSteps = [];
  RecipeTypeModel? _selectedType;
  String _imagePath = '';

  late RecipeService recipeService;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    _typeController.dispose();
    _ingredientNameController.dispose();
    _ingredientQuantityController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    recipeService = Provider.of<RecipeService>(context, listen: false);

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
            onPressed: () => goToHome(),
          ),
          backgroundColor: const Color(0xFF04724D),
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      'Informations générales',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF04724D),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title input
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Titre de la recette',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer le titre de la recette';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Description input
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description de la recette',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une description';
                        }
                        return null;
                      },
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Time to cook input
                    TextFormField(
                      controller: _timeController,
                      decoration: const InputDecoration(
                        labelText: 'Temps de réalisation (en minutes)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer le temps de préparation';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Veuillez entrer un nombre valide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    FutureBuilder<List<RecipeTypeModel>>(
                      future: recipeService.getRecipeTypes(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<RecipeTypeModel>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          // Improved error handling
                          return Center(
                              child: Text(
                                  'Error loading recipe types: ${snapshot.error}',
                                  style: TextStyle(color: Colors.red)));
                        } else if (snapshot.hasData) {
                          final recipeTypes = snapshot.data!;
                          // Dropdown directly without ListView
                          return DropdownButtonFormField<RecipeTypeModel>(
                            value: _selectedType,
                            decoration: const InputDecoration(
                              labelText: 'Type de recette',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (RecipeTypeModel? newValue) {
                              setState(() {
                                _selectedType = newValue!;
                              });
                            },
                            items: recipeTypes
                                .map<DropdownMenuItem<RecipeTypeModel>>(
                                    (RecipeTypeModel value) {
                              return DropdownMenuItem<RecipeTypeModel>(
                                value: value,
                                child: Text(value.typeName),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Veuillez sélectionner un type de recette';
                              }
                              return null;
                            },
                          );
                        } else {
                          // Handle the case where no data is returned
                          return const Center(
                              child: Text('No recipe types available'));
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    ImagePickerButton(onImagePicked: _handleImagePicked),

                    const SizedBox(height: 16),

                    // Ingredients list
                    const Text(
                      'Ingrédients',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF04724D),
                      ),
                    ),
                    ..._buildIngredientListTiles(),
                    TextFormField(
                      controller: _ingredientNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom de l\'ingrédient',
                      ),
                    ),
                    TextFormField(
                      controller: _ingredientQuantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantité',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addIngredient,
                      child: const Text('Ajouter un ingrédient'),
                    ),
                    const SizedBox(height: 16),

// Preparation steps
                    const Text(
                      'Préparation',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF04724D),
                      ),
                    ),
                    const SizedBox(height: 8),

                    _buildPreparationStepTiles(),

                    TextFormField(
                      controller: _stepController,
                      decoration: const InputDecoration(
                        labelText: "Description de l'étape",
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addPreparationStep,
                      child: const Text('Ajouter une étape'),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveRecipe,
                      child: const Text('Enregistrer la recette'),
                    ),
                  ],
                ),
              ),
            ])));
  }

  void _addIngredient() {
    if (_ingredientNameController.text.isNotEmpty &&
        _ingredientQuantityController.text.isNotEmpty) {
      setState(() {
        _ingredients.add(Ingredient(
          name: _ingredientNameController.text,
          quantity: _ingredientQuantityController.text,
        ));
        _ingredientNameController.clear();
        _ingredientQuantityController.clear();
      });
    }
  }

  void _addPreparationStep() {
    if (_stepController.text.isNotEmpty) {
      setState(() {
        _preparationSteps.add(_stepController.text);
        _stepController.clear();
      });
    }
  }

  List<Widget> _buildIngredientListTiles() {
    return _ingredients.map((ingredient) {
      return ListTile(
        title: Text(ingredient.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(ingredient.quantity),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _removeIngredient(ingredient),
            ),
          ],
        ),
      );
    }).toList();
  }

  void _removeIngredient(Ingredient ingredient) {
    setState(() {
      _ingredients.remove(ingredient);
    });
  }

  Widget _buildPreparationStepTiles() {
    return ReorderableColumn(
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final String item = _preparationSteps.removeAt(oldIndex);
          _preparationSteps.insert(newIndex, item);
        });
      },
      children: <Widget>[
        for (int index = 0; index < _preparationSteps.length; index++)
          ListTile(
            key: Key('$_preparationSteps[index]$index'),
            title: Text(_preparationSteps[index]),
            trailing: Wrap(
              spacing: 12, // space between two icons
              children: <Widget>[
                // Icon to delete the step
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => _removePreparationStep(index),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _removePreparationStep(int index) {
    setState(() {
      _preparationSteps.removeAt(index);
    });
  }

  void _handleImagePicked(String path) {
    setState(() {
      _imagePath = path;
    });
  }

  void goToHome() {
    Navigator.pop(context);
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      // Assuming you have a function to handle saving the recipe
      // You would also handle image picking and uploading in this function
      final newRecipe = Recipe(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        preparationTime: int.parse(_timeController.text),
        ingredients: _ingredients,
        preparationSteps: _preparationSteps,
        recipeType: _selectedType!,
        imagePath: _imagePath,
      );
      // Save the new recipe to Hive box
      recipeService.addRecipe(newRecipe);

      // Clear the form after saving the recipe
      _clearForm();
      goToHome();
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _timeController.clear();
// Clear other controllers if necessary
    _ingredients.clear();
    _preparationSteps.clear();
    setState(() {
      _selectedType = null;
      _imagePath = '';
    });
  }
}
