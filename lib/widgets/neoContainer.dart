import 'package:delhimetro/colors/colors.dart';
import 'package:flutter/material.dart';

class NeoContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final BoxConstraints constraints;

  NeoContainer({this.child,this.height,this.width,this.constraints});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      height: height,
      width: width,
      constraints: constraints,
      decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
                color: bottomShadowColor,
                offset: Offset(5.0, 5.0),
                blurRadius: 8),
            BoxShadow(
                color: topShadowColor, offset: Offset(-5.0, -5), blurRadius: 8)
          ],
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
    );
  }
}
