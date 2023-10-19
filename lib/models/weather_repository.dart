import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherRepository {
  String apiKey = 'your api key';

  WeatherRepository._();

  static final WeatherRepository _instance = WeatherRepository._();

  factory WeatherRepository.getInstance() {
    return _instance;
  }

  Future<Weather> getWeather(double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey'),
      );

      if (response.statusCode == 200) {
        final weatherData = jsonDecode(response.body);
        return Weather.fromJson(weatherData);
      } else {
        throw Exception('Failed to fetch weather data');
      }
    }  catch (e) {
      print(e);
      throw Exception('Failed to fetch weather data');
    }
  }

  Future<List<Forecast>> getCurrentForecast(
      double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&appid=$apiKey&exclude=minutely,hourly'),
      );

      if (response.statusCode == 200) {
        final forecastData = jsonDecode(response.body);
        final forecasts = <Forecast>[];
        for (int i = 0; i < 8; i++) {
          forecasts.add(Forecast.fromJson(forecastData['daily'][i]));
        }
        return forecasts;
      } else {
        throw Exception('Failed to fetch current forecast');
      }
    } catch (e) {
      throw Exception('Failed to fetch current forecast');
    }
  }

  Future<Map<String, List<Forecast>>> getMultiRegionForecast(
      List<String> coordinates) async {
    try {
      final Map<String, List<Forecast>> multiRegionForecasts = {};
      for (var coordinate in coordinates) {
        List<String> latLong = coordinate.split(',');
        double latitude = double.parse(latLong[0]);
        double longitude = double.parse(latLong[1]);
        // final forecast = await getCurrentForecast(latitude,longitude);

        final responseForCityName = await http.get(
          Uri.parse(
              'http://api.openweathermap.org/geo/1.0/reverse?lat=$latitude&lon=$longitude&limit=5&appid=$apiKey'),
        );

        final response = await http.get(
          Uri.parse(
              'https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&appid=$apiKey&exclude=minutely,hourly'),
        );

        if (response.statusCode == 200 && responseForCityName.statusCode==200) {
          final forecastData = jsonDecode(response.body);
          final cityNameData = jsonDecode(responseForCityName.body);
          final forecasts = <Forecast>[];
          // for (var forecast in forecastData['list']) {
          //   forecasts.add(Forecast.fromJson(forecast));
          // }
          for (int i = 0; i < 8; i++) {
            forecasts.add(Forecast.fromJson(forecastData['daily'][i]));
          }
          multiRegionForecasts[cityNameData[0]['name']] = forecasts;
        } else {
          throw Exception('Failed to fetch forecasts');
        }
      }
      return multiRegionForecasts;
    } catch (e) {
      throw Exception('Failed to fetch forecasts');
    }
  }
}

class Weather {
  final String city;
  final double temperature;

  Weather.fromJson(Map<String, dynamic> json)
      : city = json['name'],
        temperature =
            double.parse((json['main']['temp'] - 273).toStringAsFixed(2));
}

class Forecast {
  final String day;
  final double temperature;

  Forecast.fromJson(Map<String, dynamic> json)
      : day = DateFormat('yMd')
            .format(DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000)),
        //temp is in kelvin, converting to C
        temperature =
            double.parse((json['temp']['max'] - 273).toStringAsFixed(2));
}
