import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/widgets/buttons/button_without_icon.dart';
import 'package:paganini/presentation/widgets/text_form_field_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cedController = TextEditingController();
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
        'firstname': firstNameController.text.trim(),
        'lastname': lastNameController.text.trim(),
        'ced': cedController.text.trim(),
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
          duration: Duration(seconds: 1),
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
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    cedController.clear();
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
                    const Text("Nombre", style: TextStyle(fontSize: 16)),
                    TextFormFieldWidget(
                        textInputType: TextInputType.text,
                        controller: firstNameController,
                        hintText: 'Ingresa tu nombre',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu nombre';
                          }
                          return null;
                        }),
                    const SizedBox(height: 10),
                    const Text("Apellido", style: TextStyle(fontSize: 16)),
                    TextFormFieldWidget(
                        textInputType: TextInputType.text,
                        controller: lastNameController,
                        hintText: 'Ingresa tu apellido',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu apellido';
                          }
                          return null;
                        }),
                    const SizedBox(height: 10),
                    const Text("Cedula", style: TextStyle(fontSize: 16)),
                    TextFormFieldWidget(
                        textInputType: TextInputType.text,
                        controller: cedController,
                        hintText: 'Ingresa tu cedula',
                        validator: (value) {
                          if (value == null || value.isEmpty || value.length != 10 || !RegExp(r'^\d+$').hasMatch(value)) {
                            return 'Por favor ingresa tu cedula';
                          }
                          return null;
                        }),
                    const SizedBox(height: 10),
                    const Text("Email", style: TextStyle(fontSize: 16)),
                    TextFormFieldWidget(
                        textInputType: TextInputType.emailAddress,
                        controller: emailController,
                        hintText: 'Ingresa un correo electronico',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Ingresa un email válido';
                          }
                          return null;
                        }),
                    const SizedBox(height: 10),
                    const Text("Telefono", style: TextStyle(fontSize: 16)),
                    TextFormFieldWidget(
                      textInputType: TextInputType.number,
                      controller: phoneController,
                      hintText: 'Ingrese un numero de telefono',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un numero de telefono valido';
                        } else if (value.length > 10) {
                          return 'El número de teléfono no puede exceder los 10 dígitos';
                        } else if (value.length < 10 ){
                           return 'El número de teléfono no puede ser menor a los 10 digitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text("Contraseña", style: TextStyle(fontSize: 16)),
                    TextFormField(
                        obscureText: !_isPasswordVisible,
                        controller: passwordController,
                        decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.primaryColor, width: 2)),
                            border: const UnderlineInputBorder(),
                            hintText: 'Crea una contraseña',
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.w300),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una contraseña';
                          }
                          if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(value)){
                            return 'La contraseña debe tener al menos 8 caracteres, una mayúscula, un dígito y un carácter especial';
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
                                  FocusScope.of(context).unfocus();
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
    firstNameController.dispose();
    lastNameController.dispose();
    cedController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
