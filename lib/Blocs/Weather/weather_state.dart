import 'package:weather_app_flutter/models/weather_repository.dart';

class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherSuccess extends WeatherState {
  Weather? currentWeather;
  List<Forecast>? forecast;
  Map<String, List<Forecast>>? forecastsMultiRegion;

  WeatherSuccess({this.currentWeather, this.forecast, this.forecastsMultiRegion});
}

class WeatherError extends WeatherState {
  Object error;

  WeatherError(this.error);
}
