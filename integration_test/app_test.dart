import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:paganini/app_loader.dart';

// Asegúrate de que la ruta de tu main.dart sea correcta

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login test', (tester) async {
    // Inicia la aplicación
    await tester.pumpWidget(const AppLoader());

    // Encuentra los campos de email y contraseña
    final emailField = find.byKey(const Key('emailField'));
    final passwordField = find.byKey(const Key('passwordField'));
    final loginButton = find.text('Iniciar Sesion');

    // Ingresa un email y una contraseña
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');

    // Realiza clic en el botón de inicio de sesión
    await tester.tap(loginButton);
    await tester.pumpAndSettle(); // Espera a que la animación y los cambios ocurran

    // Verifica si la navegación fue exitosa (por ejemplo, si la página de inicio de sesión desapareció)
    expect(find.text('Bienvenido'), findsNothing); // La página de login ya no debería estar visible

    // Verifica si la página de destino está presente, lo que indica que el login fue exitoso
   
  });
}
