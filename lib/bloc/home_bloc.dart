
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/restaurant.dart';
import '../repositories/food_repository.dart';

abstract class HomeEvent {}
class LoadHome extends HomeEvent {}
class SearchQueryChanged extends HomeEvent {
  final String query;
  SearchQueryChanged(this.query);
}

abstract class HomeState {}
class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final List<Restaurant> restaurants;
  HomeLoaded(this.restaurants);
}
class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

// ...existing code...
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FoodRepository _foodRepository = FoodRepository();

  HomeBloc() : super(HomeInitial()) {
    on<LoadHome>((event, emit) async {
      emit(HomeLoading());
      try {
        final restaurants = await _foodRepository.fetchRestaurants();
        emit(HomeLoaded(restaurants));
      } catch (e) {
        emit(HomeError('Failed to load restaurants'));
      }
    });
    // Add more event handlers as needed
  }
}
