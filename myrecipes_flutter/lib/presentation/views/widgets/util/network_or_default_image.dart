import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/util/rounded_image.dart';

class NetworkOrDefaultImage extends StatelessWidget {
  final imageUri;

  NetworkOrDefaultImage(this.imageUri);

  @override
  Widget build(BuildContext context) {
    return imageUri != null
        ? CachedNetworkImage(
            imageUrl: imageUri,
            fit: BoxFit.fitWidth,
            imageBuilder: (context, imageProvider) =>
                CustomAbrounding.provider(imageProvider,radius: 0,),
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Text("Could not load image"),
          )
        : CustomAbrounding.provider(AssetImage("assets/placeholder-image.png"));
  }
}
