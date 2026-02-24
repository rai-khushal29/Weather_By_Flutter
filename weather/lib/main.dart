import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather/ios_ui.dart';
import 'package:http/http.dart' as http;
import 'package:weather/windows_ui.dart';
import 'Forecast_Model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      home: const MyHomePage(title: 'Weather'),
    );

    /*if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      return CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather',
        home: const MyHomePage(title: 'Weather'),
      );
    }
    else if(kIsWeb){
      return CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather',
        home: const MyHomePage(title: 'Weather'),
      );
    }
    else {
      return fluent.FluentApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather',
        home: const MyWindowsHomePage(title: 'Weather'),
      );
    }*/
    /*return fluent.FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      home: const MyWindowsHomePage(title: 'Weather'),
    );*/
  }
}

class MyWindowsHomePage extends StatefulWidget {
  const MyWindowsHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyWindowsHomePage> createState() => _MyWindowsHomePageState();
}

class _MyWindowsHomePageState extends State<MyWindowsHomePage> {
  int _pane_one = 0;
  String forecast_ico = "";
  String time = "";
  String city_name = "";
  String temp = "";
  String ico_url = "";
  String desc = "";
  String fl = "";
  List<Forecast_Model> _forecast_list = [];
  String temp_max = 'temp+max';
  String temp_min = 'temp_min';
  String pressure = 'pressure';
  String humidity = 'humidity';
  String q = "Jodhpur"; // city input
  late String temp_city; // If city is not found then restore the value
  TextEditingController tc = TextEditingController();

