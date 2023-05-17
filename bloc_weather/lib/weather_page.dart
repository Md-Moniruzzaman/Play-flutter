import 'package:bloc_weather/bloc/counter_bloc.dart';
import 'package:bloc_weather/bloc/weather_bloc.dart';
import 'package:bloc_weather/test_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  static const routeName = '/weatherPage';

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  CounterBloc counterBloc = CounterBloc();
  WeatherBloc weatherBloc = WeatherBloc();
  final cityNameCtrl = TextEditingController();

  int _page = 0;
  List<String> pagelist = ['home', 'add', 'Favourite', 'List', 'Compare'];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<WeatherBloc>(context)
        .add(const WeatherLoadedEvent(cityName: 'Dahaka'));
    BlocProvider.of<CounterBloc>(context)
        .add(const CounterIncreamentEvent(value: -1));
  }

  @override
  void dispose() {
    cityNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Weather'), centerTitle: true),
      bottomNavigationBar: CurvedNavigationBar(
        // key: _bottomNavigationKey,
        index: 0,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.favorite_border, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.compare_arrows, size: 30),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).pushNamed('/testpage',
                arguments: const TestPage(
                  cityName: 'Barguan',
                  name: 'Monir',
                ));
            setState(() {
              _page = index;
            });
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(pagelist[_page]),
                const SizedBox(height: 10),
                const Divider(color: Colors.amber),
                BlocBuilder<CounterBloc, CounterState>(
                  // bloc: counterBloc,
                  buildWhen: (previous, current) => previous != current,
                  builder: (context, state) {
                    if (state is CounterInitial) {
                      return Column(
                        children: [
                          const Text(
                            '0',
                            style: TextStyle(fontSize: 21),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Increament')),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Decreament'))
                            ],
                          ),
                        ],
                      );
                    } else if (state is CounterLoadedState) {
                      return Column(
                        children: [
                          Text(
                            state.value.toString(),
                            style: const TextStyle(fontSize: 21),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<CounterBloc>(context).add(
                                        CounterIncreamentEvent(
                                            value: state.value));
                                  },
                                  child: const Text('Increament')),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<CounterBloc>(context).add(
                                        CounterdecreamentEvent(
                                            value: state.value));
                                  },
                                  child: const Text('Decreament'))
                            ],
                          ),
                        ],
                      );
                    }
                    return const Text('');
                  },
                ),
                const SizedBox(height: 10),
                BlocListener<CounterBloc, CounterState>(
                  // bloc: CounterBloc(),
                  listener: (context, state) {
                    if (state is CounterLoadedState) {
                      if (state.value == 10) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Center(child: Text(state.value.toString())),
                          duration: const Duration(seconds: 1),
                          // action: SnackBarAction(
                          //   label: 'ACTION',
                          //   onPressed: () {},
                          // ),
                        ));
                      }
                    }
                  },
                  child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<CounterBloc>(context)
                            .add(const CounterIncreamentEvent(value: 4));
                      },
                      child: const Text('listenr test')),
                ),
                const SizedBox(height: 10),
                BlocConsumer<WeatherBloc, WeatherState>(
                  listenWhen: (previous, current) => previous != current,
                  listener: (context, state) {
                    if (state is WeatherLoadedState) {
                      if (state.weather.tem > 30) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Center(child: Text('It\'s a hot day!')),
                          duration: Duration(seconds: 2),
                          // action: SnackBarAction(
                          //   label: 'ACTION',
                          //   onPressed: () {},
                          // ),
                        ));
                      }
                    }
                  },
                  buildWhen: (previous, current) => previous != current,
                  builder: (context, WeatherState state) {
                    if (state is WeatherInitial) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is WeatherLoadedState) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Text(state.weather.cityName,
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 10),
                            Text(state.weather.tem.toStringAsFixed(2)),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: cityNameCtrl,
                                autofocus: false,
                                decoration: InputDecoration(
                                  labelText: 'City Name',
                                  hintText: 'Your city Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onFieldSubmitted: (value) =>
                                    BlocProvider.of<WeatherBloc>(context).add(
                                        WeatherLoadedEvent(cityName: value)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class InputCityName extends StatelessWidget {
//   InputCityName({
//     super.key,
//   });

//   final cityNameCtrl = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextFormField(
//         controller: cityNameCtrl,
//         autofocus: true,
//         decoration: InputDecoration(
//           labelText: 'City Name',
//           hintText: 'Your city Name',
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5),
//           ),
//         ),
//         onChanged: (value) => BlocProvider.of<WeatherBloc>(context)
//             .add(WeatherLoadedEvent(cityName: value)),
//       ),
//     );
//   }
// }
