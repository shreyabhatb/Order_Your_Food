import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/restaurant.dart';

abstract class RestaurantEvent {}
class LoadRestaurantDetails extends RestaurantEvent {
  final String restaurantId;
  LoadRestaurantDetails(this.restaurantId);
}
class FilterRestaurants extends RestaurantEvent {
  final double minRating;
  final bool? isVeg;
  FilterRestaurants({required this.minRating, this.isVeg});
}

abstract class RestaurantState {}
class RestaurantInitial extends RestaurantState {}
class RestaurantLoading extends RestaurantState {}
class RestaurantLoaded extends RestaurantState {
  final Restaurant restaurant;
  RestaurantLoaded(this.restaurant);
}
class RestaurantError extends RestaurantState {
  final String message;
  RestaurantError(this.message);
}

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  RestaurantBloc() : super(RestaurantInitial());
  // TODO: Implement event handlers
}
