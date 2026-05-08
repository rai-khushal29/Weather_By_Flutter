import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/ios_ui.dart';
import 'package:http/http.dart' as http;
import 'package:weather/windows_ui.dart';
import 'Forecast_Model.dart';

// ─── SharedPreferences helpers (shared, no duplication) ───────────────────────
Future<void> saveCityName(String cityName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('last_city', cityName);
}

Future<String> getSavedCityName({String fallback = 'Jodhpur'}) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('last_city') ?? fallback;
}
// ──────────────────────────────────────────────────────────────────────────────

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      home: MyHomePage(title: 'Weather'),
    );
  }
}

// ─── Shared weather state mixin ───────────────────────────────────────────────
mixin WeatherState<T extends StatefulWidget> on State<T> {
  String city_name = '';
  String temp = '';
  String ico_url = '';
  String desc = '';
  String fl = '';
  String temp_max = '';
  String temp_min = '';
  String pressure = '';
  String humidity = '';
  String time = '';
  List<Forecast_Model> forecast_list = [];

  String q = 'Jodhpur';
  String _lastValidCity = 'Jodhpur'; // replaces late temp_city
  final TextEditingController tc = TextEditingController();

  Future<void> loadSavedCity() async {
    q = await getSavedCityName();
    _lastValidCity = q;
  }

  Future<void> callapi() async {
    try {
      final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$q&units=metric&appid=bebd9da120762f2b44fb9b1f056c90ef');
      final url1 = Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$q&units=metric&appid=bebd9da120762f2b44fb9b1f056c90ef');

      final response = await http.get(url);
      final responseForecast = await http.get(url1);

      if (response.statusCode == 200) {
        _lastValidCity = q;
        await saveCityName(q); // ✅ Actually persist the city now

        final data = jsonDecode(response.body);
        final forecastData = jsonDecode(responseForecast.body);

        final deg = String.fromCharCode(0x00B0);

        city_name = data['name'].toString();
        temp = '${data['main']['temp']}${deg}C';
        ico_url =
            'https://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png';
        desc = data['weather'][0]['description'].toString();
        fl = '${data['main']['feels_like']}${deg}C';
        temp_max = '${data['main']['temp_max']}${deg}C';
        temp_min = '${data['main']['temp_min']}${deg}C';
        pressure = data['main']['pressure'].toString();
        humidity = data['main']['humidity'].toString();
        time = forecastData['list'][0]['dt_txt'].toString();

        // ✅ Clear before repopulating (was causing duplicates on refresh)
        forecast_list = [
          for (int i = 0; i < forecastData['list'].length - 1; i++)
            Forecast_Model(
              forecastData['list'][i]['dt_txt'].toString(),
              'https://openweathermap.org/img/wn/${forecastData['list'][i]['weather'][0]['icon']}@2x.png',
              forecastData['list'][i]['weather'][0]['description'].toString(),
            )
        ];
      } else if (response.statusCode == 404) {
        q = _lastValidCity; // restore last known good city
        onCityNotFound();
      } else {
        throw Exception('Unexpected status: ${response.statusCode}');
      }
    } catch (e) {
      onNetworkError(e);
    }

    if (mounted) setState(() {});
  }

  // Subclasses implement these to show platform-specific dialogs
  void onCityNotFound();

  void onNetworkError(Object error);
}
// ──────────────────────────────────────────────────────────────────────────────

// ─── iOS / Cupertino UI ───────────────────────────────────────────────────────
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WeatherState {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await loadSavedCity(); // ✅ Restore last city on launch
    callapi();
  }

  @override
  void onCityNotFound() {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Weather'),
        content: const Text('City not found.'),
        actions: [
          CupertinoDialogAction(
              child: const Text('OK'), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  @override
  void onNetworkError(Object error) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Weather'),
        content: Text('Check your internet connection.\n$error'),
        actions: [
          CupertinoDialogAction(
              child: const Text('OK'), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  void _showChangeCityDialog() {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Change City'),
        content: Card(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: CupertinoTextField(controller: tc),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              if (tc.text.isNotEmpty) q = tc.text;
              callapi();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: callapi,
          child: const Icon(CupertinoIcons.refresh, size: 20),
        ),
        middle: GestureDetector(
          onTap: () => showCupertinoDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: const Text('About Weather'),
              content:
                  const Text('Developed by:\nKhushal Roop Rai\nVijay Kumar'),
              actions: [
                CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          child: const Icon(CupertinoIcons.cloud_fill, size: 40),
        ),
        trailing: GestureDetector(
          onTap: _showChangeCityDialog,
          child: const Icon(CupertinoIcons.settings, size: 20),
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
        forecast_list: forecast_list,
      ),
    );
  }
}

// ─── Windows / Fluent UI ──────────────────────────────────────────────────────
class MyWindowsHomePage extends StatefulWidget {
  const MyWindowsHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyWindowsHomePage> createState() => _MyWindowsHomePageState();
}

class _MyWindowsHomePageState extends State<MyWindowsHomePage>
    with WeatherState {
  int _selectedPane = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await loadSavedCity(); // ✅ Restore last city on launch
    callapi();
  }

  @override
  void onCityNotFound() {
    fluent.showDialog(
      context: context,
      builder: (_) => fluent.ContentDialog(
        title: const Text('Weather'),
        content: const Text('City not found.'),
        actions: [
          fluent.Button(
              child: const Text('OK'), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  @override
  void onNetworkError(Object error) {
    fluent.showDialog(
      context: context,
      builder: (_) => fluent.ContentDialog(
        title: const Text('Weather'),
        content: Text('Check your internet connection.\n$error'),
        actions: [
          fluent.Button(
              child: const Text('OK'), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weatherWidget = windows_ui(
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
      forecast_list: forecast_list,
    );

    return fluent.NavigationView(
      pane: fluent.NavigationPane(
        selected: _selectedPane,
        header: const Text('Weather'),
        displayMode: fluent.PaneDisplayMode.compact,
        onChanged: (index) => setState(() => _selectedPane = index),
        footerItems: [
          fluent.PaneItemSeparator(),
          fluent.PaneItem(
            icon: const Icon(fluent.FluentIcons.settings),
            title: const Text('Change City'),
            body: weatherWidget,
            onTap: () => fluent.showDialog(
              context: context,
              builder: (_) => fluent.ContentDialog(
                title: const Text('Change City'),
                content: SizedBox(
                  height: 50,
                  child: fluent.TextFormBox(controller: tc),
                ),
                actions: [
                  fluent.Button(
                    child: const Text('OK'),
                    onPressed: () {
                      if (tc.text.isNotEmpty) q = tc.text;
                      callapi();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
