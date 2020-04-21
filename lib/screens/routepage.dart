import 'package:delhimetro/colors/colors.dart';
import 'package:delhimetro/services/services.dart';
import 'package:delhimetro/widgets/neoContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutePage extends StatefulWidget {
  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  var dim;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dim = MediaQuery.of(context).size.width / 3;
    Services services = Provider.of(context);
    services.getLineColor();
    return Scaffold(
        backgroundColor: backgroundColor,
        body: FutureBuilder(
            future: services.getRouteObject(),
            builder: (context, snapshot) {
              if (snapshot.data == null)
                return Center(child: CircularProgressIndicator());
              return Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: NeoContainer(
                              width: dim - 22,
                              height: dim - 22,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Center(
                                    child: RichText(
                                        text: TextSpan(children: [
                                  TextSpan(
                                      text: snapshot.data.time,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32,
                                          color: accentColor)),
                                  TextSpan(
                                      text: '\nmins',
                                      style: TextStyle(
                                          color: accentColor, fontSize: 20))
                                ]))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: NeoContainer(
                              width: dim - 22,
                              height: dim - 22,
                              child: Center(
                                  child: RichText(
                                      text: TextSpan(children: [
                                TextSpan(
                                    text: '₹',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 32,
                                        color: accentColor)),
                                TextSpan(
                                    text: snapshot.data.fare,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32,
                                        color: accentColor))
                              ]))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: NeoContainer(
                              width: dim - 22,
                              height: dim - 22,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Center(
                                  child: RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: '   '+snapshot.data.switches,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 32,
                                            color: accentColor)),
                                    TextSpan(
                                        text: '\nSwitches',
                                        style: TextStyle(
                                            fontSize: 20, color: accentColor))
                                  ])),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 16),
                      child: NeoContainer(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height -
                              (dim - 22 + 80),
                          child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: snapshot.data.stations.length,
                              separatorBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    child: Divider(
                                      color: accentColor,
                                    ),
                                  ),
                              itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      title: Text(
                                        snapshot.data.stations[index],
                                        style: TextStyle(color: accentColor),
                                      ),
                                      trailing: Icon(Icons.fiber_manual_record,
                                          color: Color(int.parse(
                                              '0xFF${services.lineColorMap[snapshot.data.lines[index]].substring(1)}'))),
                                    ),
                                  )),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }));
  }
}
