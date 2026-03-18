import 'package:hive/hive.dart';

part 'ideology.g.dart';

@HiveType(typeId: 0)
class Ideology extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late Map<String, double> bonuses;

  @HiveField(2)
  late bool isChosen;
  
  Ideology({required this.name, required this.bonuses, required this.isChosen});

  @override
  String toString() {
    return "Ideology: $name\n$bonuses\nis chosen: $isChosen";    
  }
}