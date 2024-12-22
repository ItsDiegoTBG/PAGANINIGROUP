import 'package:flutter/material.dart';
import 'package:paganini/data/models/contact_model.dart';

class EditContactDialog extends StatelessWidget {
  final ContactUser contact;

  const EditContactDialog({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: contact.name);

    return AlertDialog(
      title: const Text('Editar Contacto'),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(labelText: 'Nombre'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final updatedContact = ContactUser(
              name: nameController.text,
              phone: contact.phone, // El teléfono permanece igual
            );
            Navigator.pop(context, updatedContact);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
