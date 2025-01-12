import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paganini/presentation/providers/biometric_auth_provider.dart';

class BiometricAuthPage extends StatelessWidget {
  const BiometricAuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bioProvider = Provider.of<BiometricAuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Biometric Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await bioProvider.authenticateWithBiometrics();
              Navigator.pushReplacementNamed(context, '/home');
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          },
          child: const Text('Login with Biometrics'),
        ),
      ),
    );
  }
}

