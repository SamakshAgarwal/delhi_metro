import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'route.dart' as route;

class Services extends ChangeNotifier {
  static Database db;
  var stationList = Map();
  var stationMap = [];
  String text;
  String start;
  String dest;
  List suggestions = [];
  List routeList = [];
  List routeIds = [];
  List lines = [];
  var lineMap = Map();
  var lineColorMap = Map();
  String time;
  int switches = 0;

  openDB() async {
    db = await openDatabase('dmrcSqlite.db');
  }

  get getStationList async {
    await db
        .rawQuery("SELECT station_name,station_id FROM tbl_stations")
        .then((value) {
      value.forEach(
          (row) => stationList[row['station_name']] = row['station_id']);
    });
    return stationList.keys.toList()..sort();
  }

  get getSuggestions => suggestions;

  createSuggestions(String text) {
    if (stationList.isEmpty) getStationList();
    if (text.isEmpty)
      suggestions = [];
    else
      suggestions = stationList.keys
          .toList()
          .where(
              (station) => station.toLowerCase().startsWith(text.toLowerCase()))
          .toList();
    notifyListeners();
  }

  set setStart(String station) => start = station;

  set setDest(String station) => dest = station;

  get getStart => start;

  get getDest => dest;

  getShortestRoute() async {
    routeList = [];

    var route;
    await db
        .rawQuery(
            "SELECT \"${stationList[dest]}\" FROM tbl_routematrix WHERE station_id=${stationList[start]}")
        .then((value) {
      value.forEach((row) {
        route = row[stationList[dest]];
      });
    });
    route = route.substring(0, route.indexOf(':'));
    routeIds = route.split('-');
    print('Normal: $routeIds');

    var airportRoute;
    await db
        .rawQuery(
            "SELECT \"${stationList[dest]}\" FROM tbl_routematrix_airport WHERE station_id=${stationList[start]}")
        .then((value) {
      value.forEach((row) {
        airportRoute = row[stationList[dest]];
      });
    });
    airportRoute = airportRoute.substring(0, airportRoute.indexOf(':'));
    List airportRouteIds = airportRoute.split('-');
    print('Airport: $airportRouteIds');

    var violetRoute;
    await db
        .rawQuery(
            "SELECT \"${stationList[dest]}\" FROM tbl_routematrix_violet WHERE station_id=${stationList[start]}")
        .then((value) {
      value.forEach((row) {
        violetRoute = row[stationList[dest]];
      });
    });
    violetRoute = violetRoute.substring(0, violetRoute.indexOf(':'));
    List violetRouteIds = airportRoute.split('-');
    print('Violet: $airportRouteIds');

    var otherRoute;
    List otherRouteIds;
    var other = await db.rawQuery(
        "SELECT routepath FROM tbl_other_routes WHERE start_station=${stationList[start]} AND end_station=${stationList[dest]}");
    if (other.isNotEmpty) {
      other.forEach((row) {
        otherRoute = row['routepath'];
      });
      otherRoute = otherRoute.substring(0, otherRoute.indexOf(':'));
      otherRouteIds = otherRoute.split('-');
      print('Other: $otherRouteIds');
    }
    routeIds = ([
      routeIds,
      violetRouteIds,
      airportRouteIds,
      if (otherRouteIds != null) otherRouteIds
    ]..sort((a, b) => (a.length).compareTo(b.length)))[0];
    routeIds = routeIds.length < violetRoute.length ? routeIds : otherRoute;
    print('Route ids: $routeIds');

    routeIds.forEach((row) {
      routeList.add(stationList.keys
          .firstWhere((k) => stationList[k] == row, orElse: () => null));
    });
    return routeList;
  }

  getRouteTime() async {
    await db
        .rawQuery(
            "SELECT \"${stationList[dest]}\" FROM tbl_runtime WHERE station_id=${stationList[start]}")
        .then((value) {
      value.forEach((row) {
        time = row[stationList[dest]];
      });
    });
    var t = time.split(':');
    int tim = 60 * int.parse(t[0]) + int.parse(t[1]);

    String airportTime;
    await db
        .rawQuery(
            "SELECT \"${stationList[dest]}\" FROM tbl_airport_time WHERE station_id=${stationList[start]}")
        .then((value) {
      value.forEach((row) {
        airportTime = row[stationList[dest]];
      });
    });
    if (airportTime != null) {
      var at = airportTime.split(':');
      int aTim = 60 * int.parse(at[0]) + int.parse(at[1]);
      time = tim < aTim ? tim.toString() : aTim.toString();
    } else
      time = tim.toString();
    return time;
  }

  getFare() async {
    var fare;
    await db
        .rawQuery(
            "SELECT \"${stationList[dest]}\" FROM tbl_fare WHERE station_id=${stationList[start]}")
        .then((value) {
      value.forEach((row) {
        fare = row[stationList[dest]];
      });
    });

    var airportFare;
    await db
        .rawQuery(
            "SELECT \"${stationList[dest]}\" FROM tbl_airport_fares WHERE station_id=${stationList[start]}")
        .then((value) {
      value.forEach((row) {
        airportFare = row[stationList[dest]];
      });
    });

    if(airportFare!=null)
      fare = fare.compareTo(airportFare)?fare:airportFare;

    return fare;
  }

  getLines() async {
    lines = [];
    await db
        .rawQuery("SELECT line_id, station_id FROM tbl_network_stations")
        .then((value) {
      value.forEach((row) {
        lineMap[row['station_id']] = row['line_id'];
      });
    });
    routeIds.forEach((id) {
      lines.add(lineMap[id]);
    });
    for (int i = 1; i < lines.length - 1; i++) {
      if (lines[i] != lines[i - 1]) {
        if (lines[i] != lines[i + 1]) {
          lines[i] = lines[i + 1];
        }
      }
    }
    return lines;
  }

  getSwitches() {
    switches = 0;
    if (lines != null)
      for (int i = 0; i < lines.length - 1; i++)
        if (lines[i] != lines[i + 1]) switches++;
    return switches.toString();
  }

  getLineColor() async {
    print('Line color called');
    await db
        .rawQuery("SELECT line_id, color_code FROM tbl_lines")
        .then((value) {
      value.forEach((row) {
        lineColorMap[row['line_id']] = row['color_code'];
      });
    });
  }

  getRouteObject() async {
    String time = await getRouteTime();
    String fare = await getFare();
    List routeList = await getShortestRoute();
    List lines = await getLines();
    String switches = await getSwitches();

    return route.Route(
        time: time,
        fare: fare,
        switches: switches.toString(),
        stations: routeList,
        lines: lines);
  }
}
