import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/domain/usecases/contact_use_case.dart';
import 'package:paganini/presentation/providers/contact_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/contact_user.dart';
import 'package:paganini/presentation/widgets/edit_contact_dialog.dart';
import 'package:paganini/presentation/widgets/floating_button_paganini.dart';
import 'package:provider/provider.dart';

import 'package:paganini/data/models/contact_model.dart';

import 'package:paganini/presentation/widgets/add_contact_dialog.dart';
import 'package:share_plus/share_plus.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  TextEditingController textEditingController = TextEditingController();
  late ContactUseCase contactUseCase;

  List<ContactUser> contactsList = [];
  List<ContactUser> filteredContacts = []; // Lista para almacenar los contactos filtrados.

  bool contactsImported = false;

  

  @override
  void initState() {
    super.initState();

    contactUseCase = context.read<ContactUseCase>();
    loadContacts();
  }

  @override
  void dispose() {
    super.dispose();

  }

  Future<void> loadContacts() async {
    contactsList = await contactUseCase.callFetch();
    filteredContacts =  contactsList;
    setState(() {});
  }

  Future<void> deleteContactIndex(int index) async {
    await contactUseCase.callDelete(index);
    await loadContacts();
  }

  Future<void> addContact() async {
    final newContact = await showDialog<ContactUser>(
      context: context,
      builder: (_) => AddContactDialog(),
    );
    if (newContact != null) {
      await contactUseCase.callSaveToFirst(newContact);
      await loadContacts();
    }
  }

  Future<void> editContact(int index, ContactUser contact) async {
    final updatedContact = await showDialog<ContactUser>(
      context: context,
      builder: (_) => EditContactDialog(contact: contact),
    );
    if (updatedContact != null) {
      await contactUseCase.callUpdateName(index, updatedContact.name);
      await loadContacts(); // Refresca la lista después de actualizar
    }
  }

Future<void> contactsFetch() async {
  final userProvider = context.read<UserProvider>();
  final userEntity = userProvider.currentUser;
  userProvider.setUserImportedContacts();
  if (await FlutterContacts.requestPermission()) {
    // Obtén los contactos del dispositivo
    var contacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
    );

    // Convierte los contactos obtenidos en una lista de ContactUserf
     var decodedContacts = contacts.where((contact) {
      return contact.phones.isNotEmpty &&
          _formatPhoneNumber(contact.phones[0].number) != _formatPhoneNumber(userEntity!.phone);
    }).map((contact) {
      return ContactUser(
        name: contact.displayName,
        phone: _formatPhoneNumber(contact.phones[0].number),
        isRegistered: false,
      );
    }).toList();

    // Verificar los contactos en Firebase de manera paralela
    List<Future<void>> registrationChecks = [];
    for (var contact in decodedContacts) {
      if (contact.phone.isNotEmpty) {
        registrationChecks.add(checkIfContactRegistered(contact.phone).then((isRegistered) {
          contact.isRegistered = isRegistered; // Actualiza el estado de registro
        }));
      }
    }

    // Espera a que todas las verificaciones se completen
    await Future.wait(registrationChecks);

    // Ordenar los contactos: los registrados deben aparecer primero
    decodedContacts.sort((a, b) => b.isRegistered ? 1 : 0 - (a.isRegistered ? 1 : 0));

    // Actualiza la lista de contactos y el estado
    if (mounted) {
      setState(() {
        contactsImported = true;
        contactsList = decodedContacts;
      });
    }

    // Guarda los contactos en Hive
    for (var contact in decodedContacts) {
      await contactUseCase.callSave(contact);
    }

    debugPrint("Cantidad de contactos importados: ${contactsList.length}");
  } else {
    debugPrint("Permiso para acceder a los contactos denegado.");
  }
}



Future<bool> checkIfContactRegistered(String phoneNumber) async {
  try {
    final databaseReference = FirebaseDatabase.instance.ref();
    final snapshot = await databaseReference
        .child("users") // Ruta donde están almacenados los usuarios
        .orderByChild("phone")
        .equalTo(phoneNumber)
        .get();

    // Verifica si existe un usuario con ese número de teléfono
    return snapshot.exists && snapshot.value != null;
  } catch (e) {
    debugPrint("Error verificando el número de teléfono: $e");
    return false;
  }
}

String _formatPhoneNumber(String phoneNumber) {
  // Elimina cualquier carácter no numérico
  String cleanedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

  // Verifica si el número comienza con "593" (código de Ecuador) y lo elimina
  if (cleanedNumber.startsWith('593')) {
    return '0${cleanedNumber.substring(3)}'; // Remueve '593' y añade '0' al inicio
  }
  
  return cleanedNumber; // Devuelve el número limpio sin modificaciones
}

