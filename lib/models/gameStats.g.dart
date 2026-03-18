// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gameStats.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameStatsAdapter extends TypeAdapter<GameStats> {
  @override
  final int typeId = 3;

  @override
  GameStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameStats(
      stats: (fields[0] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, GameStats obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.stats);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
