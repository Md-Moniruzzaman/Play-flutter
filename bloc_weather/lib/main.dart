import 'package:bloc_weather/bloc/counter_bloc.dart';
import 'package:bloc_weather/bloc/weather_bloc.dart';
import 'package:bloc_weather/main_page.dart';
import 'package:bloc_weather/route/route_gengerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherBloc>(create: (context) => WeatherBloc()),
        BlocProvider(create: (context) => CounterBloc())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: MainPage.routeName,
        onGenerateRoute: RoutteGenerator.generateRoute,
      ),
    );
  }
}
