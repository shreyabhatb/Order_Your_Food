import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import 'restaurant_list_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchBloc>().add(LoadSearchHistory());
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Search for restaurant or dish...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (query) {
                context.read<SearchBloc>().add(Search(query));
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchLoaded) {
                    return ListView(
                      children: [
                        ...state.restaurants.map((r) => ListTile(
                              title: Text(r.name),
                              subtitle: Text(r.cuisine),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => RestaurantListScreen(restaurants: [r]),
                                  ),
                                );
                              },
                            )),
                      ],
                    );
                  } else if (state is SearchHistoryLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Search History:', style: TextStyle(fontWeight: FontWeight.bold)),
                        if (state.history.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('No previous searches.'),
                          ),
                        ...state.history.map((h) => ListTile(
                              leading: Icon(Icons.history),
                              title: Text(h),
                            )),
                      ],
                    );
                  } else if (state is SearchError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 48),
                          const SizedBox(height: 8),
                          Text(state.message, style: const TextStyle(color: Colors.red, fontSize: 18)),
                        ],
                      ),
                    );
                  }
                  return const Center(child: Text('Search for your favorite food!'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
