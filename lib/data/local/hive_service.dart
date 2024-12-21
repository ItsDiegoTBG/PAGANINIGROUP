import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive/hive.dart';
import 'package:paganini/data/models/contact_model.dart'; // Asegúrate de importar correctamente tu modelo

class HiveService {
  static const String contactsBoxName = 'contactsBox';

  Future<void> init() async {
    Hive.registerAdapter(
        ContactUserAdapter()); // Registra el adaptador correctamente
    await Hive.openBox<ContactUser>(
        contactsBoxName); // Usa ContactUser, no Contact
  }

  Future<List<ContactUser>> getContacts() async {
    final box =
        Hive.box<ContactUser>(contactsBoxName); // Usa ContactUser, no Contact
    return box.values.toList();
  }

  Future<void> saveContact(ContactUser contact) async {
    final box =
        Hive.box<ContactUser>(contactsBoxName); // Usa ContactUser, no Contact
    await box.add(contact);
  }

  Future<void> deleteContact(int index) async {
    final box =
        Hive.box<ContactUser>(contactsBoxName); // Usa ContactUser, no Contact
    await box.deleteAt(index);
  }
}
