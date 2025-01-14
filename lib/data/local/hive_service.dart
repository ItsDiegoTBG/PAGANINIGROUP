import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive/hive.dart';
import 'package:paganini/data/models/contact_model.dart';

class HiveService {
  static const String contactsBoxName = 'contactsBox';

    Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) { // Reemplaza "0" con el ID de tu adaptador
      Hive.registerAdapter(ContactUserAdapter()); // Registra el adaptador solo si no está registrado
    }
    if (!Hive.isBoxOpen(contactsBoxName)) {
      await Hive.openBox<ContactUser>(contactsBoxName); // Abre la caja solo si no está abierta
    }
  }

  Future<List<ContactUser>> getContacts() async {
    final box = Hive.box<ContactUser>(contactsBoxName);
    return box.values.toList();
  }

  Future<void> saveContact(ContactUser contact) async {
    final box = Hive.box<ContactUser>(contactsBoxName);
    await box.add(contact);
  }

  Future<void> deleteContact(int index) async {
    final box = Hive.box<ContactUser>(contactsBoxName);
    await box.deleteAt(index);
  }

  Future<void> updateContactName(int index, String newName) async {
    final box = Hive.box<ContactUser>(contactsBoxName);
    final contact = box.getAt(index);

    if (contact != null) {
      final updatedContact = ContactUser(name: newName, phone: contact.phone);
      await box.putAt(index, updatedContact);
    }
  }

  Future<void> saveContactToFirst(ContactUser contact) async {
    final box = Hive.box<ContactUser>('contactsBox');
    final allContacts = box.values.toList();

    // Insertar al principio
    allContacts.insert(0, contact);

    // Guardar los contactos actualizados
    await box.clear(); // Elimina todos los contactos actuales
     await box.addAll(allContacts); 
  }
}
