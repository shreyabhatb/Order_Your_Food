import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../utils/app_theme.dart';
import 'address_payment_screen.dart';

class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  const CartScreen({super.key, required this.cartItems});

  double get total => cartItems.fold(0, (sum, item) => sum + item.dish.price * item.quantity);

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your Cart'),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
        ),
        backgroundColor: AppTheme.backgroundColor,
        body: cartItems.isEmpty
            ? const Center(child: Text('Your cart is empty.'))
            : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  ...cartItems.map((item) => Card(
                        color: AppTheme.backgroundColor.withOpacity(0.7),
                        child: ListTile(
                          title: Text(item.dish.name, style: const TextStyle(color: Color(0xFF6C3483))),
                          subtitle: Text('Qty: ${item.quantity}', style: const TextStyle(color: Color(0xFF6C3483))),
                          trailing: Text('₹${(item.dish.price * item.quantity).toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF6C3483))),
                        ),
                      )),
                  const SizedBox(height: 16),
                  Text('Total: ₹${total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF6C3483))),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
                    child: const Text('Proceed to Address & Payment', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      // Collect restaurant and dish details
                      String restaurantName = '';
                      if (cartItems.isNotEmpty) {
                        // Try to get restaurant name from dish.restaurantId
                        restaurantName = cartItems.first.dish.restaurantId;
                        // If you have access to restaurant object, use its name
                        // Otherwise, restaurantId will be used
                      }
                      String dishDetails = cartItems.map((item) => '${item.dish.name} (x${item.quantity})').join(', ');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddressPaymentScreen(),
                          settings: RouteSettings(arguments: {
                            'restaurant': restaurantName,
                            'items': dishDetails,
                          }),
                        ),
                      );
                    },
                  ),
                ],
              ),
      );
  }
}
