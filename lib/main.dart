import 'file:///C:/Users/Samaksh/FlutterProjects/delhi_metro/lib/screens/homepage.dart';
import 'package:delhimetro/services/loadDb.dart';
import 'package:delhimetro/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Services>(
        create: (BuildContext context) => Services(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home:FutureBuilder(
              future: LoadDb().loadDb(),
              builder: (context, snapshot) {
                if (snapshot.data == null)
                  return Scaffold(
                    body: Container(
                      child: Center(
                        child: Text('Loading Database...'),
                      ),
                    ),
                  );
                return HomePage();
              }),
        ),
      );
  }
}
