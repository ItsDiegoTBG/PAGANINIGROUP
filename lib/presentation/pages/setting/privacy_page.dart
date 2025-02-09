import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacidad"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SwitchTile(title: "Recuerdame"),
            const _SwitchTile(title: "Biometric ID"),
            const _SwitchTile(title: "Face ID"),
            const _SwitchTile(title: "SMS Authenticator"),
            const _SwitchTile(title: "Google Authenticator"),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // TODO: implementar cambio de contraseña fuera de la página: Olvidar Contraseña.
                  Navigator.pushNamed(context, Routes.FORGETPASSWORD);
                },
                child: const Text("Cambiar Contraseña", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;

  const _SwitchTile({required this.title});
  
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return SwitchListTile(
      title: Text(title),
      value: settings.getSwitchState(title),
      onChanged: (value) {
        settings.setSwitchState(title, value);
      },
      activeColor: AppColors.primaryColor,
    );
  }
}