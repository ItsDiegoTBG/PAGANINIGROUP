import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/domain/entity/user_entity.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/buttons/button_without_icon.dart';
import 'package:paganini/presentation/widgets/text_form_field_widget.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cedController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${user.uid}');
        final snapshot = await userRef.get();
        if (snapshot.exists) {
          Map userData = snapshot.value as Map;
          firstNameController.text = userData['firstname'] ?? '';
          lastNameController.text = userData['lastname'] ?? '';
          cedController.text = userData['ced'] ?? '';
          emailController.text = userData['email'] ?? '';
          phoneController.text = userData['phone'] ?? '';
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar datos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${user.uid}');
        await userRef.update({
          'firstname': firstNameController.text.trim(),
          'lastname': lastNameController.text.trim(),
          'ced': cedController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Perfil actualizado con éxito'),
            backgroundColor: AppColors.greenColors,
          ),
        );
        Provider.of<UserProvider>(context, listen: false)
          .setUserData();
          setState(() {
        });
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final UserEntity userEntity = userProvider.currentUser!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const ContentAppBar(),
      ),
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nombres", style: TextStyle(fontSize: 16)),
                    TextFormFieldWidget(
                      textInputType: TextInputType.text,
                      controller: firstNameController,
                      hintText: 'Ingresa tu nombre',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text("Apellidos", style: TextStyle(fontSize: 16)),
                    TextFormFieldWidget(
                      textInputType: TextInputType.text,
                      controller: lastNameController,
                      hintText: 'Ingresa tu apellido',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu apellido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text("Cédula", style: TextStyle(fontSize: 16)),
                    TextFormFieldWidget(
                      textInputType: TextInputType.text,
                      controller: cedController,
                      hintText: 'Ingresa tu cédula',
                      validator: (value) {
                        if (value == null || value.isEmpty || !RegExp(r'^\d+$').hasMatch(value)) {
                          return 'Por favor ingresa tu cédula';
                        } else if (value.length != 10) {
                          return 'Debe tener 10 dígitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text("Email", style: TextStyle(fontSize: 16)),
                    TextFormFieldWidget(
                      textInputType: TextInputType.emailAddress,
                      controller: emailController,
                      hintText: 'Ingresa tu email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Ingresa un email válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text("Teléfono", style: TextStyle(fontSize: 16)),
                    TextFormFieldWidget(
                      textInputType: TextInputType.number,
                      controller: phoneController,
                      hintText: 'Ingresa tu número de teléfono',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un número de teléfono';
                        } else if (value.length != 10) {
                          return 'Debe tener 10 dígitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ButtonWithoutIcon(
                            text: "Actualizar Datos",
                            onPressed: _updateUserData,  
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                  strokeWidth: 5,
                ),
              ),
            ),
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
    phoneController.dispose();
    super.dispose();
  }
}
