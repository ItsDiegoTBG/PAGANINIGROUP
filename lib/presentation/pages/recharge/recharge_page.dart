// ignore_for_file: avoid_print

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/helpers/show_animated_snackbar.dart';
import 'package:paganini/presentation/pages/recharge/confirm_recharge_page.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/floating_button_paganini.dart';

class RechargePage extends StatefulWidget {
  const RechargePage({super.key});

  @override
  State<RechargePage> createState() => RechargePageState();
}

class RechargePageState extends State<RechargePage> {
  TextEditingController controllerAmount = TextEditingController();
  String _selectedAmount = '';

  void _selectAmount(String amount) {
    setState(() {
      controllerAmount.text = amount;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedAmount = '';
      controllerAmount.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const ContentAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primaryColor)),
                    child: const Text(
                      'Recarga',
                      style: TextStyle(
                          color: AppColors.primaryColor, fontSize: 24),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            const Text(
              'Ingrese un monto a recargar',
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: controllerAmount,
                style: const TextStyle(fontSize: 20),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.attach_money_rounded,
                    color: AppColors.primaryColor,
                    size: 40,
                  ),
                  hintText:
                      _selectedAmount.isNotEmpty ? _selectedAmount : 'Monto',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 10.0), // Ajusta el valor vertical
                ),
                onChanged: (value) {
                  _selectedAmount = value;
                },
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'o seleccione un valor',
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAmountButton('10'),
                _buildAmountButton('20'),
                _buildAmountButton('30'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAmountButton('50'),
                _buildAmountButton('100'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _clearSelection,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Ajusta el valor para más o menos curvatura
                    ),
                    backgroundColor: Colors.red[300],
                    minimumSize: const Size(120, 50),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    debugPrint('Monto seleccionado: $controllerAmount');
                    final monto = controllerAmount.text.isNotEmpty
                        ? double.tryParse(controllerAmount.text)
                        : 0.0;
                    if (controllerAmount.text.isEmpty) {
                    
                      ShowAnimatedSnackBar.show(context, "Por favor ingrese un monto",Icons.info, AppColors.blueColors);
                      return;
                    }

                    if (monto == null || monto <= 0) {
                    
                      ShowAnimatedSnackBar.show(context, "Por favor ingrese un monto válido",Icons.info, AppColors.blueColors);
                      return;
                    }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConfirmRechargePage(
                                valueRecharge: controllerAmount.text)));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Ajusta el valor para más o menos curvatura
                    ),
                    backgroundColor: Colors.green[300],
                    minimumSize: const Size(120, 50),
                  ),
                  child: const Text(
                    'Agregar',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingButtonPaganini(
        onPressed: () {
          Navigator.pop(context);
        },
        iconData: Icons.arrow_back_rounded,
      ),
    );
  }

  Widget _buildAmountButton(String amount) {
    return ElevatedButton(
      onPressed: () => _selectAmount(amount),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryColor,
        minimumSize: const Size(100, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              10), // Ajusta el valor para más o menos curvatura
        ),
      ),
      child: Text(
        "\$$amount",
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}
