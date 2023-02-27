import 'dart:math';

import 'package:bloc_weather/model/weather_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherLoadedEvent>((event, emit) {
      emit(WeatherLoadedState(
          weather: Weather(
              cityName: event.cityName,
              tem: 20 + Random().nextInt(15) + Random().nextDouble())));
    });
  }
}
