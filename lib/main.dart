// ignore_for_file: await_only_futures

import 'package:flutter/material.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/repository/weather_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/res/dimens/elder_dimens.dart';
import 'package:weather_app/res/dimens/regular_dimens.dart';
import 'package:weather_app/view/background.dart';
import 'package:weather_app/view/weather_page.dart';

import 'res/dimens/dimens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        body: BlocProvider(
          create: (context) => WeatherBloc(),
          child: MyHomePage(
            title: "Flutter App",
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<WeatherPageState> _key = GlobalKey();
  WeatherRepository repository = WeatherRepository();
  Dimens _dimens = RegularDimens();

  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    var cityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        //title: const Text("Pogodynka"),
        actions: <Widget>[_searchMenu(), _popMenu()],
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: backgorund(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherIsNotSearched) {
                    return Container(
                      padding: const EdgeInsets.only(
                        left: 32,
                        right: 32,
                      ),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            "Search Weather",
                            style: TextStyle(
                                fontSize: 2,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                          ),
                          const Text(
                            "Instanly",
                            style: TextStyle(
                                fontSize: 2,
                                fontWeight: FontWeight.w200,
                                color: Colors.white70),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            controller: cityController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white70,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.white70,
                                      style: BorderStyle.solid)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.blue,
                                      style: BorderStyle.solid)),
                              hintText: "City Name",
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              onPressed: () {
                                weatherBloc
                                    .add(FetchWeather(cityController.text));
                              },
                              color: Colors.lightBlue,
                              child: const Text(
                                "Search",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (state is WeatherIsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WeatherIsLoaded) {
                    return WeatherPage(
                      key: _key,
                      dimens: _dimens,
                      data: state.getWeather,
                    );
                  }
                  return const Text("s");
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _popMenu() {
    return PopupMenuButton<int>(
      itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
        const PopupMenuItem<int>(value: 1, child: Text('Normalny tryb')),
        const PopupMenuItem<int>(value: 2, child: Text('Ułatwiony tryb')),
      ],
      onSelected: (int value) {
        if (value == 1) {
          _key.currentState?.changeDimens(RegularDimens(), false);
        } else if (value == 2) {
          _key.currentState?.changeDimens(ElderDimens(), true);
        }
      },
    );
  }

  Widget _searchMenu() {
    return Container(
        child: IconButton(
      icon: Icon(Icons.search),
      onPressed: () {},
    ));
  }
}
