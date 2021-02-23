import 'package:flutter/widgets.dart';

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    var baseLineHeight = size.height * 1 / 3;
    var intermediateHeight = (size.height + baseLineHeight) / 2;

    var bezierXStretch = 10;

    var contentXArm = size.width * 0.17;
    var lower = size.width / 2 - contentXArm;
    var rise = size.width / 2 + contentXArm;

    path.lineTo(0, baseLineHeight);
    path.lineTo(lower - bezierXStretch, baseLineHeight);
    path.quadraticBezierTo(lower, baseLineHeight, lower, intermediateHeight);
    path.quadraticBezierTo(
        lower, size.height, lower + bezierXStretch, size.height);
    path.lineTo(rise - bezierXStretch, size.height);
    path.quadraticBezierTo(rise, size.height, rise, intermediateHeight);
    path.quadraticBezierTo(
        rise, baseLineHeight, rise + bezierXStretch, baseLineHeight);
    path.lineTo(size.width, baseLineHeight);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class AppBarBorder extends ContinuousRectangleBorder {
  final double relativeUpperHeight;

  AppBarBorder({this.relativeUpperHeight = 1 / 3});

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    var path = Path();
    var baseLineHeight = rect.height * relativeUpperHeight;
    var intermediateHeight = (rect.height + baseLineHeight) / 2;

    var bezierXStretch = 10;

    var contentXArm = rect.width * 0.17;
    var lower = rect.width / 2 - contentXArm;
    var rise = rect.width / 2 + contentXArm;

    path.lineTo(0, baseLineHeight);
    path.lineTo(lower - bezierXStretch, baseLineHeight);
    path.quadraticBezierTo(lower, baseLineHeight, lower, intermediateHeight);
    path.quadraticBezierTo(
        lower, rect.height, lower + bezierXStretch, rect.height);
    path.lineTo(rise - bezierXStretch, rect.height);
    path.quadraticBezierTo(rise, rect.height, rise, intermediateHeight);
    path.quadraticBezierTo(
        rise, baseLineHeight, rise + bezierXStretch, baseLineHeight);
    path.lineTo(rect.width, baseLineHeight);
    path.lineTo(rect.width, 0);
    path.lineTo(0, 0);

    path.close();
    return path;
  }
}

class SlimAppBarBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    var path = Path();
    var baseLineHeight = rect.height * 1 / 3;
    var intermediateHeight = (rect.height + baseLineHeight) / 2;

    var bezierXStretch = 10;

    var contentXArm = rect.width * 0.17;
    var lower = rect.width / 2 - contentXArm;
    var rise = rect.width / 2 + contentXArm;

    path.moveTo(lower, 0);
    path.lineTo(lower, intermediateHeight);
    path.quadraticBezierTo(
        lower, rect.height, lower + bezierXStretch, rect.height);
    path.lineTo(rise - bezierXStretch, rect.height);
    path.quadraticBezierTo(rise, rect.height, rise, intermediateHeight);
    path.lineTo(rise, baseLineHeight);
    path.lineTo(rise, 0);
    path.lineTo(lower, 0);

    path.close();
    return path;
  }
}
