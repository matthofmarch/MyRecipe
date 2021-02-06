import 'package:flutter/widgets.dart';

class CustomAbrounding extends StatelessWidget {
  ImageProvider imageProvider;
  double radius;
  BoxFit boxFit;

  Widget child;

  CustomAbrounding.widget({@required this.child, this.radius = 8.0});

  CustomAbrounding.provider({@required this.imageProvider, this.radius = 8.0, this.boxFit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: child ?? Image(image: imageProvider, fit: boxFit),
      borderRadius: BorderRadius.all(
        Radius.circular(radius),
      ),
    );
  }
}
