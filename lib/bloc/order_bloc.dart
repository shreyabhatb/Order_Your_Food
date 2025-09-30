import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/address.dart';
import '../models/payment_option.dart';

abstract class OrderEvent {}
class AddAddress extends OrderEvent {
  final Address address;
  AddAddress(this.address);
}
class SelectPayment extends OrderEvent {
  final PaymentOption option;
  SelectPayment(this.option);
}
class PlaceOrder extends OrderEvent {}

abstract class OrderState {}
class OrderInitial extends OrderState {}
class AddressAdded extends OrderState {
  final Address address;
  AddressAdded(this.address);
}
class PaymentSelected extends OrderState {
  final PaymentOption option;
  PaymentSelected(this.option);
}
class OrderPlaced extends OrderState {}
class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial());
  // TODO: Implement event handlers
}
