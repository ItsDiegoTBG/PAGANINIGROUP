import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/domain/usecases/contact_use_case.dart';
import 'package:paganini/helpers/show_animated_snackbar.dart';
import 'package:paganini/presentation/providers/contact_provider.dart';
import 'package:provider/provider.dart';
import '../../data/models/contact_model.dart';


class AddContactDialog extends StatefulWidget {
  const AddContactDialog({super.key});

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  late ContactUseCase contactUseCase;
  List<ContactUser> contactsList = [];

  @override
  void initState() {
    super.initState();
    contactUseCase = context.read<ContactUseCase>();
    _loadContacts(); // Llamada al método separado
  }

  Future<void> _loadContacts() async {
    final fetchedContacts = await contactUseCase.callFetch();
    setState(() {
      contactsList = fetchedContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider = context.watch<ContactProvider>();
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
            keyboardType: TextInputType.number,
            maxLength: 10,
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
          onPressed: () async {
            final name = nameController.text.trim();
            final phone = phoneController.text.trim();

            if (phone.length != 10) {
              ShowAnimatedSnackBar.show(
                context,
                "Debes ingresar un número de teléfono válido",
                Icons.info,
                AppColors.blueColors,
              );
              return;
            }

            // Validar que el usuario no exista en contactos
            if (contactsList.any((contact) => contact.phone == phone)) {
              ShowAnimatedSnackBar.show(
                context,
                "El usuario ya existe en tus contactos",
                Icons.info,
                AppColors.blueColors,
              );
              return;
            }

            bool exits = await contactProvider.contactUserNotExist(phone);

            if(exits==false) {
              ShowAnimatedSnackBar.show(
                context,
                "El usuaro no tiene cuenta en Paganini",
                Icons.info,
                AppColors.blueColors,
              );
              return;
            }

            if (name.isNotEmpty && phone.isNotEmpty) {
              Navigator.pop(
                context,
                ContactUser(name: name, phone: phone, isRegistered: true),
              );
            }
          },
          child: const Text("Guardar",style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}
