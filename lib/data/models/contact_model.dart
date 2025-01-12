import 'package:hive/hive.dart';
part 'contact_model.g.dart'; // Asegúrate de que esta línea apunta al archivo generado
@HiveType(typeId: 0) // Asegúrate de registrar un ID único para esta clase en Hive
class ContactUser {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phone;

  @HiveField(2) // Nuevo atributo registrado en Hive
  bool isRegistered;

  ContactUser({
    required this.name,
    required this.phone,
    this.isRegistered = false, // Valor predeterminado: no registrado
  });
}
