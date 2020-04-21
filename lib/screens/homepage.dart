import 'package:delhimetro/colors/colors.dart';
import 'package:delhimetro/screens/mapPage.dart';
import 'package:delhimetro/screens/routepage.dart';
import 'package:delhimetro/services/services.dart';
import 'package:delhimetro/widgets/neoButton.dart';
import 'package:delhimetro/widgets/neoContainer.dart';
import 'package:delhimetro/widgets/neoTextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController startStationController = TextEditingController();
  TextEditingController destStationController = TextEditingController();

  Services services;
  OverlayEntry overlayEntry;
  var startKey = GlobalKey();
  var destKey = GlobalKey();
  FocusNode startFocusNode = FocusNode();
  FocusNode destFocusNode = FocusNode();
  var size;
  bool isStartSelected = false, isDestSelected = false;

  @override
  void initState() {
    Services().openDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    services = Provider.of<Services>(context);
    size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 80, bottom: 20),
                  child: Image.asset(
                    'assets/dmrcLogo.png',
                    width: size.width / 1.9,
                    height: size.width / 1.9,
                  ),
                ),
                textBoxWidget(startKey, startStationController, startFocusNode,
                    'Start Station'),
                Padding(padding: EdgeInsets.only(top: 18)),
                textBoxWidget(destKey, destStationController, destFocusNode,
                    'Destination Station'),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 18.0, left: 100, right: 100),
                  child: SizedBox(
                    width: double.infinity,
                    child: NeoButton(
                        onTap: () {
                          if (isStartSelected && isDestSelected) {
                            FocusScope.of(context).unfocus();
                            services.setStart = startStationController.text;
                            services.setDest = destStationController.text;
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => RoutePage()));
                          } else {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Select Starting and Destination Station from List',
                              ),
                              duration: Duration(milliseconds: 800),
                            ));
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.search,
                              color: accentColor,
                            ),
                            Text(
                              "Search",
                              style: TextStyle(color: accentColor),
                            ),
                          ],
                        )),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: SizedBox(
                      width: 55,
                      height: 55,
                      child: NeoButton(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.map,
                              color: accentColor,
                              size: 40,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapPage()));
                          }),
                    ),
                  ),
                )
              ],
            ),
          );
        }));
  }

  textBoxWidget(
    GlobalKey key,
    TextEditingController controller,
    FocusNode focusNode,
    String hint,
  ) =>
      Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: SizedBox(
            key: key,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                NeoTextField(
                  onTap: () {
                    overlayEntry = stationSuggestionOverlay(key, controller);
                    Overlay.of(context).insert(overlayEntry);
                    services.createSuggestions(controller.text);
                  },
                  onChanged: (text) {
                    services.createSuggestions(text);
                  },
//                  onSubmitted: (text) {
//                    overlayEntry.remove();
//                  },
                  controller: controller,
                  hint: hint,
                  focusNode: focusNode,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: accentColor,
                    ),
                    onPressed: () {
                      stationListDialog(controller);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                )
              ],
            )),
      );

  stationListDialog(TextEditingController controller) {
    showDialog(
        context: context,
        builder: (_) => FutureBuilder(
              future: services.getStationList,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else
                  return AlertDialog(
                    elevation: 3,
                    backgroundColor: backgroundColor,
                    content: ListView.separated(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(
                        color: accentColor,
                      ),
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          if(controller==startStationController)
                            isStartSelected = true;
                          else
                            isDestSelected = true;
                          controller.text = snapshot.data[index];
                          Navigator.pop(context);
                        },
                        title: Text(
                          snapshot.data[index],
                          style: TextStyle(color: accentColor),
                        ),
                      ),
                    ),
                  );
              },
            ));
  }

  stationSuggestionOverlay(var key, TextEditingController controller) {
    RenderBox renderBox = key.currentContext.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
        builder: (BuildContext context) => Consumer<Services>(
            builder: (BuildContext context, services, Widget child) => Stack(
                  children: <Widget>[
                    Positioned.fill(
                        child: GestureDetector(
                      onTap: () {
                        overlayEntry.remove();
                        FocusScope.of(context).unfocus();
                      },
                      onPanDown: (_) {
                        FocusScope.of(context).unfocus();
                      },
                    )),
                    if (!services.getSuggestions.isEmpty)
                      Positioned(
                          left: offset.dx,
                          top: offset.dy + size.height + 5.0,
                          width: size.width,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height -
                                    offset.dy -
                                    70,
                                minHeight: 0.0),
                            child: Material(
                                elevation: 5,
                                color: backgroundColor,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8),
                                  child: GestureDetector(
                                    onPanDown: (_) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            services.getSuggestions.length,
                                        itemBuilder: (context, index) =>
                                            ListTile(
                                              onTap: () {
                                                if (controller ==
                                                    startStationController)
                                                  isStartSelected = true;
                                                else
                                                  isDestSelected = true;
                                                overlayEntry.remove();
                                                controller.text = services
                                                    .getSuggestions[index];
                                              },
                                              title: Text(
                                                services.getSuggestions[index],
                                                style: TextStyle(
                                                    color: accentColor),
                                              ),
                                            )),
                                  ),
                                )),
                          ))
                  ],
                )));
  }
}
