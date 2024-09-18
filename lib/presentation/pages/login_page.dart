import 'package:flutter/material.dart';
import 'package:paganini/utils/colors.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Bienvenido',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Toggle Buttons
            Container(
              width: 350,
              //height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Center(
                child: ToggleButtons(
                  borderColor: Colors.transparent,
                  isSelected: [selectedIndex == 0, selectedIndex == 1],
                  onPressed: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  fillColor: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  selectedColor: Colors.black,
                  // color: Colors.grey[200],
                  selectedBorderColor: Colors.transparent,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Material(
                        elevation: selectedIndex == 0 ? 10 : 0,
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 7, bottom: 7, left: 12, right: 12),
                          decoration: BoxDecoration(
                              //border: Border.all(color: Color.transparent),
                              borderRadius: BorderRadius.circular(10),
                              color: selectedIndex == 0
                                  ? Colors.white
                                  : Colors.grey[200],
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    spreadRadius: 1,
                                    blurRadius: 15)
                              ]),
                          child: const Text("Crear Usuario"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Material(
                        elevation: selectedIndex == 1 ? 10 : 0,
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 7, bottom: 7, left: 12, right: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedIndex == 1
                                  ? Colors.white
                                  : Colors.grey[200],
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    spreadRadius: 1,
                                    blurRadius: 15)
                              ]),
                          child: const Text("Iniciar Sesion"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Forms Container
            Expanded(
              child: IndexedStack(
                index: selectedIndex,
                children: const [
                  // Formulario de Registro
                  RegisterForm(),
                  // Formulario de Inicio de Sesión
                  LoginForm(),
                ],
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(top: 15),
              child: TextButton(
                onPressed: (){
                  debugPrint("hello world!");
                },
                child: const Text("Necesitas ayuda?",
                    style:  TextStyle(
                        color: AppColors.primaryColor,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: AppColors.secondaryColor,
        hoverColor: AppColors.primaryColor,
        child: const Icon(Icons.arrow_back_rounded),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Usuario", style: TextStyle(fontSize: 16)),
        const TextField(
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Ingresa tu usuario',
          ),
        ),
        const SizedBox(height: 20),
        const Text("Contraseña", style: TextStyle(fontSize: 16)),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Ingresa tu contraseña',
            suffixIcon: Icon(Icons.visibility),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: AppColors.primaryColor,
                ),
                onPressed: () {
                  // Acción de iniciar sesión
                },
                child: const Text(
                  "Iniciar sesión",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(0),
                  backgroundColor: AppColors.primaryColor),
              onPressed: () {
                // Configuración
              },
              child: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text("Olvidaste la Clave?",
                style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.grey,
                    fontSize: 16,
                    fontStyle: FontStyle.italic)),
          ),
        ),
      ],
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Nombre", style: TextStyle(fontSize: 16)),
        const TextField(
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Ingresa tu nombre',
          ),
        ),
        const SizedBox(height: 20),
        const Text("Email", style: TextStyle(fontSize: 16)),
        const TextField(
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Ingresa tu email',
          ),
        ),
        const SizedBox(height: 20),
        const Text("Contraseña", style: TextStyle(fontSize: 16)),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Crea una contraseña',
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
          ),
          onPressed: () {
            // Acción de crear cuenta
          },
          child: const Text("Crear Usuario"),
        ),
      ],
    );
  }
}
