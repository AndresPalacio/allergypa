import 'dart:convert';

import 'package:allergyp/providers/search_data.dart';
import 'package:http/http.dart';

import 'air_quality.dart';

const String apiKey = "168d8e926e9229398a8f5cd5456b619ea2f0dd1f";

class AirQualityProvider  {

  final List<AirQuality> _items = [];
  SearchData? _searchData ;
  AirQuality? _airQuality;

  Future<void> fetchAndSetData() async {
    final url = 'https://api.waqi.info/feed/here/?token=$apiKey';
    try {
      final response = await get(Uri.parse(url));
      final responseData = json.decode(response.body);
      _items.insert(0, AirQuality.fromJson(responseData));
      return;
    } catch (e) {}
  }

  Future<void> dataFromSearch(String cityUrl) async {
    final url = 'https://api.waqi.info/feed/$cityUrl/?token=$apiKey';
    final response = await get(Uri.parse(url));
    final responseData = json.decode(response.body);

    _items.add(AirQuality.fromJson(responseData));
  }

  
  Future<void> dataFromLatLng(double lat, double lng) async {
    final url = 'https://api.waqi.info/feed/geo:$lat;$lng/?token=$apiKey';
    final response = await get(Uri.parse(url));
    final responseData = json.decode(response.body);

    _airQuality = AirQuality.fromJson(responseData);
  }


  SearchData? get cities {
    return _searchData ;
  }

  List<AirQuality> get items {
    return _items;
  }

  AirQuality? get airQuality{
    return _airQuality;
  }

  double? get iaqiPm25{
    return _airQuality?.data?.iaqi?.pm25?.v;
   }
}
