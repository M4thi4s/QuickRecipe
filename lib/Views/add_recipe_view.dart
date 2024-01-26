import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import '../Configs/Config.dart';
import '../Widgets/image_picker_button.dart';
import '../services/recipe_service.dart';
import '../models/ingredient_model.dart';
import '../models/recipe_model.dart';
import '../models/recipe_type_model.dart';

class AddRecipePage extends StatefulWidget {
  final Recipe? existingRecipe;

  const AddRecipePage({Key? key, this.existingRecipe}) : super(key: key);

  @override
  AddRecipePageState createState() => AddRecipePageState();
}

class AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();
  final _typeController = TextEditingController();
  final _ingredientNameController = TextEditingController();
  final _ingredientQuantityController = TextEditingController();
  final _stepController = TextEditingController();

  String _id = ''; // Id is set only if the recipe is being edited

  List<Ingredient> _ingredients = [];
  List<String> _preparationSteps = [];
  String? _selectedType;
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
  void initState() {
    super.initState();
    if (widget.existingRecipe != null) {
      _initializeFormWithExistingRecipe();
    }
  }

  @override
  Widget build(BuildContext context) {
    recipeService = Provider.of<RecipeService>(context, listen: false);

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
            onPressed: () => goToHome(),
          ),
          backgroundColor: Config.primaryColor,
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
                        color: Config.primaryColor,
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
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center( child: CircularProgressIndicator() );
                        } else if (snapshot.hasError) {
                          // Improved error handling
                          return Center(
                              child: Text(
                                  'Error loading recipe types: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.red)));
                        } else if (snapshot.hasData) {
                          final recipeTypes = snapshot.data!;
                          // Dropdown directly without ListView
                          return DropdownButtonFormField<RecipeTypeModel>(
                            value: recipeTypes.firstWhere((element) => element.id == _selectedType, orElse: () => recipeTypes.first),
                            decoration: const InputDecoration(
                              labelText: 'Type de recette',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (RecipeTypeModel? newValue) {
                              setState(() {
                                _selectedType = newValue?.id;
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
                          // Should never happen
                          return const Center(
                              child: Text('No recipe types available'));
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    ImagePickerButton(onImagePicked: _handleImagePicked, existingImage: _imagePath),

                    const SizedBox(height: 16),

                    // Ingredients list
                    const Text(
                      'Ingrédients',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Config.primaryColor,
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
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Config.primaryColor,
                      ),
                      child: const Text('Ajouter un ingrédient')
                    ),
                    const SizedBox(height: 16),

// Preparation steps
                    const Text(
                      'Préparation',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Config.primaryColor,
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
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Config.primaryColor,
                        ),
                      child: const Text('Ajouter une étape')
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveRecipe,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Config.primaryColor,
                        ),
                      child: const Text('Enregistrer la recette')
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
    Navigator.pushNamed(context, '/');
  }

  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      // Check if the user has entered at least one ingredient and one preparation step
      if (_ingredients.isEmpty || _preparationSteps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_ingredients.isEmpty
                ? 'Ajoutez au moins un ingrédient.'
                : 'Ajoutez au moins une étape de préparation.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Clone the ingredients and preparation steps lists
      List<Ingredient> clonedIngredients = List<Ingredient>.from(
        _ingredients.map(
              (ingredient) => Ingredient(
            name: ingredient.name,
            quantity: ingredient.quantity,
          ),
        ),
      );
      List<String> clonedPreparationSteps = List<String>.from(_preparationSteps);

      // Create the new Recipe instance
      final newRecipe = Recipe(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        preparationTime: int.parse(_timeController.text),
        ingredients: clonedIngredients,
        preparationSteps: clonedPreparationSteps,
        recipeTypeId: _selectedType!, // _selectedType is never null at this point
        imagePath: _imagePath,
      );

      if (widget.existingRecipe != null) {
        // Update the existing recipe
        newRecipe.id = _id;
        await recipeService.updateRecipe(newRecipe);
      } else {
        // Add the new recipe
        await recipeService.addRecipe(newRecipe);
      }

      // Clear the form after saving the recipe
      _clearForm();
      goToHome();
    }
  }



  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _timeController.clear();
    _ingredients.clear();
    _preparationSteps.clear();
    setState(() {
      _selectedType = null;
      _imagePath = '';
    });

  }

  Future<void> _initializeFormWithExistingRecipe() async {
    // Initialize the form with the existing recipe data
    final recipe = widget.existingRecipe!;
    _id = recipe.id;
    _titleController.text = recipe.title;
    _descriptionController.text = recipe.description;
    _timeController.text = recipe.preparationTime.toString();
    _selectedType =  recipe.recipeTypeId;
    _ingredients = List<Ingredient>.from(recipe.ingredients);
    _preparationSteps = List<String>.from(recipe.preparationSteps);
    _imagePath = recipe.imagePath;
  }
}