void filterContacts(String query) {
  if (query.isEmpty) {
    setState(() {
      filteredContacts = List.from(contactsList); // Mostrar todos los contactos si no hay búsqueda.
    });
  } else {
    setState(() {
      filteredContacts = contactsList.where((contact) {
        return contact.phone.contains(query); // Filtrar por número de teléfono.
      }).toList();
    });
  }
}



  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    final contactProviderRead = context.read<ContactProvider>();
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const ContentAppBar(),
        
      ),
      body: Column(
        children: [
          // Cabecera
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: myWidth * 0.08, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Contactos",
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontSize: 24),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Busque y seleccione un contacto",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: IconButton.filled(
                  iconSize: 15,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: myHeight * 0.04),

          // Campo de búsqueda
          Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: myWidth * 0.08,
              right: myWidth * 0.08,
            ),
            child: TextField(
              onChanged: filterContacts,
              controller: textEditingController,
              decoration: const InputDecoration(
                suffixIcon: Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: AppColors.primaryColor,
                ),
                hintText: "Buscar",
                hintStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),

          // Título y botón agregar
          Padding(
            padding: EdgeInsets.only(top: myWidth * 0.08),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Tus contactos",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(width: 20),
                IconButton.filled(
                  onPressed:
                      addContact, // Llama al método para agregar contactos
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Lista de contactos
          Expanded(
            child: filteredContacts.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text:
                                  "No tienes aún ningun contacto,                                         ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16), // Color predeterminado
                            ),
                            TextSpan(
                              text: "Agregar un contacto",
                              style: const TextStyle(
                                  color: AppColors
                                      .primaryColor, // Color personalizado para "Agregar"
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Acción cuando se pulsa sobre "Agregar"
                                  addContact();
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: filteredContacts.length,
                          (context, index) {
                            final contact = filteredContacts[index];
                            debugPrint("Los contactos registrado es: ${contact.name} con el número: ${contact.phone} y si esta registrado: ${contact.isRegistered}");
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: myWidth * 0.08,
                              ),
                              child: Slidable(
                                startActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) async {
                                          await shareContact(
                                              contact.name, contact.phone);
                                        },
                                        borderRadius: BorderRadius.circular(10),
                                        backgroundColor: Colors.green[400]!,
                                        foregroundColor: Colors.white,
                                        icon: Icons.share_rounded,
                                        label: 'Share',
                                      ),
                                      SlidableAction(
                                        onPressed: (context) async {
                                          await editContact(index, contact);
                                        },
                                        borderRadius: BorderRadius.circular(10),
                                        backgroundColor: Colors.blue[400]!,
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit_rounded,
                                        label: 'Editar',
                                      ),
                                    ]),
                                endActionPane: ActionPane(
                                    motion: const BehindMotion(),
                                    children: [
                                      SlidableAction(
                                        borderRadius: BorderRadius.circular(10),
                                        onPressed: (context) async {
                                          debugPrint(
                                              "Eliminar contacto agregado");
                                          await deleteContactIndex(index);
                                        },
                                        backgroundColor: Colors.red[400]!,
                                        icon: Icons.delete_rounded,
                                        label: 'Delete',
                                      )
                                    ]),
                                child: GestureDetector(
                                  onTap: () async {
                                    final contact = ContactUserWidget(
                                      nameUser: contactsList[index].name,
                                      phoneUser: contactsList[index].phone,
                                      width: myWidth * 0.85,
                                      height: myHeight * 0.10,
                                    );
                                    Navigator.pop(context);
                                    await contactProviderRead
                                        .setContactTransfered(contact);
                                  },
                                  child: ContactUserWidget(
                                    nameUser: contact.name,
                                    phoneUser: contact.phone,
                                    isRegistered:  contact.isRegistered,
                                    width: myWidth * 0.85,
                                    height: myHeight * 0.10,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: userProvider.isImportedContacts
          ? null  // Si los contactos han sido importados, no mostrar el FloatingActionButton
          : FloatingButtonPaganini(
              onPressed: () {
                debugPrint("Importar valores de los contactos del teléfono");
                contactsFetch(); // Llama a la función para importar los contactos
              },
              iconData : Icons.import_contacts)
    );
  }
}

Future<void> shareContact(String contactName, String phoneNumber) async {
  // Crear el texto con los detalles del contacto
  final contactDetails =
      'Contacto:\nNombre: $contactName\nTeléfono: $phoneNumber';
  // Usar el paquete share_plus para compartir el texto
  await Share.share(contactDetails, subject: 'Detalles del Contacto');
}
