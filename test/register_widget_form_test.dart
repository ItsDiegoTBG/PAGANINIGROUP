import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:paganini/firebase_options.dart';
import 'package:paganini/presentation/pages/login/register_page.dart';

void main() async {
  
  TestWidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  testWidgets('Register User Test', (WidgetTester tester) async {
    // Crea un widget de prueba
    await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

    // Encuentra los campos de texto y el botón
    final firstNameField = find.byType(TextFormField).at(0);
    final lastNameField = find.byType(TextFormField).at(1);
    final cedField = find.byType(TextFormField).at(2);
    final emailField = find.byType(TextFormField).at(3);
    final phoneField = find.byType(TextFormField).at(4);
    final passwordField = find.byType(TextFormField).at(5);
    final registerButton = find.text('Crear Usuario');

    // Ingresa datos en los campos
    await tester.enterText(firstNameField, 'Carlos');
    await tester.enterText(lastNameField, 'Barciona');
    await tester.enterText(cedField, '0954623412');
    await tester.enterText(emailField, 'carlos@gmail.com');
    await tester.enterText(phoneField, '0990095632');
    await tester.enterText(passwordField, 'uurRL9yK9ca\$');

    // Presiona el botón de registro
    await tester.tap(registerButton);
    await tester.pumpAndSettle(); // Espera a que se complete la animación

    // Verifica que se muestre un mensaje de éxito
    expect(find.text('Registro exitoso'), findsOneWidget);
  });
}