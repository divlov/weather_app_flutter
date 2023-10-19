import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_app_flutter/Blocs/Weather/weather_controller_bloc.dart';
import 'package:weather_app_flutter/Blocs/Weather/weather_event.dart';
import 'package:weather_app_flutter/models/weather_repository.dart';
import 'package:weather_app_flutter/Blocs/Weather/weather_state.dart';
import 'package:weather_app_flutter/screens/Home/widgets/forecast_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late WeatherMultiRegionForecastBloc _weatherMultiRegionForecastBloc;
  late WeatherForecastBloc _weatherForecastBloc;
  late WeatherCurrentBloc _weatherCurrentBloc;

  // Build the home page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Display the current weather
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: BlocProvider(
                create: (_) {
                  _weatherCurrentBloc =
                      WeatherCurrentBloc(WeatherRepository.getInstance());
                  return _weatherCurrentBloc;
                },
                child: BlocBuilder<WeatherCurrentBloc, WeatherState>(
                    builder: (ctx, state) {
                  if (state is WeatherInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WeatherSuccess) {
                    return Center(
                      child: Text(
                        'Current weather in ${state.currentWeather!.city}: ${state.currentWeather!.temperature}°C',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    );
                  } else {
                      showToast((state as WeatherError).error.toString());
                    return TextButton(
                        onPressed: () {
                          _weatherCurrentBloc.add(GetWeatherEvent());
                        },
                        child: const Center(child: Text('Try again')));
                  }
                }),
              ),
            ),
            BlocProvider(
              create: (_) {
                _weatherForecastBloc =
                    WeatherForecastBloc(WeatherRepository.getInstance());
                return _weatherForecastBloc;
              },
              child: BlocBuilder<WeatherForecastBloc, WeatherState>(
                  builder: (ctx, state) {
                if (state is WeatherInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WeatherSuccess) {
                  return ForecastView(forecastsList: state.forecast!);
                } else {
                  showToast((state as WeatherError).error.toString());
                  return Center(
                    child: TextButton(
                        onPressed: () {
                          _weatherForecastBloc.add(GetForecastEvent());
                        },
                        child: const Center(child: Text('Try again'))),
                  );
                }
              }),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocProvider(
              create: (_) {
                _weatherMultiRegionForecastBloc =
                    WeatherMultiRegionForecastBloc(
                        WeatherRepository.getInstance());
                return _weatherMultiRegionForecastBloc;
              },
              child: BlocBuilder<WeatherMultiRegionForecastBloc, WeatherState>(
                  builder: (ctx, state) {
                if (state is WeatherInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WeatherSuccess) {
                  return Column(children: [
                    Text('Multi-region forecast for 7 days:',
                        style: Theme.of(context).textTheme.titleLarge),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.forecastsMultiRegion!.keys.length,
                      itemBuilder: (context, index) {
                        final city =
                            state.forecastsMultiRegion!.keys.elementAt(index);
                        final forecast = state.forecastsMultiRegion![city];
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(city,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              ForecastView(forecastsList: forecast!)
                            ],
                          ),
                        );
                      },
                    ),
                  ]);
                } else {
                  showToast((state as WeatherError).error.toString());
                  return TextButton(
                      onPressed: () {
                        _weatherMultiRegionForecastBloc
                            .add(GetMultiRegionForecastEvent());
                      },
                      child: const Center(child: Text('Try again')));
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  void showToast(String error) {
    Fluttertoast.showToast(
        msg: error,
        toastLength: Toast.LENGTH_SHORT);
  }
}
