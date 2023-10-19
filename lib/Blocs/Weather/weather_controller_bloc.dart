import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_flutter/Blocs/Weather/weather_event.dart';
import 'package:weather_app_flutter/models/weather_repository.dart';
import 'package:weather_app_flutter/Blocs/Weather/weather_state.dart';
import 'package:weather_app_flutter/helpers/permission_checker.dart';

class WeatherCurrentBloc extends Bloc<GetWeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherCurrentBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<GetWeatherEvent>((event, emit) async {
      emit(WeatherInitial());
      try {
        await PermissionChecker().checkLocationPermission();
        var position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.medium)
            .timeout(const Duration(seconds: 5));
        final weather = await weatherRepository.getWeather(
            position.latitude, position.longitude);
        emit(WeatherSuccess(currentWeather: weather));
      } catch (error) {
        print(error);
        emit(WeatherError(error));
      }
    });
    add(GetWeatherEvent());
  }
}

// WeatherBloc for getting weather forecast for a single location for 7 days
class WeatherForecastBloc extends Bloc<GetForecastEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherForecastBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<GetForecastEvent>((event, emit) async {
      emit(WeatherInitial());
      try {
        await PermissionChecker().checkLocationPermission();
        var position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.medium)
            .timeout(const Duration(seconds: 5));
        final forecast = await weatherRepository.getCurrentForecast(
            position.latitude, position.longitude);
        emit(WeatherSuccess(forecast: forecast));
      } catch (error) {
        print(error);
        emit(WeatherError(error));
      }
    });
    add(GetForecastEvent());
  }
}

// WeatherBloc for getting weather forecast for multiple locations for 7 days
class WeatherMultiRegionForecastBloc
    extends Bloc<GetMultiRegionForecastEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherMultiRegionForecastBloc(this.weatherRepository)
      : super(WeatherInitial()) {
    on<GetMultiRegionForecastEvent>((event, emit) async {
      emit(WeatherInitial());
      List<String> coordinates = [
        "40.7128,-74.0060",
        "51.5074,-0.1278",
        "35.682839,139.759455",
        "-33.865143,151.209900",
        "48.8566,2.3522"
      ];

      try {
        await PermissionChecker().checkLocationPermission();
        final cityForecastMap =
            await weatherRepository.getMultiRegionForecast(coordinates);
        emit(WeatherSuccess(forecastsMultiRegion: cityForecastMap));
      } catch (error) {
        emit(WeatherError(error));
      }    });
    add(GetMultiRegionForecastEvent());
  }
}
