import '../../data/local/hive_service.dart';
import '../../data/models/contact_model.dart';

class FetchContactsUseCase {
  final HiveService hiveService;

  FetchContactsUseCase(this.hiveService);

  Future<List<Contact>> call() {
    return hiveService.getContacts();
  }
}
