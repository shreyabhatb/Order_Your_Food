import 'package:flutter/material.dart';
import '../models/address.dart';
import '../models/payment_option.dart';
import '../utils/app_theme.dart';
import 'package:latlong2/latlong.dart';
import 'map_select_screen.dart';

import 'home_screen.dart';

class AddressPaymentScreen extends StatefulWidget {
  const AddressPaymentScreen({super.key});

  @override
  State<AddressPaymentScreen> createState() => _AddressPaymentScreenState();
}

class _AddressPaymentScreenState extends State<AddressPaymentScreen> {
  final TextEditingController _addressController = TextEditingController();
  LatLng? _selectedLatLng;
  Address? _selectedAddress;
  PaymentOption? _selectedPayment;
  String? _selectedUpiApp;
  bool _isPaying = false;
  String? _error;

  final List<Address> _addresses = [];

  void _addAddress() {
    if (_addressController.text.isNotEmpty) {
      setState(() {
        final address = Address(id: DateTime.now().toString(), details: _addressController.text);
        _addresses.add(address);
        _selectedAddress = address;
        _addressController.clear();
        _selectedLatLng = null;
      });
    }
  }

  Future<void> _selectOnMap() async {
    final result = await Navigator.of(context).push<MapSelectResult>(
      MaterialPageRoute(builder: (_) => MapSelectScreen(initialLocation: _selectedLatLng)),
    );
    if (result != null) {
      setState(() {
        _selectedLatLng = result.latLng;
        _addressController.text = result.address ?? 'Lat: ${result.latLng.latitude}, Lng: ${result.latLng.longitude}';
        // Add the readable address to the address list for selection
        if (result.address != null && result.address!.isNotEmpty) {
          final address = Address(id: DateTime.now().toString(), details: result.address!);
          _addresses.add(address);
          _selectedAddress = address;
        }
      });
    }
  }

  void _placeOrder() async {
    if (_selectedAddress == null || _selectedPayment == null || (_selectedPayment == PaymentOption.upi && _selectedUpiApp == null)) {
      setState(() {
        _error = _selectedAddress == null
            ? 'Please select address.'
            : _selectedPayment == null
                ? 'Please select payment option.'
                : 'Please select UPI app.';
      });
      return;
    }
    setState(() {
      _isPaying = true;
      _error = null;
    });
    await Future.delayed(const Duration(seconds: 2));
    // Save order to global order history
    String restaurantDetails = '';
    String itemDetails = '';
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      restaurantDetails = args['restaurant'] ?? '';
      itemDetails = args['items'] ?? '';
    }
    final details = 'Restaurant: $restaurantDetails\nItems: $itemDetails\nAddress: ${_selectedAddress?.details ?? ''}\nPayment: ${_selectedPayment == PaymentOption.upi ? 'UPI ($_selectedUpiApp)' : 'Cash on Delivery'}';
    OrderHistory.orders.add(details);
    if (_selectedPayment == PaymentOption.upi) {
      // Simulate UPI payment success with selected app
      setState(() {
        _isPaying = false;
      });
      Navigator.of(context).pushReplacementNamed(
        '/orderPlaced',
        arguments: _selectedUpiApp,
      );
    } else {
      // Cash on delivery
      setState(() {
        _isPaying = false;
      });
      Navigator.of(context).pushReplacementNamed('/orderPlaced');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address & Payment'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Address:', style: TextStyle(color: Color(0xFF6C3483), fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(hintText: 'Enter address'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_location),
                  onPressed: _addAddress,
                ),
                IconButton(
                  icon: const Icon(Icons.map),
                  tooltip: 'Select on Map',
                  onPressed: _selectOnMap,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_addresses.isNotEmpty)
              DropdownButton<Address>(
                value: _selectedAddress,
                hint: const Text('Select Address'),
                items: _addresses.map((a) => DropdownMenuItem(value: a, child: Text(a.details))).toList(),
                onChanged: (a) => setState(() => _selectedAddress = a),
              ),
            const SizedBox(height: 24),
            const Text('Payment Option:', style: TextStyle(color: Color(0xFF6C3483), fontWeight: FontWeight.bold)),
            ListTile(
              title: const Text('UPI', style: TextStyle(color: Color(0xFF6C3483))),
              leading: Radio<PaymentOption>(
                value: PaymentOption.upi,
                groupValue: _selectedPayment,
                onChanged: (val) => setState(() {
                  _selectedPayment = val;
                  _selectedUpiApp = null;
                }),
              ),
            ),
            if (_selectedPayment == PaymentOption.upi)
              Padding(
                padding: const EdgeInsets.only(left: 32.0, bottom: 8.0),
                child: DropdownButton<String>(
                  value: _selectedUpiApp,
                  hint: const Text('Select UPI App'),
                  items: const [
                    DropdownMenuItem(value: 'GPay', child: Text('GPay')),
                    DropdownMenuItem(value: 'PhonePe', child: Text('PhonePe')),
                  ],
                  onChanged: (val) => setState(() => _selectedUpiApp = val),
                ),
              ),
            ListTile(
              title: const Text('Cash on Delivery', style: TextStyle(color: Color(0xFF6C3483))),
              leading: Radio<PaymentOption>(
                value: PaymentOption.cashOnDelivery,
                groupValue: _selectedPayment,
                onChanged: (val) => setState(() => _selectedPayment = val),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            const Spacer(),
            _isPaying
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
                    onPressed: _placeOrder,
                    child: const Text('Place Order', style: TextStyle(color: Colors.black)),
                  ),
          ],
        ),
      ),
    );
  }
}
