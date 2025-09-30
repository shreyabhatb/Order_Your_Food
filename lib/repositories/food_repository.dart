import '../models/restaurant.dart';
import '../models/dish.dart';
import '../utils/dummy_data.dart';


class FoodRepository {
  Future<List<Restaurant>> fetchRestaurants() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      // Import dummy data for all cuisines
      final southIndianRestaurants = getRestaurantsForCuisine('South Spice');
      final northIndianRestaurants = getRestaurantsForCuisine('North Delight');
      final chineseRestaurants = getRestaurantsForCuisine('Dragon Bowl');
      return [
        ...southIndianRestaurants,
        ...northIndianRestaurants,
        ...chineseRestaurants,
      ];
    } catch (e) {
      throw Exception('Failed to fetch restaurants');
    }
  }

  Future<List<Dish>> searchDishes(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // For now, return empty. To be implemented in search workflow.
    return [];
  }
}
