class Dish {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final bool isVeg;
  final String restaurantId;

  Dish({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.isVeg,
    required this.restaurantId,
  });
}
