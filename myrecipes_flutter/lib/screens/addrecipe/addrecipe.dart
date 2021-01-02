import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/screens/addrecipe/cubit/addrecipe_cubit.dart';
import 'package:recipe_repository/recipe_repository.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddRecipe extends StatelessWidget {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cookingTimeInMinController = TextEditingController();

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddrecipeCubit>(
      create: (context) => AddrecipeCubit(
          RepositoryProvider.of<RecipeRepository>(context),
          RepositoryProvider.of<IngredientRepository>(context)),
      child: BlocBuilder<AddrecipeCubit, AddrecipeState>(
          builder: (context, state) {
        if (state is AddrecipeInitial) {
          BlocProvider.of<AddrecipeCubit>(context).reload();
          return Container(child: Center(child: CircularProgressIndicator()));
        }
        if (state is AddrecipeSuccess) {
          Navigator.of(context).pop();
          return Container();
        }

        if (state is AddrecipeInteraction) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text("MyRecipes"),
                  toolbarHeight: 40,
                ),
                body: _makeForm(context, state),
                floatingActionButton: FloatingActionButton(
                  child: Icon(context.platformIcons.checkMark),
                  onPressed: () {
                    BlocProvider.of<AddrecipeCubit>(context).submit(
                        Recipe(
                          name: _nameController.text.toString(),
                          description: _nameController.text.toString(),
                          cookingTimeInMin:
                              int.tryParse(_cookingTimeInMinController.text) ?? 0,
                          ingredientNames: state?.selectedIngredients
                              ?.map((e) => state.ingredients[e]),
                          addToGroupPool: true,
                        ),
                        state is AddrecipeInteraction ? state.image : null);
                  },
                ),
              ),
              if(state is AddrecipeSubmitting) Container(child: Center(child: CircularProgressIndicator())),
            ],
          );
        }
        return null;
      }),
    );
  }

  _makeForm(BuildContext context, AddrecipeInteraction state) {
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

  _makeInformationCard(BuildContext context, AddrecipeInteraction state)=> Card(
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
                child: PlatformTextField(
                  controller: _nameController,
                  material: (context, platform) =>
                      MaterialTextFieldData(
                          decoration:
                          InputDecoration(labelText: "Name")),
                  cupertino: (context, platform) =>
                      CupertinoTextFieldData(placeholder: "Name"),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Flexible(
                flex: 1,
                child: PlatformTextField(
                  controller: _cookingTimeInMinController,
                  keyboardType: TextInputType.number,
                  material: (context, platform) =>
                      MaterialTextFieldData(
                          decoration: InputDecoration(
                              labelText: "Cooking time")),
                  cupertino: (context, platform) =>
                      CupertinoTextFieldData(
                        placeholder: "Cooking time",
                      ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          PlatformTextField(
            controller: _descriptionController,
            minLines: 1,
            material: (context, platform) => MaterialTextFieldData(
                decoration:
                InputDecoration(labelText: "Description")),
            cupertino: (context, platform) =>
                CupertinoTextFieldData(
                  placeholder: "Description",
                ),
          ),
        ],
      ),
    ),
  );

  _makeImageCard(BuildContext context, AddrecipeInteraction state)=> Card(
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
          state is AddrecipeInteraction && state.image != null
              ? ClipRRect(
              borderRadius:
              BorderRadius.all(Radius.circular(20)),
              child: Image.file(state.image))
              : Text("No Image selected"),
        ],
      ),
    ),
  );

  _makeGalleryButton(BuildContext context)=>TextButton(
      onPressed: () async {
        var picked = await picker.getImage(
            source: ImageSource.gallery);
        if (picked != null) {
          BlocProvider.of<AddrecipeCubit>(context)
              .reload(image: File(picked.path));
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
            style:
            Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ));



  _makeCameraButton(BuildContext context) =>TextButton(
      onPressed: () async {
        var pickedPath = (await picker.getImage(
            source: ImageSource.camera,
            maxWidth: 1920,
            maxHeight: 1280))
            .path;

        if (pickedPath != null && !kIsWeb) {
          pickedPath = (await ImageCropper.cropImage(
              sourcePath: pickedPath,
              aspectRatio: CropAspectRatio(
                  ratioX: 3, ratioY: 2)))
              .path;
        }
        BlocProvider.of<AddrecipeCubit>(context).reload(
            image: pickedPath == null
                ? null
                : File(pickedPath));
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

  _makeIngredientsCard(BuildContext context, AddrecipeInteraction state) => Card(
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
                .map((e) => DropdownMenuItem<String>(
                value: e, child: Text(e)))
                .toList(),
            hint: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Select any"),
            ),
            searchHint: "Select any",
            onChanged: (List<int> selectedItems) {
              BlocProvider.of<AddrecipeCubit>(context)
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
            clearIcon: Icon(context.platformIcons.delete),
          )
        ],
      ),
    ),
  );



}
