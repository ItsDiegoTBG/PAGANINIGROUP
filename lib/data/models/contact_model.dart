import 'package:hive/hive.dart';

part 'contact_model.g.dart';

@HiveType(typeId: 0)
class ContactUser {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phone;

  ContactUser({required this.name, required this.phone});
}
