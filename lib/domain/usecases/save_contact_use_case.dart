import '../../data/local/hive_service.dart';
import '../../data/models/contact_model.dart';

class SaveContactUseCase {
  final HiveService hiveService;

  SaveContactUseCase(this.hiveService);

  Future<void> call(Contact contact) {
    return hiveService.saveContact(contact);
  }
}
