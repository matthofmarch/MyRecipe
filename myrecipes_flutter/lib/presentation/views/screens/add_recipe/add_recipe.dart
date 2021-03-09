import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myrecipes_flutter/domain/models/recipe.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/ingredient_repository/ingredient_repository.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/recipe_repository/recipe_repository.dart';
import 'package:myrecipes_flutter/presentation/view_models/screens/add_recipe/add_recipe_cubit.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddRecipe extends StatelessWidget {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cookingTimeInMinController = TextEditingController();

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddRecipeCubit>(
      create: (context) => AddRecipeCubit(
          RepositoryProvider.of<RecipeRepository>(context),
          RepositoryProvider.of<IngredientRepository>(context)),
      child: BlocBuilder<AddRecipeCubit, AddRecipeState>(
          builder: (context, state) {
        if (state is AddRecipeInitial) {
          BlocProvider.of<AddRecipeCubit>(context).reload();
          return Container(child: Center(child: CircularProgressIndicator()));
        }
        if (state is AddRecipeInteraction) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text("MyRecipes"),
                  toolbarHeight: 40,
                ),
                body: _makeForm(context, state),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.check),
                  onPressed: () {
                    BlocProvider.of<AddRecipeCubit>(context).submit(
                        Recipe(
                          name: _nameController.text.toString(),
                          description: _nameController.text.toString(),
                          cookingTimeInMin:
                              int.tryParse(_cookingTimeInMinController.text) ??
                                  0,
                          ingredientNames: state?.selectedIngredients
                              ?.map((e) => state.ingredients[e]),
                          addToGroupPool: true,
                        ),
                        state is AddRecipeInteraction ? state.image : null);
                  },
                ),
              ),
              if (state is AddRecipeSubmitting)
                Container(child: Center(child: CircularProgressIndicator())),
            ],
          );
        }
        if (state is AddRecipeSuccess) {
          Future.delayed(Duration(milliseconds: 500),
              () => Navigator.of(context).pop(state.recipe));
          return Center(child: Icon(Icons.check_circle));
        }
        if (state is AddRecipeFailure) {
          Future.delayed(Duration(milliseconds: 500),
              () => Navigator.of(context).pop(null));
          return Center(
              child: Icon(
            Icons.error,
            color: Theme.of(context).errorColor,
          ));
        }
        return null;
      }),
    );
  }

  _makeForm(BuildContext context, AddRecipeInteraction state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              Text(
                "Add a recipe",
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 8,
              ),
              _makeInformationCard(context, state),
              _makeImageCard(context, state),
              _makeIngredientsCard(context, state)
            ],
          ),
        ],
      ),
    );
  }

  _makeInformationCard(BuildContext context, AddRecipeInteraction state) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Information",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Divider(),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: "Name")),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    flex: 1,
                    child: TextField(
                      controller: _cookingTimeInMinController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Cooking time"),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: 7,
                  decoration: InputDecoration(labelText: "Description")),
            ],
          ),
        ),
      );

  _makeImageCard(BuildContext context, AddRecipeInteraction state) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Image",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _makeCameraButton(context),
                  _makeGalleryButton(context)
                ],
              ),
              state is AddRecipeInteraction && state.image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Image.file(state.image))
                  : Text("No Image selected"),
            ],
          ),
        ),
      );

  _makeGalleryButton(BuildContext context) => IconButton(
        icon: Icon(Icons.collections),
        tooltip: "Gallery",
        onPressed: () async {
          var picked = await picker.getImage(source: ImageSource.gallery);
          if (picked != null) {
            BlocProvider.of<AddRecipeCubit>(context)
                .reload(image: File(picked.path));
          }
        },
      );

  _makeCameraButton(BuildContext context) => IconButton(
        onPressed: () async {
          String pickedPath;
          try {
            pickedPath = (await picker.getImage(
                    source: ImageSource.camera,
                    maxWidth: 1024,
                    maxHeight: 1024))
                .path;
          } on PlatformException {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Your device does not have a camera!")));
            return;
          }

          if (pickedPath != null && !kIsWeb) {
            pickedPath = (await ImageCropper.cropImage(
                    sourcePath: pickedPath,
                    aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2)))
                .path;
          }
          BlocProvider.of<AddRecipeCubit>(context)
              .reload(image: pickedPath == null ? null : File(pickedPath));
        },
        icon: Icon(
          Icons.camera_alt,
          color: Theme.of(context).colorScheme.primary,
        ),
        tooltip: "Cam",
      );

  _makeIngredientsCard(BuildContext context, AddRecipeInteraction state) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Ingredients",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Divider(),
              SearchableDropdown.multiple(
                items: state.ingredients
                    .map((e) =>
                        DropdownMenuItem<String>(value: e, child: Text(e)))
                    .toList(),
                hint: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Select any"),
                ),
                searchHint: "Select any",
                onChanged: (List<int> selectedItems) {
                  BlocProvider.of<AddRecipeCubit>(context)
                      .silentSetSelectedIngredients(selectedItems);
                },
                searchFn: (String keyword, items) {
                  final results = List<int>();
                  int i = 0;
                  items.forEach((item) {
                    String itemValue;
                    if ((itemValue = item?.value.toString()) != null &&
                        itemValue
                            .toLowerCase()
                            .contains(keyword.toLowerCase())) {
                      results.add(i);
                    }
                    ++i;
                  });
                  return results;
                },
                closeButton: "Select",
                doneButton: SizedBox.shrink(),
                isExpanded: true,
                dialogBox: true,
                clearIcon: Icon(Icons.delete),
              )
            ],
          ),
        ),
      );
}
