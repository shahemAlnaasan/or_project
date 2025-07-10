// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class LoginParamsAdapter extends TypeAdapter<LoginParams> {
  @override
  final typeId = 0;

  @override
  LoginParams read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginParams(
      username: fields[0] as String,
      password: fields[1] as String,
      ipInfo: fields[2] as String,
      deviceInfo: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LoginParams obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.ipInfo)
      ..writeByte(3)
      ..write(obj.deviceInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginParamsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LoginResponseModelAdapter extends TypeAdapter<LoginResponseModel> {
  @override
  final typeId = 1;

  @override
  LoginResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginResponseModel(
      status: fields[0] as String,
      id: fields[1] as String,
      message: fields[2] as String,
      systemActive: fields[3] as String?,
      trust: fields[4] as String?,
      authkey: fields[7] as String?,
      name: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LoginResponseModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.systemActive)
      ..writeByte(4)
      ..write(obj.trust)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.authkey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
