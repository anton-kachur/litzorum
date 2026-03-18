// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'armySettings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArmySettingsAdapter extends TypeAdapter<ArmySettings> {
  @override
  final int typeId = 5;

  @override
  ArmySettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArmySettings(
      gameId: fields[0] as String,
      countryName: fields[1] as String,
      isConquired: fields[2] as bool,
      armyAmount: fields[3] as double,
      airDefenceAmount: fields[4] as double,
      frontlineAmount: fields[5] as double,
      backAmount: fields[6] as double,
      attackLevel: fields[7] as double,
      defenceLevel: fields[8] as double,
      relations: fields[9] as double,
      isInUnion: fields[10] as bool,
      tradeMoneyAmount: fields[11] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ArmySettings obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.gameId)
      ..writeByte(1)
      ..write(obj.countryName)
      ..writeByte(2)
      ..write(obj.isConquired)
      ..writeByte(3)
      ..write(obj.armyAmount)
      ..writeByte(4)
      ..write(obj.airDefenceAmount)
      ..writeByte(5)
      ..write(obj.frontlineAmount)
      ..writeByte(6)
      ..write(obj.backAmount)
      ..writeByte(7)
      ..write(obj.attackLevel)
      ..writeByte(8)
      ..write(obj.defenceLevel)
      ..writeByte(9)
      ..write(obj.relations)
      ..writeByte(10)
      ..write(obj.isInUnion)
      ..writeByte(11)
      ..write(obj.tradeMoneyAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArmySettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
