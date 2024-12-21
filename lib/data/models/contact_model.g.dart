// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactUserAdapter extends TypeAdapter<ContactUser> {
  @override
  final int typeId = 0;

  @override
  ContactUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactUser(
      name: fields[0] as String,
      phone: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContactUser obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
