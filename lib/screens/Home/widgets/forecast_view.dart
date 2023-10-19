import 'package:flutter/material.dart';
import 'package:weather_app_flutter/models/weather_repository.dart';

class ForecastView extends StatelessWidget {

  final List<Forecast> forecastsList;
  const ForecastView({super.key,required this.forecastsList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Forecast for 7 days:',style: Theme.of(context).textTheme.titleMedium,),
        SizedBox(height: 20,),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: forecastsList.length,
          itemBuilder: (context, index) {
            final forecast = forecastsList[index];
            return Align(
              alignment: Alignment.center,
              child: Text(
                '${forecast.day}: ${forecast.temperature}°C',
              ),
            );
          },
        ),
      ],
    );
  }
}
