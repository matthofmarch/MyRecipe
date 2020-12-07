import 'dart:io';

import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/screens/addrecipe/cubit/addrecipe_cubit.dart';
import 'package:recipe_repository/recipe_repository.dart';

class AddRecipe extends StatelessWidget {
  final _nameController = TextEditingController()..text = "Name";
  final _descriptionController = TextEditingController()..text = "Description";
  final picker = ImagePicker();
  File _image = null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddrecipeCubit>(
      create: (context) =>
          AddrecipeCubit(RepositoryProvider.of<RecipeRepository>(context)),
      child: BlocBuilder<AddrecipeCubit, AddrecipeState>(
          builder: (context, state) {
            if(state is AddrecipeInitial)
              _image = state.image;

        return Scaffold(
          appBar: AppBar(
            title: Text("MyRecipes"),
            toolbarHeight: 40,
          ),
          body: Stack(
            children: [
              _makeContent(context),
              if (state is AddrecipeSubmitting) CircularProgressIndicator()
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(context.platformIcons.checkMark),
            onPressed: () {
              RepositoryProvider.of<RecipeRepository>(context).addRecipe(
                  Recipe(
                    name: _nameController.text.toString(),
                    description: _nameController.text.toString(),
                    cookingTimeInMin: 20,
                    ingredientNames: [],
                    addToGroupPool: true,
                  ),
                  _image);
            },
          ),
        );
      }),
    );
  }

  _makeContent(BuildContext context) {
    return Column(
      children: [
        PlatformTextField(
          controller: _nameController,
          material: (context, platform) => MaterialTextFieldData(
              decoration: InputDecoration(labelText: "Name")),
          cupertino: (context, platform) =>
              CupertinoTextFieldData(placeholder: "Name"),
        ),
        PlatformTextField(
          controller: _descriptionController,
          maxLines: 10,
          material: (context, platform) => MaterialTextFieldData(
              decoration: InputDecoration(labelText: "Name")),
          cupertino: (context, platform) =>
              CupertinoTextFieldData(placeholder: "Name"),
        ),
        Row(
          children: [
            Text("Add image "),
            TextButton(
                onPressed: () async {
                  var picked =
                      await picker.getImage(source: ImageSource.camera);
                  if (picked != null) {
                    BlocProvider.of<AddrecipeCubit>(context)
                        .useImage(File(picked.path));
                  }
                },
                child: Icon(context.platformIcons.photoCamera)),
            TextButton(
                onPressed: () async {
                  var picked =
                      await picker.getImage(source: ImageSource.gallery);
                  if (picked != null) {
                    BlocProvider.of<AddrecipeCubit>(context)
                        .useImage(File(picked.path));
                  }
                },
                child: Icon(context.platformIcons.bookmark)),
          ],
        ),
        if (_image != null) Image.file(_image)
      ],
    );
  }
}
