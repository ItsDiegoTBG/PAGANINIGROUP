import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/widgets/buttons/button_without_icon.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;


  Future<void> registerUser() async {
    debugPrint("Vamos a registerUser");
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      String uid = userCredential.user!.uid;

      // Guardar el nombre y otros datos en Firestore
      await _firestore.collection('users').doc(uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text.trim(),
        'saldo': 0.0,
        // Puedes añadir más campos si lo necesitas
      });

      clearFields();

      // Mostrar mensaje de éxito
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro exitoso'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        wrongWeakPasswordMessage();
      } else if (e.code == 'email-already-in-use') {
        wrongEmailAlreadyInUse();
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void wrongWeakPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("La contraseña proporcionada es demasiado débil."),
          );
        });
  }

  void wrongEmailAlreadyInUse() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("La cuenta ya existe para ese correo electrónico."),
          );
        });
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding:
              const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 0),
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
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Usuario", style: TextStyle(fontSize: 16)),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text("Email", style: TextStyle(fontSize: 16)),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Ingresa un email válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text("Telefono", style: TextStyle(fontSize: 16)),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Telefono'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    const Text("Contraseña", style: TextStyle(fontSize: 16)),
                    TextFormField(
                        obscureText: !_isPasswordVisible,
                        controller: passwordController,
                        decoration:  InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: 'Crea una contraseña',
                            suffixIcon: IconButton(icon: const  Icon(Icons.visibility),onPressed: (){
                              setState(() {
                                 _isPasswordVisible = !_isPasswordVisible;
                              });
                            },)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una contraseña';
                          }
                          return null;
                        }),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                            child: ButtonWithoutIcon(
                                text: "Crear Usuario",
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    registerUser();
                                  }
                                })),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              padding: const EdgeInsets.all(0),
                              backgroundColor: AppColors.primaryColor),
                          onPressed: () {},
                          child: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
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
            Navigator.popAndPushNamed(context, Routes.LOGIN);
          },
          backgroundColor: AppColors.primaryColor,
          hoverColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          focusColor: AppColors.secondaryColor,
          child: const Icon(Icons.arrow_back_rounded),
        ));
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
