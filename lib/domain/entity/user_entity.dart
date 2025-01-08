class UserEntity {
  final String id;
  final String firstname;
  final String lastname;
  final String ced;
  final String email;
  final String phone;
  final double saldo;


  UserEntity({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.ced,
    required this.email,
    required this.phone,
    required this.saldo,

  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'ced': ced,
      'email': email,
      'phone': phone,
      'saldo': saldo,

    };
  }


  factory UserEntity.fromMapEntity(String id, Map<String, dynamic> map) {
    return UserEntity(
      id: id,
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      ced: map['ced'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      saldo: map['saldo']?.toDouble() ?? 0.0,
    );
  }
}
