import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_data/weather_data.dart';

class WeatherRepository {
  static const apiKey = "3a356a657c5ae1f8f51f8091a70e833d";

  Future<WeatherData> callApi(String cityname) async {
    var response = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$cityname&lang=pl&appid=$apiKey"),
    );

    var body = response.body;
    return WeatherData.fromJson(jsonDecode(body));
  }
}
