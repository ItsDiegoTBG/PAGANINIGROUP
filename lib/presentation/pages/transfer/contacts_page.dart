import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/providers/contact_provider.dart';
import 'package:paganini/presentation/widgets/app_bar_content.dart';
import 'package:paganini/presentation/widgets/contact_user.dart';
import 'package:provider/provider.dart';

import 'package:paganini/data/models/contact_model.dart';
import 'package:paganini/domain/usecases/fetch_contacts_use_case.dart';
import 'package:paganini/domain/usecases/save_contact_use_case.dart';

import 'package:paganini/presentation/widgets/add_contact_dialog.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  TextEditingController textEditingController = TextEditingController();
  late FetchContactsUseCase fetchContacts;
  late SaveContactUseCase saveContact;
  List<Contact> contactsList = [];



@override
  void initState() {
    super.initState();
    fetchContacts = context.read<FetchContactsUseCase>();
    saveContact = context.read<SaveContactUseCase>();
    loadContacts();
  }

  Future<void> loadContacts() async {
    contactsList = await fetchContacts();
    setState(() {});
  }

  Future<void> addContact() async {
    final newContact = await showDialog<Contact>(
      context: context,
      builder: (_) => AddContactDialog(),
    );
    if (newContact != null) {
      await saveContact(newContact);
      await loadContacts();
    }
  }

  @override
Widget build(BuildContext context) {
  double myHeight = MediaQuery.of(context).size.height;
  double myWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: const Text("Contactos"),
      backgroundColor: Colors.white,
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
                      style: TextStyle(
                          fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: IconButton.filled(
                iconSize: 15,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue,
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
            controller: textEditingController,
            decoration: const InputDecoration(
              suffixIcon: Icon(
                Icons.search_off_rounded,
                size: 20,
                color: Colors.blue,
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
                onPressed: addContact, // Llama al método para agregar contactos
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue,
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
          child: contactsList.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: contactsList.length,
                        (context, index) {
                          final contact = contactsList[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: myWidth * 0.08,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // Acción al seleccionar un contacto
                              },
                              child: ContactUserWidget(
                                nameUser: contact.name,
                                phoneUser: contact.phone,
                                numberAccount: "account",
                                width: myWidth * 0.85,
                                height: myHeight * 0.10,
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
  );
}

}
