
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../utils/dummy_data.dart';
import 'restaurant_list_screen.dart';
import 'restaurant_detail_screen.dart';
import 'order_history_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_weather_screen.dart';

// Global order history storage
class OrderHistory {
  static final List<String> orders = [];
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  Future<void> _performSearch(String query) async {
    setState(() { _isSearching = true; });
    final restaurants = getRestaurantsForCuisine('South Spice')
      + getRestaurantsForCuisine('North Delight')
      + getRestaurantsForCuisine('Dragon Bowl');
    final queryLower = query.toLowerCase();
    final restaurantMatches = restaurants.where((r) => r.name.toLowerCase().contains(queryLower)).toList();
    final dishMatches = restaurants.where((r) => r.menu.any((d) => d.name.toLowerCase().contains(queryLower))).toList();
    if (restaurantMatches.isNotEmpty) {
      setState(() { _searchResults = restaurantMatches; _isSearching = false; });
    } else if (dishMatches.isNotEmpty) {
      setState(() { _searchResults = dishMatches; _isSearching = false; });
    } else {
      setState(() { _searchResults = []; _isSearching = false; });
    }
  }
  final List<String> _cities = ['Bangalore', 'Mangalore', 'Mumbai', 'Delhi', 'Chennai', 'Hyderabad'];
  String _selectedCity = 'Bangalore';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(LoadHome());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MasalaSwada'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/food_background.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.15),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        'MasalaSwada',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentColor,
                          fontFamily: 'Caveat', // Use a custom font if available, else default
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Have your favorite instantly 🌶️🍴',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6C3483),
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppTheme.accentColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedCity,
                        items: _cities.map((city) => DropdownMenuItem(
                          value: city,
                          child: Text(city, style: Theme.of(context).textTheme.titleMedium),
                        )).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedCity = val;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.map),
                      label: const Text('Select on Map'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MapWeatherScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                // Search bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                    border: Border.all(color: AppTheme.accentColor, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Color(0xFF6C3483)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search for restaurant or dish...',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Color(0xFF6C3483), fontWeight: FontWeight.w500, fontSize: 16),
                          onSubmitted: (query) {
                            if (query.trim().isNotEmpty) {
                              _performSearch(query.trim());
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF6C3483)),
                        onPressed: () {
                          _searchController.clear();
                          setState(() { _searchResults = []; });
                        },
                      ),
                    ],
                  ),
                ),
                if (_isSearching)
                  const Center(child: CircularProgressIndicator()),
                if (!_isSearching && _searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Search Results:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, idx) {
                              final r = _searchResults[idx];
                              return Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  title: Text(r.name),
                                  subtitle: Text(r.cuisine),
                                  trailing: r.isVeg
                                      ? const Icon(Icons.eco, color: Colors.green)
                                      : const Icon(Icons.restaurant, color: Colors.red),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => RestaurantDetailScreen(restaurant: r),
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
                  ),
                // Cuisine cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _CuisineCard(
                      label: 'South Spice',
                      color: AppTheme.accentColor,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RestaurantListScreen(
                              restaurants: getRestaurantsForCuisine('South Spice'),
                            ),
                          ),
                        );
                      },
                    ),
                    _CuisineCard(
                      label: 'North Delight',
                      color: AppTheme.accentColor,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RestaurantListScreen(
                              restaurants: getRestaurantsForCuisine('North Delight'),
                            ),
                          ),
                        );
                      },
                    ),
                    _CuisineCard(
                      label: 'Dragon Bowl',
                      color: AppTheme.accentColor,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RestaurantListScreen(
                              restaurants: getRestaurantsForCuisine('Dragon Bowl'),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
        selectedItemColor: AppTheme.accentColor,
        backgroundColor: AppTheme.primaryColor,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OrderHistoryScreen(orders: OrderHistory.orders),
              ),
            );
          }
        },
      ),
    );
  }
}

class _CuisineCard extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _CuisineCard({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Center(
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}

class _MapPickerDialog extends StatefulWidget {
  const _MapPickerDialog();

  @override
  State<_MapPickerDialog> createState() => _MapPickerDialogState();
}

class _MapPickerDialogState extends State<_MapPickerDialog> {
  late LatLng _location;

  @override
  void initState() {
    super.initState();
    _location = const LatLng(28.6139, 77.2090); // Default: New Delhi
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: 350,
        height: 400,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: _location, zoom: 14),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('Select'),
          onPressed: () => Navigator.of(context).pop(_location),
        ),
      ],
    );
  }
}