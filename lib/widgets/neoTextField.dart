import 'package:delhimetro/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NeoTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final void Function(String text) onChanged;
  final void Function() onTap;
  final void Function() onEditingComplete;
  final void Function(String text) onSubmitted;
  final FocusNode focusNode;

  NeoTextField(
      {Key key,this.hint = 'Start',
      this.controller,
      this.onChanged,
      this.onTap,
      this.onEditingComplete,
      this.onSubmitted,
      this.focusNode})
      : assert(controller != null),super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      height: 42,
      decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
                color: topShadowColor, offset: Offset(5, 5), spreadRadius: -2),
            BoxShadow(
                color: bottomShadowColor,
                offset: Offset(-5, -5),
                spreadRadius: -2)
          ],
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        child: TextField(
          controller: controller,
          enableSuggestions: true,
          onChanged: onChanged,
          onTap: onTap,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          focusNode: focusNode,
          cursorColor: accentColor,
          style: TextStyle(color: accentColor),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: bottomShadowColor,
              )),
        ),
      ),
    );
  }
}
