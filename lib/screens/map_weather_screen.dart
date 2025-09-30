import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapWeatherScreen extends StatefulWidget {
  @override
  _MapWeatherScreenState createState() => _MapWeatherScreenState();
}

class _MapWeatherScreenState extends State<MapWeatherScreen> {
  LatLng? selectedLocation;
  String? weatherInfo;

  void _onTap(LatLng latlng) async {
    setState(() {
      selectedLocation = latlng;
      weatherInfo = null;
    });
    await _fetchWeather(latlng);
  }

  Future<void> _fetchWeather(LatLng latlng) async {
    final apiKey = '1320e67dccce129f7825891eec1838c5';
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=${latlng.latitude}&lon=${latlng.longitude}&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        weatherInfo = 'Weather: ${data['weather'][0]['main']}, Temp: ${data['main']['temp']}°C';
      });
    } else {
      setState(() {
        weatherInfo = 'Failed to fetch weather.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Location & Weather')),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                initialCenter: LatLng(20.5937, 78.9629),
                initialZoom: 5,
                onTap: (tapPosition, latlng) => _onTap(latlng),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                if (selectedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: selectedLocation!,
                        width: 80,
                        height: 80,
                        child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (weatherInfo != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(weatherInfo!, style: TextStyle(fontSize: 18)),
            ),
        ],
      ),
    );
  }
}
