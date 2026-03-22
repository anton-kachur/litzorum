import 'services/shared_imports.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//late TranslationService translationService;
late Box<Game> gameBox;
late Box<Ideology> ideologiesBox;
late Box<ArmySettings> countriesArmiesBox;
late Box<GameStats> gameStatsBox;
late Box<Settings> settingsBox;

Ideology currentIdeology = Ideology(name: "Progressivism", bonuses: {}, isChosen: true);
late Game currentGame;
late GameStats currentgameStats;
late Map<String, ArmySettings> currentArmySettings;
int impatienceLevel = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(IdeologyAdapter());
  Hive.registerAdapter(GameAdapter());
  Hive.registerAdapter(SettingsAdapter());
  Hive.registerAdapter(GameStatsAdapter());
  Hive.registerAdapter(ArmySettingsAdapter());

  //final audioService = AudioService();

  //============================================================================
  // Game stats ================================================================
  //============================================================================
  gameStatsBox = await Hive.openBox<GameStats>("game_stats");
  
  if (gameStatsBox.isEmpty) {
    gameStatsBox.put(
      "stats0", 
      GameStats(
        stats: {"exchange_amount": "1"}
      )
    );
  }

  currentgameStats = gameStatsBox.values.first;

  //============================================================================
  // Settings ==================================================================
  //============================================================================
  settingsBox = await Hive.openBox<Settings>("settings");
  if (settingsBox.isEmpty) {
    settingsBox.put(
      "settings0", 
      Settings(settings: {"player_name": "Immarhant Koljtwasser", "music_volume": "0.8", "sfx_volume": "1.0", "language": "en"})
    );
  }

  for (var i in settingsBox.values) {
    print(i.toString());
  }

  //translationService = TranslationService(); 

  //============================================================================
  // Ideologies ================================================================
  //============================================================================
  ideologiesBox = await Hive.openBox<Ideology>("ideologies");
  //ideologiesBox.clear();
  if (ideologiesBox.isEmpty) {
     ideologiesBox.put(
    "ideology0", 
      Ideology(name: "Mitsulón", bonuses: {"+25% Industry" : 0.25, "+20% Science": 0.2}, isChosen: true)
    );
    ideologiesBox.put(
      "ideology1", 
      Ideology(name: "Arźknejșriat", bonuses: {"+33% Army" : 0.33, "+40% Government": 0.4}, isChosen: false)
    );
    ideologiesBox.put(
      "ideology2", 
      Ideology(name: "Progressivism", bonuses: {"+60% Industry" : 0.6, "+50% Science": 0.5}, isChosen: false)
    );
    ideologiesBox.put(
      "ideology3", 
      Ideology(name: "Hedonism", bonuses: {"+50% People" : 0.5, "+70% Culture": 0.7}, isChosen: false)
    );
  }
   
  //============================================================================
  // Armies settings ===========================================================
  //============================================================================
  //var iBox = await Hive.openBox<ArmySettings>("saved_countries_armies");
  //iBox.clear();

  //============================================================================
  // Games =====================================================================
  //============================================================================
  gameBox = await Hive.openBox<Game>("saved_games");
  countriesArmiesBox = await Hive.openBox<ArmySettings>("saved_countries_armies");
  //gameBox.clear();
  //countriesArmiesBox.clear();

  runApp(
    const LoadingLogoScreen(),
  );
}
