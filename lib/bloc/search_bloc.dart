import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/restaurant.dart';
import '../models/dish.dart';
import '../repositories/food_repository.dart';

abstract class SearchEvent {}
class Search extends SearchEvent {
  final String query;
  Search(this.query);
}
class LoadSearchHistory extends SearchEvent {}

abstract class SearchState {}
class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchLoaded extends SearchState {
  final List<Restaurant> restaurants;
  final List<Dish> dishes;
  SearchLoaded(this.restaurants, this.dishes);
}
class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
class SearchHistoryLoaded extends SearchState {
  final List<String> history;
  SearchHistoryLoaded(this.history);
}

// ...existing code...
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FoodRepository _foodRepository = FoodRepository();
  final List<String> _searchHistory = [];

  SearchBloc() : super(SearchInitial()) {
    on<Search>((event, emit) async {
      emit(SearchLoading());
      try {
        final restaurants = await _foodRepository.fetchRestaurants();
        final queryLower = event.query.toLowerCase();
        // Find restaurants by name
        final restaurantMatches = restaurants.where((r) => r.name.toLowerCase().contains(queryLower)).toList();
        // Find dishes by name
        final dishes = restaurants.expand((r) => r.menu).where((d) => d.name.toLowerCase().contains(queryLower)).toList();
        // Find restaurants that have the dish
        final restaurantsWithDish = restaurants.where((r) => r.menu.any((d) => d.name.toLowerCase().contains(queryLower))).toList();

        if (restaurantMatches.isNotEmpty) {
          // Add restaurant names to history
          for (var r in restaurantMatches) {
            _searchHistory.add(r.name);
          }
          emit(SearchLoaded(restaurantMatches, []));
        } else if (dishes.isNotEmpty) {
          // Add dish names to history
          for (var d in dishes) {
            _searchHistory.add(d.name);
          }
          emit(SearchLoaded(restaurantsWithDish, dishes));
        } else {
          emit(SearchError('No results found'));
        }
      } catch (e) {
        emit(SearchError('Search failed'));
      }
    });
    on<LoadSearchHistory>((event, emit) {
      emit(SearchHistoryLoaded(List.from(_searchHistory.reversed)));
    });
  }
}
