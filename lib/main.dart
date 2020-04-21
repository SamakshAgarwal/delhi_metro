import 'file:///C:/Users/Samaksh/FlutterProjects/delhi_metro/lib/screens/homepage.dart';
import 'package:delhimetro/services/loadDb.dart';
import 'package:delhimetro/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoadDb().loadDb();
    Services().openDB();
    return ChangeNotifierProvider<Services>(
      create: (BuildContext context) => Services(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
