class Journey {
  final String time;
  final String fare;
  final String switches;
  final List stations;
  final List lines;

  Journey({this.time, this.fare, this.switches, this.stations, this.lines})
      : assert(time != null),
        assert(fare != null),
        assert(switches != null),
        assert(stations != null),
        assert(lines != null);
}
