import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

import 'home_screen.dart';

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final upiApp = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MasalaSwada'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: AppTheme.accentColor, size: 80),
            const SizedBox(height: 24),
            Text('Thank you!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            const SizedBox(height: 8),
            Text('Your order has been placed successfully.', style: TextStyle(color: AppTheme.primaryColor)),
            const SizedBox(height: 8),
            Text('Have your favorite instantly 🌶️🍴', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppTheme.primaryColor)),
            if (upiApp != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text('Paid via $upiApp', style: TextStyle(fontSize: 18, color: AppTheme.primaryColor)),
              ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.home),
              label: const Text('Home'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
