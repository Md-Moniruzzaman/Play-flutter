part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class WeatherLoadedEvent extends WeatherEvent {
  final String cityName;

  const WeatherLoadedEvent({required this.cityName});

  @override
  List<Object> get props => [cityName];
}
