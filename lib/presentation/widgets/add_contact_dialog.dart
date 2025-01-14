import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import '../../data/models/contact_model.dart';

class AddContactDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  AddContactDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
    
      title: const Text("Agregar Contacto"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Nombre"),
          ),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: "Teléfono"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            
          ),
          onPressed: () {
            final name = nameController.text.trim();
            final phone = phoneController.text.trim();
            
            if (name.isNotEmpty && phone.isNotEmpty) {
              Navigator.pop(context, ContactUser(name: name, phone: phone,isRegistered: true));
            }
          },
          child: const Text("Guardar",style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}
