import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../models/dish.dart';
import '../models/cart_item.dart';
import '../utils/app_theme.dart';
import 'cart_screen.dart';
import 'dish_detail_screen.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final List<CartItem> _cart = [];

  void _addToCart(Dish dish) {
    setState(() {
      final existing = _cart.where((item) => item.dish.id == dish.id).toList();
      if (existing.isNotEmpty) {
        existing.first.quantity++;
      } else {
        _cart.add(CartItem(dish: dish));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(widget.restaurant.cuisine, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Distance: ${widget.restaurant.distance} km'),
          Text('Rating: ${widget.restaurant.rating} ★'),
          const SizedBox(height: 16),
          ...widget.restaurant.menu.map((dish) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: AppTheme.backgroundColor.withOpacity(0.7),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.accentColor.withOpacity(0.2),
                    child: dish.isVeg
                        ? const Icon(Icons.eco, color: Colors.green)
                        : const Icon(Icons.restaurant, color: Colors.red),
                  ),
                  title: Text(dish.name, style: const TextStyle(color: Color(0xFF6C3483))),
                  subtitle: Text('₹${dish.price.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF6C3483))),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
                    child: const Text('Add +', style: TextStyle(color: Colors.black)),
                    onPressed: () => _addToCart(dish),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DishDetailScreen(dish: dish),
                      ),
                    );
                  },
                ),
              )),
        ],
      ),
      bottomNavigationBar: _cart.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Items added: ${_cart.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                    child: const Text('View Cart'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CartScreen(cartItems: _cart),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
