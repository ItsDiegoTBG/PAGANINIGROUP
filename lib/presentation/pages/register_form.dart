import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paganini/presentation/widgets/buttons/button_without_icon.dart';
import 'package:paganini/presentation/widgets/textfile_form.dart';
import 'package:paganini/core/utils/colors.dart';



class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});
  @override
  RegisterFormState createState() => RegisterFormState();

}
  
class RegisterFormState extends State<RegisterForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  
  Future<void> registerUser() async{
    if (_formKey.currentState!.validate()) {
      try {
        // Crear el usuario en Firebase Authentication
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Obtener el UID del usuario creado
        String uid = userCredential.user!.uid;

        // Guardar el nombre y otros datos en Firestore
        await _firestore.collection('users').doc(uid).set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          // Puedes añadir más campos si lo necesitas
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario registrado con éxito')),
        );

        // Navegar de regreso a la pantalla de inicio de sesión
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('La contraseña proporcionada es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        print('La cuenta ya existe para ese correo electrónico.');
      }
    } 
     catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: $e')),
        );
      }
    }
  }
 
    

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      key: _formKey,
      children: [
        const Text("Nombre", style: TextStyle(fontSize: 16)),
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
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)){
                    return 'Ingresa un email válido';
                  }
                  return null;
                },
        ),
        const SizedBox(height: 20),
        const Text("Contraseña", style: TextStyle(fontSize: 16)),
        TextFormField(
          obscureText: true,
          controller: passwordController,
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Crea una contraseña',
              suffixIcon: Icon(Icons.visibility)), 
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una contraseña';
                  }
                  return null;}
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
                child:
                    ButtonWithoutIcon(text: "Crear Usuario", onPressed: () {})),
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
        )
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}