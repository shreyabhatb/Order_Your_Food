import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  final List<String> orders;
  const OrderHistoryScreen({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: orders.isEmpty
          ? const Center(child: Text('No orders placed yet.'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, idx) {
                final order = orders[idx];
                final lines = order.split('\n');
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: lines.map((line) => Text(line, style: const TextStyle(fontSize: 16))).toList(),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
