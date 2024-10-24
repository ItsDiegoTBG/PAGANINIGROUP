import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/presentation/pages/login_forn.dart';
import 'package:paganini/presentation/pages/register_form.dart';
import 'package:paganini/core/utils/colors.dart';

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
      resizeToAvoidBottomInset: false,
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
                  fillColor: Colors.transparent,
                  
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
        //shape: RoundedRectangleBorder(
        //  borderRadius: BorderRadius.circular(50)
        //),
        onPressed: () {
          debugPrint("Pop to Initial Page Paganini");
          Navigator.popAndPushNamed(context, Routes.INITIAL);
        },
        backgroundColor: AppColors.primaryColor,
        hoverColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        focusColor: AppColors.secondaryColor,
        child: const Icon(Icons.arrow_back_rounded),
      ),
    );
  }
}

