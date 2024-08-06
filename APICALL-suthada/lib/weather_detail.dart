import 'package:flutter/material.dart';
import 'weather.dart';

class WeatherDetailPage extends StatelessWidget {
  final WeatherResponse weatherData;

  const WeatherDetailPage({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weatherData.name ?? 'Weather Details'),
        backgroundColor: Color.fromARGB(255, 164, 213, 222),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                weatherData.name ?? 'Unknown',
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            if (weatherData.weather != null && weatherData.weather!.isNotEmpty)
              Center(
                child: Image.network(
                  'http://openweathermap.org/img/wn/${weatherData.weather![0].icon}@2x.png',
                  height: 100,
                  width: 100,
                ),
              ),
            const SizedBox(height: 16),
            _buildWeatherInfo(
                'Current Temperature', '${weatherData.main?.temp ?? 0.0}°C'),
            _buildWeatherInfo(
                'Min Temperature', '${weatherData.main?.tempMin ?? 0.0}°C'),
            _buildWeatherInfo(
                'Max Temperature', '${weatherData.main?.tempMax ?? 0.0}°C'),
            _buildWeatherInfo(
                'Pressure', '${weatherData.main?.pressure ?? 0} hPa'),
            _buildWeatherInfo(
                'Humidity', '${weatherData.main?.humidity ?? 0}%'),
            _buildWeatherInfo(
                'Sea Level', '${weatherData.main?.seaLevel ?? 0} m'),
            _buildWeatherInfo('Clouds', '${weatherData.clouds?.all ?? 0}%'),
            _buildWeatherInfo(
                'Rain (last 1h)', '${weatherData.rain?.d1h ?? 0.0} mm'),
            _buildWeatherInfo(
                'Sunset', _formatSunsetTime(weatherData.sys?.sunset ?? 0)),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  String _formatSunsetTime(int sunsetTime) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(sunsetTime * 1000);
    return '${dateTime.hour}:${dateTime.minute}';
  }
}
