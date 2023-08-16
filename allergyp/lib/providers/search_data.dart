

import 'dart:convert';

SearchData searchDataFromJson(String str) =>
    SearchData.fromJson(json.decode(str));

class SearchData {
  SearchData({
    required this.status,
    required this.data,
  });

  String status;
  List<Datum>? data;

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
    status: json["status"],
    data: json["data"] == null
        ? null
        : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );
}

class Datum {
  Datum({
    required this.uid,
    required this.aqi,
    required this.time,
    required this.station,
  });

  int? uid;
  String? aqi;
  Time? time;
  Station? station;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    uid: json["uid"],
    aqi: json["aqi"],
    time: json["time"] == null ? null : Time.fromJson(json["time"]),
    station:
    json["station"] == null ? null : Station.fromJson(json["station"]),
  );
}
class Station {
  Station({
    required this.name,
    required this.geo,
    required this.url,
    required this.country,
  });

  String? name;
  List<dynamic>? geo;
  String? url;
  String? country;

  factory Station.fromJson(Map<String, dynamic> json) => Station(
    name: json["name"],
    geo: json["geo"] == null
        ? null
        : List<dynamic>.from(json["geo"].map((x) => x)),
    url: json["url"],
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "geo": geo == null ? null : List<dynamic>.from(geo!.map((x) => x)),
    "url": url,
    "country": country,
  };
}

class Time {
  Time({
    required this.tz,
    required this.stime,
    required this.vtime,
  });

  String? tz;
  DateTime? stime;
  int? vtime;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        tz: json["tz"],
        stime: json["stime"] == null ? null : DateTime.parse(json["stime"]),
        vtime: json["vtime"],
      );
}
