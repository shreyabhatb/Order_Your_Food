import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import 'restaurant_detail_screen.dart';

class RestaurantListScreen extends StatefulWidget {
  final List<Restaurant> restaurants;
  const RestaurantListScreen({super.key, required this.restaurants});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  double _minRating = 0;
  bool? _isVeg;

  List<Restaurant> get filteredRestaurants {
    return widget.restaurants.where((r) {
      final ratingOk = r.rating >= _minRating;
      final vegOk = _isVeg == null || r.isVeg == _isVeg;
      return ratingOk && vegOk;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Text('Min Rating:'),
                Slider(
                  value: _minRating,
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: _minRating.toString(),
                  onChanged: (val) => setState(() => _minRating = val),
                ),
                const SizedBox(width: 16),
                const Text('Type:'),
                DropdownButton<bool?>(
                  value: _isVeg,
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All')),
                    DropdownMenuItem(value: true, child: Text('Veg')),
                    DropdownMenuItem(value: false, child: Text('Non-Veg')),
                  ],
                  onChanged: (val) => setState(() => _isVeg = val),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredRestaurants.isEmpty
                ? const Center(child: Text('No restaurants found.'))
                : ListView.builder(
                    itemCount: filteredRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = filteredRestaurants[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(restaurant.name),
                          subtitle: Text('${restaurant.cuisine} • ${restaurant.rating} ★'),
                          trailing: restaurant.isVeg
                              ? const Icon(Icons.eco, color: Colors.green)
                              : const Icon(Icons.restaurant, color: Colors.red),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RestaurantDetailScreen(restaurant: restaurant),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
