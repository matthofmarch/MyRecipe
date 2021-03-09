import 'package:flutter/widgets.dart';

class CustomAbrounding extends StatelessWidget {
  ImageProvider imageProvider;
  double radius;
  BoxFit boxFit;

  Widget image;

  CustomAbrounding.image(this.image, {this.radius = 8.0});

  CustomAbrounding.provider(this.imageProvider,
      {this.radius = 8.0, this.boxFit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: image ?? Image(image: imageProvider, fit: boxFit),
      borderRadius: BorderRadius.all(
        Radius.circular(radius),
      ),
    );
  }
}
