import '../../data/local/hive_service.dart';
import '../../data/models/contact_model.dart';

class FetchContactsUseCase {
  final HiveService hiveService;

  FetchContactsUseCase(this.hiveService);

  Future<List<ContactUser>> call() {
    return hiveService.getContacts();
  }
}
