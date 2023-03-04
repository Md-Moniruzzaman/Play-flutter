import 'package:bloc_weather/test_page.dart';
import 'package:bloc_weather/weather_page.dart';
import 'package:flutter/material.dart';

class RoutteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    //Getting argument passed in while calling Navigator.pushNamed

    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const WeatherPage());

      case TestPage.routeName:
        final args = routeSettings.arguments as TestPage;
        // final args = routeSettings.arguments as Map<String, String>;

        return MaterialPageRoute(
          builder: (_) => TestPage(
            cityName: args.cityName,
            name: args.name,
          ),
        );
    }

    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Erttor'),
        ),
        body: const Center(child: Text('Error')),
      );
    });
  }
}
