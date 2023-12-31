import 'dart:convert';

AirQuality airQualityFromJson(String str) =>
    AirQuality.fromJson(json.decode(str));

class AirQuality {
  AirQuality({
    required this.status,
    required this.data,
  });

  String? status;
  Data? data;

  factory AirQuality.fromJson(Map<String, dynamic> json) => AirQuality(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    required this.aqi,
    required this.idx,
    required this.attributions,
    required this.city,
    required this.dominentpol,
    required this.iaqi,
    required this.time,
    required this.forecast,
    required this.debug,
  });

  int? aqi;
  int? idx;
  List<Attribution>? attributions;
  City? city;
  String? dominentpol;
  Iaqi? iaqi;
  Time? time;
  Forecast? forecast;
  Debug? debug;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        aqi: json["aqi"],
        idx: json["idx"],
        attributions: json["attributions"] == null
            ? null
            : List<Attribution>.from(
                json["attributions"].map((x) => Attribution.fromJson(x))),
        city: json["city"] == null ? null : City.fromJson(json["city"]),
        dominentpol: json["dominentpol"],
        iaqi: json["iaqi"] == null ? null : Iaqi.fromJson(json["iaqi"]),
        time: json["time"] == null ? null : Time.fromJson(json["time"]),
        forecast: json["forecast"] == null
            ? null
            : Forecast.fromJson(json["forecast"]),
        debug: json["debug"] == null ? null : Debug.fromJson(json["debug"]),
      );
}

class Attribution {
  Attribution({
    this.url,
    this.name,
    this.logo,
  });

  String? url;
  String? name;
  String? logo;

  factory Attribution.fromJson(Map<String, dynamic> json) => Attribution(
        url: json["url"],
        name: json["name"],
        logo: json["logo"],
      );
}

class City {
  City({
    this.geo,
    this.name,
    this.url,
  });

  List<double>? geo;
  String? name;
  String? url;

  factory City.fromJson(Map<String, dynamic> json) => City(
        geo: json["geo"] == null
            ? null
            : List<double>.from(json["geo"].map((x) => x.toDouble())),
        name: json["name"],
        url: json["url"],
      );
}

class Debug {
  Debug({
    this.sync,
  });

  DateTime? sync;

  factory Debug.fromJson(Map<String, dynamic> json) => Debug(
        sync: json["sync"] == null ? null : DateTime.parse(json["sync"]),
      );
}

class Forecast {
  Forecast({
    this.daily,
  });

  Daily? daily;

  factory Forecast.fromJson(Map<String, dynamic> json) => Forecast(
        daily: json["daily"] == null ? null : Daily.fromJson(json["daily"]),
      );
}

class Daily {
  Daily({
    this.o3,
    this.pm10,
    this.pm25,
    this.uvi,
  });

  List<O3>? o3;
  List<O3>? pm10;
  List<O3>? pm25;
  List<O3>? uvi;

  factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        o3: json["o3"] == null
            ? null
            : List<O3>.from(json["o3"].map((x) => O3.fromJson(x))),
        pm10: json["pm10"] == null
            ? null
            : List<O3>.from(json["pm10"].map((x) => O3.fromJson(x))),
        pm25: json["pm25"] == null
            ? null
            : List<O3>.from(json["pm25"].map((x) => O3.fromJson(x))),
        uvi: json["uvi"] == null
            ? null
            : List<O3>.from(json["uvi"].map((x) => O3.fromJson(x))),
      );
}

class O3 {
  O3({
    this.avg,
    this.day,
    this.max,
    this.min,
  });

  int? avg;
  DateTime? day;
  int? max;
  int? min;

  factory O3.fromJson(Map<String, dynamic> json) => O3(
        avg: json["avg"],
        day: json["day"] == null ? null : DateTime.parse(json["day"]),
        max: json["max"],
        min: json["min"],
      );
}

class Iaqi {
  Iaqi({
    this.co,
    this.dew,
    this.h,
    this.no2,
    this.o3,
    this.p,
    this.pm10,
    this.pm25,
    this.so2,
    this.t,
    this.w,
  });

  Co? co;
  Co? dew;
  Co? h;
  Co? no2;
  Co? o3;
  Co? p;
  Co? pm10;
  Co? pm25;
  Co? so2;
  Co? t;
  Co? w;

  factory Iaqi.fromJson(Map<String, dynamic> json) => Iaqi(
        co: json["co"] == null ? null : Co.fromJson(json["co"]),
        dew: json["dew"] == null ? null : Co.fromJson(json["dew"]),
        h: json["h"] == null ? null : Co.fromJson(json["h"]),
        no2: json["no2"] == null ? null : Co.fromJson(json["no2"]),
        o3: json["o3"] == null ? null : Co.fromJson(json["o3"]),
        p: json["p"] == null ? null : Co.fromJson(json["p"]),
        pm10: json["pm10"] == null ? null : Co.fromJson(json["pm10"]),
        pm25: json["pm25"] == null ? null : Co.fromJson(json["pm25"]),
        so2: json["so2"] == null ? null : Co.fromJson(json["so2"]),
        t: json["t"] == null ? null : Co.fromJson(json["t"]),
        w: json["w"] == null ? null : Co.fromJson(json["w"]),
      );
}

class Co {
  Co({
    this.v,
  });

  double? v;

  factory Co.fromJson(Map<String, dynamic> json) => Co(
        v: json["v"] == null ? null : json["v"].toDouble(),
      );
}

class Time {
  Time({
    this.s,
    this.tz,
    this.v,
  });

  DateTime? s;
  String? tz;
  int? v;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        s: json["s"] == null ? null : DateTime.parse(json["s"]),
        tz: json["tz"],
        v: json["v"],
      );
}