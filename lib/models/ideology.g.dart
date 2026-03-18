// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ideology.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IdeologyAdapter extends TypeAdapter<Ideology> {
  @override
  final int typeId = 0;

  @override
  Ideology read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ideology(
      name: fields[0] as String,
      bonuses: (fields[1] as Map).cast<String, double>(),
      isChosen: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Ideology obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.bonuses)
      ..writeByte(2)
      ..write(obj.isChosen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdeologyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