  callapi() async {
    try {
      var url = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=${q}&units=metric&appid=bebd9da120762f2b44fb9b1f056c90ef");
      var url1 = Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=${q}&units=metric&appid=bebd9da120762f2b44fb9b1f056c90ef");
      var responseForecast = await http.get(url1);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        temp_city = q;
        var data = await jsonDecode(response.body);
        var forecastData = await jsonDecode(responseForecast.body);
        print("Response Status: ${response.statusCode}");
        print("Response body: ${response.body}");
        city_name = data["name"]!.toString();
        temp = data["main"]["temp"]!.toString() +
            String.fromCharCode(0x00B0) +
            "C";
        ico_url = "https://openweathermap.org/img/wn/" +
            data["weather"][0]["icon"]!.toString() +
            "@2x.png";
        desc = data["weather"][0]["description"]!.toString();
        fl = data["main"]["feels_like"]!.toString() +
            String.fromCharCode(0x00B0) +
            "C";
        temp_max = data["main"]["temp_max"]!.toString() +
            String.fromCharCode(0x00B0) +
            "C";
        temp_min = data["main"]["temp_min"]!.toString() +
            String.fromCharCode(0x00B0) +
            "C";
        pressure = data["main"]["pressure"]!.toString();
        humidity = data["main"]["humidity"]!.toString();
        time = forecastData["list"][0]["dt_txt"]!.toString();
        for (int i = 0; i < forecastData["list"].length - 1; i++) {
          _forecast_list.add(Forecast_Model(
              forecastData["list"][i]["dt_txt"]!.toString(),
              "https://openweathermap.org/img/wn/" +
                  forecastData["list"][i]["weather"][0]["icon"]!.toString() +
                  "@2x.png",
              forecastData["list"][i]["weather"][0]["description"]!
                  .toString()));
        }
        windows_ui(
            key: null,
            city_name: city_name,
            temp: temp,
            fl: fl,
            temp_max: temp_max,
            temp_min: temp_min,
            ico_url: ico_url,
            desc: desc,
            pressure: pressure,
            humidity: humidity,
            forecast_list: _forecast_list);
        print(city_name);
        print(time);
      } else if (response.statusCode == 404) {
        q = temp_city;
        fluent.showDialog(
            context: context,
            builder: (context) {
              return fluent.ContentDialog(
                title: Text("Weather"),
                content: Text("Item Not Found"),
                actions: [
                  fluent.Button(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      } else {
        throw (Exception);
      }
    } catch (Exception) {
      fluent.showDialog(
          context: context,
          builder: (context) {
            return fluent.ContentDialog(
              title: Text("Weather"),
              content: Text("Check the Internet Connection \n ${Exception}"),
              actions: [
                fluent.Button(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
    setState(() => {});
  }

  @override
  void initState() {
    callapi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return fluent.NavigationView(
      pane: fluent.NavigationPane(
        selected: _pane_one,
        header: Text("Weather"),
        displayMode: fluent.PaneDisplayMode.compact,
        onChanged: (index) {
          setState(() {
            _pane_one = index;
          });
        },
        footerItems: [
          fluent.PaneItemSeparator(),
          fluent.PaneItem(
              icon: const Icon(fluent.FluentIcons.settings),
              title: const Text('Change City'),
              onTap: () => fluent.showDialog(
                  context: context,
                  builder: (context) {
                    return fluent.ContentDialog(
                      title: Text("Change City"),
                      content: fluent.Container(
                        height: 50,
                        child: Column(
                          children: [
                            fluent.TextFormBox(
                              controller: tc,
                            )
                          ],
                        ),
                      ),
                      actions: [
                        fluent.Button(
                          child: Text("OK"),
                          onPressed: () {
                            setState(() {
                              if (!tc.text.isEmpty) {
                                q = tc.text;
                              }
                              callapi();
                              Navigator.pop(context);
                            });
                          },
                        )
                      ],
                    );
                  }),
              body: windows_ui(
                  key: null,
                  city_name: city_name,
                  temp: temp,
                  fl: fl,
                  temp_max: temp_max,
                  temp_min: temp_min,
                  ico_url: ico_url,
                  desc: desc,
                  pressure: pressure,
                  humidity: humidity,
                  forecast_list: _forecast_list))
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String forecast_ico = "";
  String time = "";
  String city_name = "";
  String temp = "";
  String ico_url = "";
  String desc = "";
  String fl = "";
  List<Forecast_Model> _forecast_list = [];
  String temp_max = 'temp+max';
  String temp_min = 'temp_min';
  String pressure = 'pressure';
  String humidity = 'humidity';
  String q = "Jodhpur"; // city input
  late String temp_city; // If city is not found then restore the value
  TextEditingController tc = TextEditingController();

  callapi() async {
    try {
      var url = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=${q}&units=metric&appid=bebd9da120762f2b44fb9b1f056c90ef");
      var url1 = Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=${q}&units=metric&appid=bebd9da120762f2b44fb9b1f056c90ef");
      var responseForecast = await http.get(url1);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        temp_city = q;
        var data = await jsonDecode(response.body);
        var forecastData = await jsonDecode(responseForecast.body);
        print("Response Status: ${response.statusCode}");
        print("Response body: ${response.body}");
        city_name = data["name"]!.toString();
        temp = data["main"]["temp"]!.toString() +
            String.fromCharCode(0x00B0) +
            "C";
        ico_url = "https://openweathermap.org/img/wn/" +
            data["weather"][0]["icon"]!.toString() +
            "@2x.png";
        desc = data["weather"][0]["description"]!.toString();
        fl = data["main"]["feels_like"]!.toString() +
            String.fromCharCode(0x00B0) +
            "C";
        temp_max = data["main"]["temp_max"]!.toString() +
            String.fromCharCode(0x00B0) +
            "C";
        temp_min = data["main"]["temp_min"]!.toString() +
            String.fromCharCode(0x00B0) +
            "C";
        pressure = data["main"]["pressure"]!.toString();
        humidity = data["main"]["humidity"]!.toString();
        time = forecastData["list"][0]["dt_txt"]!.toString();
        for (int i = 0; i < forecastData["list"].length - 1; i++) {
          _forecast_list.add(Forecast_Model(
              forecastData["list"][i]["dt_txt"]!.toString(),
              "https://openweathermap.org/img/wn/" +
                  forecastData["list"][i]["weather"][0]["icon"]!.toString() +
                  "@2x.png",
              forecastData["list"][i]["weather"][0]["description"]!
                  .toString()));
        }
        ios_ui(
            key: null,
            city_name: city_name,
            temp: temp,
            fl: fl,
            temp_max: temp_max,
            temp_min: temp_min,
            ico_url: ico_url,
            desc: desc,
            pressure: pressure,
            humidity: humidity,
            forecast_list: _forecast_list);
        print(city_name);
        print(time);
      } else if (response.statusCode == 404) {
        q = temp_city;
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text("Weather"),
                  content: Text("Item Not Found"),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ));
      } else {
        throw (Exception);
      }
    } catch (Exception) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text("Weather"),
                content: Text(
                    "Check Your Internet Connection\n" + Exception.toString()),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
    }
    setState(() => {});
  }

  @override
  void initState() {
    callapi();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: GestureDetector(
            child: Icon(
              CupertinoIcons.refresh,
              size: 20,
            ),
            onTap: () {
              callapi();
            },
          ),
          middle: GestureDetector(
            child: Icon(
              CupertinoIcons.cloud_fill,
              size: 40,
            ),
            onTap: () {
              showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                          title: Text("About Weather"),
                          content: Text(
                              "Developed by:- \n Khushal Roop Rai\nVijay Kumar"),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ]));
            },
          ),
          trailing: GestureDetector(
            child: Icon(
              CupertinoIcons.settings,
              size: 20,
            ),
            onTap: () {
              showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                        title: Text("Change City"),
                        content: Card(
                            color: Colors.transparent,
                            elevation: 5,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  CupertinoTextField(
                                    controller: tc,
                                  )
                                ],
                              ),
                            )),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text("OK"),
                            onPressed: () {
                              if (!tc.text.isEmpty) {
                                q = tc.text;
                              }
                              callapi();
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ));
            },
          ),
        ),
        child: ios_ui(
            key: null,
            city_name: city_name,
            temp: temp,
            fl: fl,
            temp_max: temp_max,
            temp_min: temp_min,
            ico_url: ico_url,
            desc: desc,
            pressure: pressure,
            humidity: humidity,
            forecast_list: _forecast_list));
  }
}
