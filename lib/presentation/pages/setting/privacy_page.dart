import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';

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
                  // Change password action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Cambiar contraseña presionado")),
                  );
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

class _SwitchTile extends StatefulWidget {
  final String title;

  const _SwitchTile({required this.title});

  @override
  State<_SwitchTile> createState() => _SwitchTileState();
}

class _SwitchTileState extends State<_SwitchTile> {
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.title),
      value: isEnabled,
      onChanged: (value) {
        setState(() {
          isEnabled = value;
        });
      },
      activeColor: AppColors.primaryColor,
    );
  }
}
