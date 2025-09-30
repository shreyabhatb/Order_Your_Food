import '../models/restaurant.dart';
import '../models/dish.dart';

List<Restaurant> getRestaurantsForCuisine(String cuisine) {
  // Use meaningful restaurant and dish names for each cuisine
  final restaurantNames = {
    'South Spice': [
      'Kerala Kitchen', 'Madras Masala', 'Curry Leaf', 'Spice Route', 'Southern Delights',
      'Dosa House', 'Chettinad Corner', 'Malabar Treats', 'Andhra Aroma', 'Udupi Cafe'
    ],
    'North Delight': [
      'Punjabi Palace', 'Delhi Diner', 'Lucknowi Bites', 'Royal Rajput', 'Kashmir Flavors',
      'Agra Eats', 'Awadhi Table', 'Rajasthani Rasoi', 'Haveli Hub', 'Banarasi Bhoj'
    ],
    'Dragon Bowl': [
      'Golden Wok', 'Szechuan Spice', 'Dragon Express', 'Mandarin Magic', 'Red Lantern',
      'Chopstick House', 'Panda Palace', 'Dynasty Dine', 'Lotus Garden', 'Wok & Roll'
    ],
  };


  final restNames = restaurantNames[cuisine] ?? List.generate(10, (i) => '$cuisine Restaurant ${i + 1}');

  // Define veg and non-veg dishes for each cuisine
  final vegDishes = {
    'South Spice': [
      'Masala Dosa', 'Idli Sambar', 'Uttapam', 'Vada', 'Pesarattu', 'Appam', 'Avial', 'Rasam', 'Tomato Chutney', 'Coconut Chutney', 'Vegetable Kurma'
    ],
    'North Delight': [
      'Paneer Tikka', 'Dal Makhani', 'Aloo Paratha', 'Chole Bhature', 'Rajma', 'Shahi Paneer', 'Lassi', 'Baingan Bharta', 'Gajar Halwa', 'Palak Paneer', 'Kadhi Pakora'
    ],
    'Dragon Bowl': [
      'Spring Rolls', 'Fried Rice', 'Chow Mein', 'Hot & Sour Soup', 'Szechuan Tofu', 'Dim Sum', 'Egg Drop Soup', 'Vegetable Dumplings', 'Mapo Tofu', 'Stir Fried Broccoli', 'Sweet Corn Soup'
    ],
  };
  final nonVegDishes = {
    'South Spice': [
      'Chettinad Chicken', 'Fish Curry'
    ],
    'North Delight': [
      'Butter Chicken', 'Rogan Josh', 'Kebabs'
    ],
    'Dragon Bowl': [
      'Kung Pao Chicken', 'Sweet & Sour Pork', 'Peking Duck'
    ],
  };

  return List.generate(10, (rIndex) {
    final restaurantId = '${cuisine}_rest_$rIndex';
    final isVeg = rIndex % 2 == 0;
    List<String> dishPool = [];
    if (isVeg) {
      dishPool = vegDishes[cuisine] ?? [];
    } else {
      dishPool = [
        ...(vegDishes[cuisine] ?? []),
        ...(nonVegDishes[cuisine] ?? []),
      ];
    }
    // Ensure at least 5 unique dishes per restaurant
    final uniqueDishes = dishPool.length >= 5
        ? dishPool.sublist(rIndex % (dishPool.length - 4), (rIndex % (dishPool.length - 4)) + 5)
        : dishPool;
    // Add remaining dishes randomly
    final remainingDishes = dishPool.where((d) => !uniqueDishes.contains(d)).toList();
    remainingDishes.shuffle();
    final menuDishes = [...uniqueDishes, ...remainingDishes.take(5)];
    return Restaurant(
      id: restaurantId,
      name: restNames[rIndex % restNames.length],
      cuisine: cuisine,
      rating: 3.5 + (rIndex % 3),
      isVeg: isVeg,
      distance: 1.0 + rIndex,
      menu: List.generate(menuDishes.length, (dIndex) {
        final dishName = menuDishes[dIndex];
        final isDishVeg = (vegDishes[cuisine]?.contains(dishName) ?? false);
        double price;
        if (dishName == 'Idli Sambar') {
          price = 70.0;
        } else if (dishName == 'Vada') {
          price = 60.0;
        } else if (isDishVeg) {
          price = 80.0 + (dIndex * 7) + (rIndex * 2);
        } else {
          price = 120.0 + (dIndex * 12) + (rIndex * 3);
        }
        return Dish(
          id: '${restaurantId}_dish_$dIndex',
          name: dishName,
          imageUrl: '',
          price: price,
          isVeg: isDishVeg,
          restaurantId: restaurantId,
        );
      }),
    );
  });
}
