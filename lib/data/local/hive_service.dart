import 'package:hive/hive.dart';
import '../models/contact_model.dart';

class HiveService {
  static const String contactsBoxName = 'contactsBox';

  Future<void> init() async {
    Hive.registerAdapter(ContactAdapter());
    await Hive.openBox<Contact>(contactsBoxName);
  }

  Future<List<Contact>> getContacts() async {
    final box = Hive.box<Contact>(contactsBoxName);
    return box.values.toList();
  }

  Future<void> saveContact(Contact contact) async {
    final box = Hive.box<Contact>(contactsBoxName);
    await box.add(contact);
  }
}
