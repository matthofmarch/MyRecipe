import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/screens/update_recipe/cubit/update_recipe_cubit.dart';
import 'package:myrecipes_flutter/views/appbar/CustomDefaultAppBar.dart';
import 'package:myrecipes_flutter/views/util/RoundedImage.dart';
import 'package:recipe_repository/recipe_repository.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class UpdateRecipe extends StatelessWidget {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cookingTimeInMinController = TextEditingController();
  final picker = ImagePicker();

  Recipe initialRecipe;

  UpdateRecipe(this.initialRecipe);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateRecipeCubit>(
      create: (context) => UpdateRecipeCubit(
          RepositoryProvider.of<RecipeRepository>(context),
          RepositoryProvider.of<IngredientRepository>(context)),
      child: BlocBuilder<UpdateRecipeCubit, UpdateRecipeState>(
          builder: (context, state) {
        if (state is UpdateRecipeInitial) {
          BlocProvider.of<UpdateRecipeCubit>(context).initAsync(initialRecipe);
          return Center(child: CircularProgressIndicator());
        }
        if (state is UpdateRecipeSubmitting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is UpdateRecipeInteraction) {
          _nameController.text = state.name;
          _descriptionController.text = state.description;
          _cookingTimeInMinController.text = state.cookingTimeInMin.toString();
          return _makeRecipeInteraction(context, state);
        }
        if (state is UpdateRecipeSuccess) {
          Future.delayed(
              Duration(milliseconds: 500), () => Navigator.of(context).pop(state.recipe));
          return Center(child: Icon(context.platformIcons.checkMark));
        }
        if (state is UpdateRecipeFailure) {
          Future.delayed(
              Duration(milliseconds: 500), () => Navigator.of(context).pop(null));
          return Center(child: Icon(context.platformIcons.error, color: Theme.of(context).errorColor,));
        }
        return null;
      }),
    );
  }

  Widget _makeRecipeInteraction(
      BuildContext context, UpdateRecipeInteraction state) {
    return Scaffold(
      appBar: CustomDefaultAppBar(title: Text("Update Recipe"),),
      body: _makeForm(context, state),
      floatingActionButton: FloatingActionButton(
        child: Icon(context.platformIcons.checkMark),
        onPressed: () {
          BlocProvider.of<UpdateRecipeCubit>(context).submit(
              _nameController.text,
              int.parse(_cookingTimeInMinController.text),
              _descriptionController.text,
              initialRecipe.image);
        },
      ),
    );
  }

  _makeForm(BuildContext context, UpdateRecipeInteraction state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              _makeInformationCard(context, state),
              SizedBox(
                height: 8,
              ),
              _makeImageCard(context, state),
              SizedBox(
                height: 8,
              ),
              _makeIngredientsCard(context, state)
            ],
          ),
        ],
      ),
    );
  }

  _makeInformationCard(BuildContext context, UpdateRecipeInteraction state) =>
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
                    child: TextFormField(
                      controller: _nameController,
                      onChanged:(value) =>  BlocProvider.of<UpdateRecipeCubit>(context).name = value,
                      decoration: new InputDecoration(
                          labelText: "Name"),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    flex: 1,
                    child: TextFormField(
                      controller: _cookingTimeInMinController,
                      onChanged:(value) =>  BlocProvider.of<UpdateRecipeCubit>(context).cookingTimeInMin = int.parse(value),
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          labelText: "Duration"),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: _descriptionController,
                onChanged:(value) =>  BlocProvider.of<UpdateRecipeCubit>(context).description = value,
                decoration: new InputDecoration(
                    labelText: "Description"),
              ),
            ],
          ),
        ),
      );

  Widget _makeImageCard(BuildContext context, UpdateRecipeInteraction state) {
    Image image;
    String oldImageUri = state.oldImageUri;
    if (oldImageUri != null) image = Image.network(oldImageUri);
    var selectedImage = state.selectedImage;
    if (selectedImage != null) image = Image.file(selectedImage);
    return Card(
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
            if(image != null) CustomAbrounding.image(image),
            // ClipRRect(
            //     borderRadius: BorderRadius.all(Radius.circular(20)),
            //     child: image ?? Text("No Image selected")),
          ],
        ),
      ),
    );
  }

  _makeGalleryButton(BuildContext context) => TextButton(
      onPressed: () async {
        var pickedPath = (await picker.getImage(
                source: ImageSource.gallery, maxWidth: 1920, maxHeight: 1280))
            .path;

        if (pickedPath != null && !kIsWeb) {
          pickedPath = (await ImageCropper.cropImage(
                  sourcePath: pickedPath,
                  aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2)))
              .path;
        }
      },
      child: Row(
        children: [
          Icon(
            context.platformIcons.collections,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(
            " Gallery",
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ));

  _makeCameraButton(BuildContext context) => TextButton(
      onPressed: () async {

        var pickedPath = (await picker.getImage(
                source: ImageSource.camera, maxWidth: 1920, maxHeight: 1280))
            .path;

        if (pickedPath != null && !kIsWeb) {
          pickedPath = (await ImageCropper.cropImage(
                  sourcePath: pickedPath,
                  aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2)))
              .path;
        }
        BlocProvider.of<UpdateRecipeCubit>(context)
            .selectedImage = File(pickedPath);
      },
      child: Row(
        children: [
          Icon(
            context.platformIcons.photoCamera,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(
            " Camera",
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ));

  _makeIngredientsCard(BuildContext context, UpdateRecipeInteraction state) =>
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
                selectedItems: state.selectedIngredients
                    .map<int>((e) =>
                        state.ingredients.indexWhere((element) => element == e))
                    .toList(),
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
                  BlocProvider.of<UpdateRecipeCubit>(context)
                      .selectedIngredients(state.ingredients
                          .asMap()
                          .entries
                          .where((entry) => selectedItems.contains(entry.key))
                          .map((entry) => entry.value)
                          .toList());
                },
                searchFn: (String keyword, items) {
                  List<int> results = [];
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
                clearIcon: Icon(context.platformIcons.delete),
              )
            ],
          ),
        ),
      );
}
