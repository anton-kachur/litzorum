// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameAdapter extends TypeAdapter<Game> {
  @override
  final int typeId = 1;

  @override
  Game read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Game(
      gameId: fields[0] as String,
      gameStartDate: fields[1] as String,
      playerName: fields[2] as String,
      reigningYears: fields[3] as double,
      ideology: fields[4] as String,
      leadersPopularity: fields[5] as double,
      population: fields[6] as int,
      budget: fields[7] as double,
      goods: fields[8] as double,
      exchangeRate: fields[9] as String,
      educationLevel: fields[10] as double,
      purchasingPower: fields[11] as double,
      lifeQuality: fields[12] as double,
      heavyIndustryFactoriesNumber: fields[13] as int,
      heavyIndustryGoodsOutput: fields[14] as double,
      lightIndustryFactoriesNumber: fields[15] as int,
      lightIndustryGoodsOutput: fields[16] as double,
      agricultureFarmsNumber: fields[17] as int,
      agricultureFarmsGoodsOutput: fields[18] as double,
      schoolsNumber: fields[19] as int,
      universitiesNumber: fields[20] as int,
      researchCentersNumber: fields[21] as int,
      bigProjects: (fields[22] as List).cast<String>(),
      HQLevel: fields[23] as double,
      attackLevel: fields[24] as double,
      defenceLevel: fields[25] as double,
      cultureLevel: fields[26] as double,
      highCultureLevel: fields[27] as double,
      massCultureLevel: fields[28] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Game obj) {
    writer
      ..writeByte(29)
      ..writeByte(0)
      ..write(obj.gameId)
      ..writeByte(1)
      ..write(obj.gameStartDate)
      ..writeByte(2)
      ..write(obj.playerName)
      ..writeByte(3)
      ..write(obj.reigningYears)
      ..writeByte(4)
      ..write(obj.ideology)
      ..writeByte(5)
      ..write(obj.leadersPopularity)
      ..writeByte(6)
      ..write(obj.population)
      ..writeByte(7)
      ..write(obj.budget)
      ..writeByte(8)
      ..write(obj.goods)
      ..writeByte(9)
      ..write(obj.exchangeRate)
      ..writeByte(10)
      ..write(obj.educationLevel)
      ..writeByte(11)
      ..write(obj.purchasingPower)
      ..writeByte(12)
      ..write(obj.lifeQuality)
      ..writeByte(13)
      ..write(obj.heavyIndustryFactoriesNumber)
      ..writeByte(14)
      ..write(obj.heavyIndustryGoodsOutput)
      ..writeByte(15)
      ..write(obj.lightIndustryFactoriesNumber)
      ..writeByte(16)
      ..write(obj.lightIndustryGoodsOutput)
      ..writeByte(17)
      ..write(obj.agricultureFarmsNumber)
      ..writeByte(18)
      ..write(obj.agricultureFarmsGoodsOutput)
      ..writeByte(19)
      ..write(obj.schoolsNumber)
      ..writeByte(20)
      ..write(obj.universitiesNumber)
      ..writeByte(21)
      ..write(obj.researchCentersNumber)
      ..writeByte(22)
      ..write(obj.bigProjects)
      ..writeByte(23)
      ..write(obj.HQLevel)
      ..writeByte(24)
      ..write(obj.attackLevel)
      ..writeByte(25)
      ..write(obj.defenceLevel)
      ..writeByte(26)
      ..write(obj.cultureLevel)
      ..writeByte(27)
      ..write(obj.highCultureLevel)
      ..writeByte(28)
      ..write(obj.massCultureLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
