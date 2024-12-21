import 'package:flutter/material.dart';
import '../../data/models/contact_model.dart';

class AddContactDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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
          onPressed: () {
            final name = nameController.text.trim();
            final phone = phoneController.text.trim();
            if (name.isNotEmpty && phone.isNotEmpty) {
              Navigator.pop(context, ContactUser(name: name, phone: phone));
            }
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
