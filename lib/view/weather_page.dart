import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather_data/weather_data.dart';
import 'package:weather_app/res/dimens/dimens.dart';
import 'package:weather_app/res/dimens/elder_dimens.dart';
import 'package:weather_app/res/dimens/regular_dimens.dart';
import 'package:weather_app/res/styles/text_styles.dart';

class WeatherPage extends StatefulWidget {
  final WeatherData data;
  bool isElder = false;
  Dimens dimens = RegularDimens();

  WeatherPage({Key? key, required this.data, required this.dimens})
      : super(key: key);

  @override
  State<WeatherPage> createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  var _timeString;
  // ignore: non_constant_identifier_names
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final String formattedDateTime =
        DateFormat('yyyy-MM-dd  kk:mm').format(DateTime.now()).toString();
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  void changeDimens(Dimens _dimens, bool _isElder) {
    setState(() {
      widget.dimens = _dimens;
      widget.isElder = _isElder;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.pin_drop_outlined,
                color: Colors.white,
                size: 16,
              ),
              Text(widget.data.name.toString(),
                  style: BasicStyle(widget.dimens.regularFontSize))
            ],
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _timeString.toString(),
                style: TextStyle(
                    fontSize: widget.dimens.smallFontSize,
                    color: Colors.grey[400]),
              )),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.network(
                "http://openweathermap.org/img/wn/${widget.data.weather![0].icon}@2x.png"),
            Text((widget.data.main!.temp - 270).toStringAsFixed(0) + "\u{00B0}",
                style: BasicStyle(widget.dimens.largeFontSize)),
          ]),
          Text(widget.data.weather![0].description.toString(),
              style: BasicStyle(widget.dimens.regularFontSize)),
          Container(
            margin: const EdgeInsets.only(top: 38, left: 18, right: 18),
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
                color: widget.isElder
                    ? Colors.blue[100]?.withOpacity(0.5)
                    : Colors.blue[100]?.withOpacity(0.25),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: Column(
              children: [
                Text(
                    "Ciśnienie: " +
                        widget.data.main!.pressure.toString() +
                        " hPa",
                    style: BasicStyle(widget.dimens.smallFontSize)),
                const Divider(
                  height: 28,
                  thickness: 2,
                  color: Colors.white,
                  indent: 30,
                  endIndent: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(children: [
                      Text("Wschód",
                          style: BasicStyle(widget.dimens.smallFontSize)),
                      Text(
                          DateFormat.Hm().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  (widget.data.sys!.sunrise! +
                                          widget.data.timezone!) *
                                      1000)),
                          style: BasicStyle(widget.dimens.smallFontSize))
                    ]),
                    Column(
                      children: [
                        Text("Zachód",
                            style: BasicStyle(widget.dimens.smallFontSize)),
                        Text(
                            DateFormat.Hm().format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    (widget.data.sys!.sunset! +
                                            widget.data.timezone!) *
                                        1000)),
                            style: BasicStyle(widget.dimens.smallFontSize))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
