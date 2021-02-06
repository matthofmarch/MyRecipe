import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myrecipes_flutter/views/util/RoundedImage.dart';

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
                Image(image: imageProvider),
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Text("Could not load image"),
          )
        : CustomAbrounding.provider(imageProvider: AssetImage("assets/placeholder-image.png"));
  }
}
