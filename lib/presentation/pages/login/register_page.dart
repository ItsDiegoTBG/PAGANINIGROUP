import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool _isPasswordVisible = false;
  Future<void> registerUser() async {
    setState(() {
      _isLoading = true;
    });
    debugPrint("Vamos a registerUser");

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      String uid = userCredential.user!.uid;

      // Obtener la referencia a la base de datos en tiempo real
      DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$uid');

      // Guardar los datos del usuario en Realtime Database
      await userRef.set({
        'firstname': firstNameController.text.trim(),
        'lastname': lastNameController.text.trim(),
        'ced': cedController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'saldo': 0.0,
        'cards': [],
        // Puedes añadir más campos si lo necesitas
      });

      await clearFields();

      // Mostrar mensaje de éxito
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Registro exitoso'),
          backgroundColor: Colors.green,
        ),
      );
      await Future.delayed(const Duration(seconds: 1));

      // ignore: use_build_context_synchronously
      await Navigator.pushNamed(context, Routes.LOGIN);
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
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
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

  Future<void> clearFields() async {
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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 16, left: 16, bottom: 16, top: 0),
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
                  form(context)
                ],
              ),
            ),
          ),
          if (_isLoading) // Mostrar CircularProgressIndicator cuando está cargando
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                  strokeWidth: 5,
                  semanticsLabel: "Espera un segundo",
                ),
              ),
            ),
        ],
      ),
    );
  }

  Form form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Nombres", style: TextStyle(fontSize: 16)),
          TextFormFieldWidget(
              textInputType: TextInputType.text,
              controller: firstNameController,
              hintText: 'Ingresa su nombre',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu nombre';
                }
                return null;
              }),
          const SizedBox(height: 10),
          const Text("Apellidos", style: TextStyle(fontSize: 16)),
          TextFormFieldWidget(
              textInputType: TextInputType.text,
              controller: lastNameController,
              hintText: 'Ingresa su apellido',
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
              hintText: 'Ingresa su cedula',
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !RegExp(r'^\d+$').hasMatch(value)) {
                  return 'Por favor ingresa tu cedula';
                } else if (value.length != 10) {
                  return 'Deben ser 10 digitos';
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
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
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
              } else if (value.length < 10) {
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
              suffixIcon: IconButton(
                icon: _isPasswordVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20), // Borde circular
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20), // Borde circular
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              hintText: 'Ingresa tu contraseña',
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18, // Tamaño de texto del hint
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16, // Espaciado vertical
                horizontal: 20, // Espaciado horizontal
              ),
            ),
            style: const TextStyle(
              fontSize: 18, // Tamaño del texto ingresado
              height: 1.5, // Espaciado entre líneas
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa una contraseña';
              }
              if (value.length < 12) {
                return 'La contraseña debe tener al menos 12 caracteres';
              }
              if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                return 'Incluya al menos una letra mayúscula';
              }
              if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                return 'Incluya al menos un dígito';
              }
              if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
                return 'Incluya al menos un carácter especial (@, \$, !, %, *, ?, &)';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: ButtonWithoutIcon(
                      text: "Crear Usuario",
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          await registerUser();
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
    );
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
