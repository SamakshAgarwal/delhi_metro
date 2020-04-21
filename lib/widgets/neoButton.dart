import 'dart:async';

import 'package:delhimetro/colors/colors.dart';
import 'package:flutter/material.dart';

class NeoButton extends StatefulWidget {
  final Widget child;
  final double radius;
  final void Function() onTap;
  final void Function() onLongPress;

  NeoButton({this.child, this.radius = 10, this.onTap,this.onLongPress})
      : assert(child != null),assert(onTap!=null);

  @override
  _NeoButtonState createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          setState(() {
            _selected = true;
          });
          Timer(Duration(milliseconds: 100), () {
            setState(() {
              _selected = false;
            });
          });
          widget.onTap();
        },
        onLongPress: () {
          setState(() {
            _selected = true;
          });
          if(widget.onLongPress!=null)
            widget.onLongPress();
        },
        onLongPressEnd: (det) {
          setState(() {
            _selected = false;
          });
        },
        child: Container(
          width: 88,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
            color: backgroundColor,
            boxShadow: !_selected
                ? [
                    BoxShadow(
                        color: bottomShadowColor,
                        offset: Offset(5.0, 5.0),
                        blurRadius: 8),
                    BoxShadow(
                        color: topShadowColor,
                        offset: Offset(-5.0, -5),
                        blurRadius: 8)
                  ]
                : [
                    BoxShadow(
                        color: bottomShadowColor,
                        offset: Offset(-5.0, -5.0),
                        blurRadius: 8),
                    BoxShadow(
                        color: topShadowColor,
                        offset: Offset(5.0, 5.0),
                        blurRadius: 8)
                  ],
          ),
          child: Center(child: widget.child),
        ),
      );
}
