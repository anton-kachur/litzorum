import 'package:hive/hive.dart';

part 'armySettings.g.dart';

@HiveType(typeId: 5)
class ArmySettings extends HiveObject {
  @HiveField(0)
  late String gameId;

  @HiveField(1)
  late String countryName;

  @HiveField(2)
  late bool isConquired;

  @HiveField(3)
  late double armyAmount;

  @HiveField(4)
  late double airDefenceAmount;

  @HiveField(5)
  late double frontlineAmount;

  @HiveField(6)
  late double backAmount;

  @HiveField(7)
  late double attackLevel;

  @HiveField(8)
  late double defenceLevel;

  @HiveField(9)
  late double relations;
  
  @HiveField(10)
  late bool isInUnion;

  @HiveField(11)
  late double tradeMoneyAmount;

  ArmySettings({
    required this.gameId, required this.countryName, required this.isConquired, 
    required this.armyAmount, required this.airDefenceAmount, 
    required this.frontlineAmount, required this.backAmount, 
    required this.attackLevel, required this.defenceLevel, required this.relations, 
    required this.isInUnion, required this.tradeMoneyAmount
  });

  @override
  String toString() {
    return "$countryName\nArmed forces:\nTotal military: $armyAmount\n" + 
    "Air defence: $airDefenceAmount\nSoldiers: $frontlineAmount\n" + 
    "Back: $backAmount";    
  }
}