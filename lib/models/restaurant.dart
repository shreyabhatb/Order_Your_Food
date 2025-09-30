import 'dish.dart';

class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final bool isVeg;
  final double distance;
  final List<Dish> menu;

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.isVeg,
    required this.distance,
    required this.menu,
  });
}
