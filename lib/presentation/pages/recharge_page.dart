// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/bottom_main_app.dart';
import 'package:paganini/presentation/widgets/floating_button_navbar_qr.dart';
import 'package:provider/provider.dart';

class RechargePage extends StatefulWidget {
  const RechargePage({super.key});

  @override
  State<RechargePage> createState() => RechargePageState();
}

class RechargePageState extends State<RechargePage> {
  String _selectedAmount = '';

  void _selectAmount(String amount) {
    setState(() {
      _selectedAmount = amount;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedAmount = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const ContentAppBar(),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Recarga',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ingrese un monto a recargar',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText:
                    _selectedAmount.isNotEmpty ? _selectedAmount : 'Monto',
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                _selectedAmount = value;
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'O seleccione un valor',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAmountButton('\$20'),
                _buildAmountButton('\$50'),
                _buildAmountButton('\$100'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _clearSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[200],
                    minimumSize: const Size(120, 50),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('Monto seleccionado: $_selectedAmount');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                    minimumSize: const Size(120, 50),
                  ),
                  child: const Text(
                    'Agregar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingButtonNavBarQr(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomMainAppBar(),
    );
  }

  Widget _buildAmountButton(String amount) {
    return ElevatedButton(
      onPressed: () => _selectAmount(amount),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple[200],
        minimumSize: const Size(80, 50),
      ),
      child: Text(amount),
    );
  }
}
