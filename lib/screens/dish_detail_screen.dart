import 'package:flutter/material.dart';
import '../models/dish.dart';

class DishDetailScreen extends StatelessWidget {
  final Dish dish;
  const DishDetailScreen({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dish.name),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Colors.grey[200],
                child: dish.isVeg
                    ? const Icon(Icons.eco, color: Colors.green, size: 40)
                    : const Icon(Icons.restaurant, color: Colors.red, size: 40),
              ),
            ),
            const SizedBox(height: 24),
            Text(dish.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Price: ₹${dish.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text(dish.isVeg ? 'Vegetarian' : 'Non-Vegetarian', style: TextStyle(fontSize: 16, color: dish.isVeg ? Colors.green : Colors.red)),
            const SizedBox(height: 12),
            if (dish.imageUrl.isNotEmpty)
              Center(
                child: Image.network(dish.imageUrl, height: 120),
              ),
            const SizedBox(height: 24),
            Text('Restaurant ID: ${dish.restaurantId}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
