import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapSelectResult {
  final LatLng latLng;
  final String? address;
  MapSelectResult({required this.latLng, this.address});
}

class MapSelectScreen extends StatefulWidget {
  final LatLng? initialLocation;
  const MapSelectScreen({super.key, this.initialLocation});

  @override
  State<MapSelectScreen> createState() => _MapSelectScreenState();
}

class _MapSelectScreenState extends State<MapSelectScreen> {
  LatLng? _selectedLocation;
  String? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation ?? LatLng(12.9716, 77.5946); // Default: Bangalore
  }

  void _onTap(LatLng latlng) async {
    setState(() {
      _selectedLocation = latlng;
      _selectedAddress = null;
    });
    await _reverseGeocode(latlng);
  }

  Future<void> _reverseGeocode(LatLng latlng) async {
    final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=${latlng.latitude}&lon=${latlng.longitude}';
    try {
      final response = await http.get(Uri.parse(url), headers: {'User-Agent': 'foodexpress-app'});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _selectedAddress = data['display_name'] ?? 'Unknown address';
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = 'Unknown address';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Address on Map'), backgroundColor: Colors.deepOrangeAccent),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                initialCenter: _selectedLocation!,
                initialZoom: 13,
                onTap: (tapPosition, latlng) => _onTap(latlng),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                if (_selectedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLocation!,
                        width: 80,
                        height: 80,
                        child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (_selectedAddress != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_selectedAddress!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            ),
        ],
      ),
      floatingActionButton: _selectedLocation != null
          ? FloatingActionButton.extended(
              backgroundColor: Colors.deepOrange,
              icon: const Icon(Icons.check),
              label: const Text('Select'),
              onPressed: () {
                Navigator.of(context).pop(MapSelectResult(latLng: _selectedLocation!, address: _selectedAddress));
              },
            )
          : null,
    );
  }
}
