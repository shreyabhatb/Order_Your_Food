import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart_item.dart';

abstract class CartEvent {}
class AddToCart extends CartEvent {
  final CartItem item;
  AddToCart(this.item);
}
class RemoveFromCart extends CartEvent {
  final CartItem item;
  RemoveFromCart(this.item);
}
class ViewCart extends CartEvent {}

abstract class CartState {}
class CartInitial extends CartState {}
class CartUpdated extends CartState {
  final List<CartItem> items;
  CartUpdated(this.items);
}
class CartError extends CartState {
  final String message;
  CartError(this.message);
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial());
  // TODO: Implement event handlers
}
