import 'package:paganini/data/local/hive_service.dart';

class DeleteContactUseCase {
  final HiveService hiveService;

  DeleteContactUseCase(this.hiveService);

  Future<void> call(int index) {
    return hiveService.deleteContact(index);  // Llama al método de HiveService
  }
}
