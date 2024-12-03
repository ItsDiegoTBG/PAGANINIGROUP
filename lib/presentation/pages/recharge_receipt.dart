import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/widgets/bottom_main_app.dart';
import 'package:paganini/presentation/widgets/floating_button_navbar_qr.dart';

class RechargeReceipt extends StatefulWidget {
  const RechargeReceipt({super.key});

  @override
  State<RechargeReceipt> createState() => _RechargeReceipt();
}

class _RechargeReceipt extends State<RechargeReceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PAGANINI'),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            SizedBox(height: 16),
            Text(
              'Recarga existosa exitosa!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Comprobante: 70856139',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Divider(height: 32),
            InfoRow(label: 'Monto', value: '\$50.00'),
            InfoRow(label: 'Costo de transacción', value: '\$0.00'),
            InfoRow(label: 'Fecha', value: '12 nov 2024'),
            Divider(height: 32),
            Text(
              'Cuenta que recibe',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            InfoRow(label: 'Nombre', value: 'Persona que recibe'),
            InfoRow(label: 'Número de cuenta', value: '****2765'),
            Divider(height: 32),
          ],
        ),
      ),
      floatingActionButton: const FloatingButtonNavBarQr(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomMainAppBar(),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({required this.label, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
