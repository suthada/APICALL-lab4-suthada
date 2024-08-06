import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'weather.dart';
import 'weather_detail.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final List<String> cities = [
    'Bangkok',
    'Chiang Mai',
    'Chiang Rai',
    'Chonburi',
    'Krabi',
    'Lampang',
    'Lamphun',
    'Nakhon Pathom',
    'Nakhon Ratchasima',
    'Nakhon Si Thammarat',
    'Narathiwat',
    'Nonthaburi',
    'Nong Khai',
    'Pattani',
    'Phang Nga',
    'Phatthalung',
    'Phayao',
    'Phuket',
    'Prachuap Khiri Khan',
    'Ranong',
    'Rayong',
    'Sa Kaeo',
    'Sakon Nakhon',
    'Samut Prakan',
    'Samut Sakhon',
    'Samut Songkhram',
    'Saraburi',
    'Singburi',
    'Surat Thani',
    'Surin',
    'Tak',
    'Trang',
    'Trat',
    'Ubon Ratchathani',
    'Udon Thani',
    'Yala',
    'Yasothon'
  ];

  Future<WeatherResponse> getWeatherData(String city) async {
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=6378ac581297b40ccb71e6f85e65e17a'));
      if (response.statusCode == 200) {
        return WeatherResponse.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception("Failed to load data");
      }
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Weather App',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 33, 88, 176),
        ),
        body: ListView.builder(
          itemCount: cities.length,
          itemBuilder: (context, index) {
            return FutureBuilder<WeatherResponse>(
              future: getWeatherData(cities[index]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text(cities[index]),
                    trailing: const Icon(Icons.error, color: Colors.red),
                  );
                } else if (snapshot.hasData) {
                  var weatherData = snapshot.data!;
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 4.0,
                    color: Colors.pink[50],
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(cities[index],
                          style: const TextStyle(fontSize: 18)),
                      trailing: weatherData.weather != null &&
                              weatherData.weather!.isNotEmpty
                          ? Image.network(
                              'http://openweathermap.org/img/wn/${weatherData.weather![0].icon}@2x.png',
                              height: 40,
                              width: 40,
                            )
                          : const Icon(Icons.error, color: Colors.red),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WeatherDetailPage(weatherData: weatherData),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return ListTile(
                    title: Text(cities[index]),
                    trailing: const Icon(Icons.error, color: Colors.red),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
