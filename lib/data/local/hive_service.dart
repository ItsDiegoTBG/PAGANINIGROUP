import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive/hive.dart';
import 'package:paganini/data/models/contact_model.dart';

class HiveService {
  static const String contactsBoxName = 'contactsBox';

  Future<void> init() async {
    Hive.registerAdapter(ContactUserAdapter()); // Registra el adaptador
    await Hive.openBox<ContactUser>(contactsBoxName);
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
    for (var c in allContacts) {
      await box.add(c); // Vuelve a añadir todos los contactos
    }
  }
}
