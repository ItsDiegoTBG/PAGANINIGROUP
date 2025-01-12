import 'package:paganini/data/local/hive_service.dart';
import 'package:paganini/data/models/contact_model.dart';

class ContactUseCase {
  final HiveService hiveService;

  ContactUseCase(this.hiveService);

  Future<void> callDelete(int index) {
    return hiveService.deleteContact(index); 
  }

  Future<List<ContactUser>> callFetch() {
    return hiveService.getContacts();
  }

  Future<void> callSave(ContactUser contact) {
    return hiveService.saveContact(contact);
  }

  Future<void> callUpdateName(int index, String newName) {
    return hiveService.updateContactName(index, newName);
  }

  Future<void> callSaveToFirst(ContactUser contact) {
    return hiveService.saveContactToFirst(contact);
  }
}
