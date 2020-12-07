import 'package:flutter/widgets.dart';

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height/4);
    path.lineTo(size.width*3/4, size.height/4);
    path.quadraticBezierTo(size.width*3/4, size.height, size.width*2/3, size.height);
    path.lineTo(size.width*1/3, size.height);
    path.quadraticBezierTo(size.width*1/4, size.height, size.width*1/4, size.height/2);
    path.lineTo(0, size.height/2);
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}