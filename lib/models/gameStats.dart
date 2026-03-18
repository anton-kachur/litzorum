import 'package:hive/hive.dart';

part 'gameStats.g.dart';

@HiveType(typeId: 3)
class GameStats extends HiveObject {
  @HiveField(0)
  late Map<String, String> stats;

  GameStats({required this.stats});

  @override
  String toString() {
    return "Game stats: $stats";    
  }
}