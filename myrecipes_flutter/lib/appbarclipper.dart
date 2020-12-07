import 'package:flutter/widgets.dart';

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    var baseLineHeight = size.height*1/3;
    var intermediateHeight = (size.height+baseLineHeight)/2;

    var bezierXStretch = 10;

    var contentXArm = size.width*0.17;
    var lower = size.width/2-contentXArm;
    var rise = size.width/2+contentXArm;

    path.lineTo(0, baseLineHeight);
    path.lineTo(lower-bezierXStretch, baseLineHeight);
    path.quadraticBezierTo(lower, baseLineHeight, lower, intermediateHeight);
    path.quadraticBezierTo(lower, size.height, lower+bezierXStretch, size.height);
    path.lineTo(rise-bezierXStretch, size.height);
    path.quadraticBezierTo(rise, size.height, rise, intermediateHeight);
    path.quadraticBezierTo(rise, baseLineHeight, rise+bezierXStretch, baseLineHeight);
    path.lineTo(size.width, baseLineHeight);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}