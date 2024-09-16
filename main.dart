import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pronóstico del Clima',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String _temperature = '';
  String _condition = '';
  String _icon = '';

  Future<void> _getWeather(String city) async {
    final apiKey = 'YOUR_API_KEY'; // Reemplaza con tu clave de API
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _temperature = '${data['main']['temp']}°C';
          _condition = data['weather'][0]['description'];
          _icon =
              'http://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png';
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      setState(() {
        _temperature = 'Error';
        _condition = 'Unable to get weather data';
        _icon = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pronóstico del Clima'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Ingrese ciudad',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _getWeather(_cityController.text);
              },
              child: Text('Consultar Clima'),
            ),
            SizedBox(height: 20),
            if (_icon.isNotEmpty) Image.network(_icon),
            Text(
              _temperature,
              style: TextStyle(fontSize: 24),
            ),
            Text(
              _condition,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
