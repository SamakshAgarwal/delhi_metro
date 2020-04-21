import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Colors.white,
      child: PhotoView(
        imageProvider: AssetImage('assets/map.jpg'),
        minScale: 0.3,
        initialScale: .3,
        enableRotation: false,
        backgroundDecoration: BoxDecoration(color: Colors.white),
      ),
    );
  }
}
