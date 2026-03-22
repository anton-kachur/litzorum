/// A centralized barrel file that exports commonly used libraries, 
/// models, and screens to simplify imports across the application.
library;

// 1. Flutter & Core Dart
export 'dart:io' show exit;
export 'dart:math' show Random;
export 'package:flutter/material.dart';

// 2. Third-party Packages
export 'package:audioplayers/audioplayers.dart';
export 'package:hive_flutter/hive_flutter.dart';
export 'package:intl/intl.dart' show NumberFormat;
export 'package:path_provider/path_provider.dart';

// 3. Data Models
export 'package:litzorum/models/armySettings.dart'; 
export 'package:litzorum/models/game.dart';
export 'package:litzorum/models/gameStats.dart';
export 'package:litzorum/models/ideology.dart';
export 'package:litzorum/models/settings.dart';

// 4. Global State & Services
export 'package:litzorum/main.dart';
export 'package:litzorum/services/audio_service.dart';
export 'package:litzorum/utils.dart';
export 'package:google_mlkit_translation/google_mlkit_translation.dart';
export 'package:provider/provider.dart';

// 5. Pages & Navigation
export 'package:litzorum/ending_page.dart';
export 'package:litzorum/game_stats_page.dart';
export 'package:litzorum/load_and_save_screen.dart';
export 'package:litzorum/logo_screen.dart';
export 'package:litzorum/main_screen.dart';
export 'package:litzorum/params_page.dart';
export 'package:litzorum/settings_page.dart';
export 'package:litzorum/start_screen.dart';
export 'package:litzorum/war_page.dart';
export 'package:litzorum/world_map_page.dart';

// 6. Faction-specific Pages
export 'package:litzorum/fraction_pages/army.dart';
export 'package:litzorum/fraction_pages/culture.dart';
export 'package:litzorum/fraction_pages/government.dart';
export 'package:litzorum/fraction_pages/industry.dart';
export 'package:litzorum/fraction_pages/people.dart';
export 'package:litzorum/fraction_pages/science.dart';
