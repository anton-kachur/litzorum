import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 2)
class Settings extends HiveObject {
  @HiveField(0)
  late Map<String, String> settings;

  Settings({required this.settings});

  @override
  String toString() {
    return "Game settings: $settings";    
  }
}