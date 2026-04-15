import 'package:litzorum/services/translation_service.dart';

import 'services/shared_imports.dart';

/// The save management screen for handling game progression and data persistence.
/// 
/// Manages multiple save slots, allowing the player to start new games with 
/// randomized country stats, load existing sessions, or delete saved data 
/// and associated army settings from the database.
class LoadSaveScreen extends StatefulWidget {
  const LoadSaveScreen({super.key});

  @override
  State<LoadSaveScreen> createState() => _LoadSaveScreenState();
}

class _LoadSaveScreenState extends State<LoadSaveScreen> {
  bool deleteIcon = false;
  int totalSlots = 9;

  // Get saved games
  Future getSavings() async {
    return Future.value([gameBox.values, countriesArmiesBox.values]);
  }

  // Extract current army settings
  Future openCurrentArmySettingsBox(String gameId) async {
    Map<String, ArmySettings> values = {};
    
    if (countriesArmiesBox.isNotEmpty) {
      for (ArmySettings i in countriesArmiesBox.values) {
        if (i.gameId == gameId) {
          values[i.countryName] = i;
        }
      }

      return Future.value(values);
    } else {
      return createNewArmySettings(gameId);
    }
  }

  // Extract current game settings
  Future openCurrentGameBox(String gameId) async {
    for (Game i in gameBox.values) {
      if (i.gameId == gameId) {
        return Future.value(i);
      }
    }
  }

  // Delete saved game
  Future deleteSaving(String gameId) async {
    // Видаляємо саму гру
    final gameKey = gameBox.keys.firstWhere(
      (k) => gameBox.get(k)?.gameId == gameId, 
      orElse: () => null
    );
    if (gameKey != null) await gameBox.delete(gameKey);

    // Видаляємо всі армії, пов'язані з цією грою
    final keysToDelete = countriesArmiesBox.keys.where(
      (k) => countriesArmiesBox.get(k)?.gameId == gameId
    ).toList();
    
    for (var key in keysToDelete) {
      await countriesArmiesBox.delete(key);
    }

    impatienceLevel = 0;
  }

  // Icon with cross for deleting saved game
  SizedBox deleteSavedGameButton(BuildContext context) {
    return SizedBox(
      height: 75, width: 300,
      child: IconButton(
        onPressed: () {
          // Play the sound effect immediately
          AudioService().playClick(); 
          setState(() {
            deleteIcon = !deleteIcon;
          }); 
        }, 
        icon: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
                "assets/buttons/blank.png",
            ),

            Text(
              "Delete saved game".tr,
              style: const TextStyle(
                fontFamily: "Roboto-Bold",
                fontSize: 19,
                color: Color.fromARGB(255, 205, 192, 68),
              ),
            ),
          ]
        ) 
      )
    );
  }

  // Creates settings for players' army
  Future createNewArmySettings(String gameId) async {
    Map<String, ArmySettings> newArmySettings = {
      "Litzórum": ArmySettings(
        gameId: gameId, countryName: "Litzórum", isConquired: false, armyAmount: 190000, airDefenceAmount: 11000, 
        frontlineAmount: 120000, backAmount: 59000, 
        attackLevel: 2.5, // !!! not used in game !!!
        defenceLevel: 1.5, // !!! not used in game !!!
        relations: 100.0,
        isInUnion: true,
        tradeMoneyAmount: 0
      ),
      "Imrenia": ArmySettings(
        gameId: gameId, countryName: "Imrenia", isConquired: false, armyAmount: 37000, airDefenceAmount: 1300, 
        frontlineAmount: 20000, backAmount: 15700, 
        attackLevel: (Random().nextInt(100) + 5) / 10, 
        defenceLevel: (Random().nextInt(100) + 5) / 10,
        relations: 90.0,
        isInUnion: false,
        tradeMoneyAmount: 0
      ),
      "Semnuria": ArmySettings(
        gameId: gameId, countryName: "Semnuria", isConquired: false, armyAmount: 200000, airDefenceAmount: 15000, 
        frontlineAmount: 100000, backAmount: 85000, 
        attackLevel: (Random().nextInt(100) + 10) / 10, 
        defenceLevel: (Random().nextInt(100) + 10) / 10,
        relations: 10.0,
        isInUnion: false,
        tradeMoneyAmount: 0
      ),
      "Vojtrajt": ArmySettings(
        gameId: gameId, countryName: "Vojtrajt", isConquired: false, armyAmount: 70000, airDefenceAmount: 2500, 
        frontlineAmount: 40000, backAmount: 27500, 
        attackLevel: (Random().nextInt(100) + 10) / 10, 
        defenceLevel: (Random().nextInt(100) + 10) / 10,
        relations: 77.0,
        isInUnion: false,
        tradeMoneyAmount: 0
      ),
      "Arga": ArmySettings(
        gameId: gameId, countryName: "Arga", isConquired: false, armyAmount: 30000, airDefenceAmount: 4000, 
        frontlineAmount: 18000, backAmount: 8000, 
        attackLevel: (Random().nextInt(100) + 5) / 10, 
        defenceLevel: (Random().nextInt(100) + 5) / 10,
        relations: 97.0,
        isInUnion: false,
        tradeMoneyAmount: 0
      ),
      "Ștemerkenź": ArmySettings(
        gameId: gameId, countryName: "Ștemerkenź", isConquired: false, armyAmount: 25000, airDefenceAmount: 1500, 
        frontlineAmount: 11000, backAmount: 12500, 
        attackLevel: (Random().nextInt(100) + 5) / 10, 
        defenceLevel: (Random().nextInt(100) + 5) / 10,
        relations: 50.0,
        isInUnion: false,
        tradeMoneyAmount: 0
      ),
      "Serkamenia": ArmySettings(
        gameId: gameId, countryName: "Serkamenia", isConquired: false, armyAmount: 15000, airDefenceAmount: 800, 
        frontlineAmount: 7000, backAmount: 7200, 
        attackLevel: (Random().nextInt(100) + 5) / 10, 
        defenceLevel: (Random().nextInt(100) + 5) / 10,
        relations: 50.0,
        isInUnion: false,
        tradeMoneyAmount: 0
      ),
      "Vajläulä": ArmySettings(
        gameId: gameId, countryName: "Vajläulä", isConquired: false, armyAmount: 12000, airDefenceAmount: 2700, 
        frontlineAmount: 6000, backAmount: 3300, 
        attackLevel: (Random().nextInt(100) + 5) / 10, 
        defenceLevel: (Random().nextInt(100) + 5) / 10,
        relations: 50.0,
        isInUnion: false,
        tradeMoneyAmount: 0
      ),
      "Kamraiștanź": ArmySettings(
        gameId: gameId, countryName: "Kamraiștanź", isConquired: false, armyAmount: 15000, airDefenceAmount: 3500, 
        frontlineAmount: 6700, backAmount: 4800, 
        attackLevel: (Random().nextInt(100) + 5) / 10, 
        defenceLevel: (Random().nextInt(100) + 5) / 10,
        relations: 70.0,
        isInUnion: false,
        tradeMoneyAmount: 0
      ),
      "Zrașpolj Riatst": ArmySettings(
        gameId: gameId, countryName: "Zrașpolj Riatst", isConquired: false, armyAmount: 180000, airDefenceAmount: 10000, 
        frontlineAmount: 100000, backAmount: 70000, 
        attackLevel: (Random().nextInt(100) + 10) / 10, 
        defenceLevel: (Random().nextInt(100) + 10) / 10,
        relations: 50.0,
        isInUnion: false,
        tradeMoneyAmount: 0
      )
    };

    countriesArmiesBox.put("Litzórum", newArmySettings["Litzórum"]!);
    countriesArmiesBox.put("Imrenia", newArmySettings["Imrenia"]!);
    countriesArmiesBox.put("Semnuria", newArmySettings["Semnuria"]!);
    countriesArmiesBox.put("Vojtrajt", newArmySettings["Vojtrajt"]!);
    countriesArmiesBox.put("Arga", newArmySettings["Arga"]!);
    countriesArmiesBox.put("Ștemerkenź", newArmySettings["Ștemerkenź"]!);
    countriesArmiesBox.put("Serkamenia", newArmySettings["Serkamenia"]!);
    countriesArmiesBox.put("Vajläulä", newArmySettings["Vajläulä"]!);
    countriesArmiesBox.put("Kamraiștanź", newArmySettings["Kamraiștanź"]!);
    countriesArmiesBox.put("Zrașpolj Riatst", newArmySettings["Zrașpolj Riatst"]!);

    currentArmySettings = newArmySettings;

    return Future.value(newArmySettings);
  }

  // Initializes new game parameters and saves it to database
  Future startNewGame() async {
    String playerName = settingsBox.values.first.settings["player_name"] ?? "Noname";
    String newGameId = generateGameId();

    // New game ----------------------------------------------------------------
    Game newGame = Game(
      gameId: newGameId,
      gameStartDate: formatDateTime(DateTime.now()),
      playerName: playerName,
      reigningYears: 0.0,
      ideology: "Mitsulón",
      leadersPopularity: 50.0,
      population: 70000000,
      budget: 100000,
      goods: 100000,
      exchangeRate: "1/1",
      educationLevel: 0.99,
      purchasingPower: 0.5,
      lifeQuality: 0.5,
      heavyIndustryFactoriesNumber: 100,
      heavyIndustryGoodsOutput: 100,
      lightIndustryFactoriesNumber: 200,
      lightIndustryGoodsOutput: 300,
      agricultureFarmsNumber: 500,
      agricultureFarmsGoodsOutput: 600,
      schoolsNumber: 50000,
      universitiesNumber: 2000,
      researchCentersNumber: 30,
      bigProjects: [],
      HQLevel: 1,
      attackLevel: 2.5,
      defenceLevel: 1.5,
      cultureLevel: 0.4,
      highCultureLevel: 0.5,
      massCultureLevel: 0.3
    );

    gameBox.put(
      "game$newGameId",
      newGame
    );

    currentGame = newGame;

    await createNewArmySettings(newGameId);
  }

  // Save icon button
  Column savingSlotButton(String asset, [String gameId = '', String? date]) => Column(
    children: [
      Stack(
        alignment: Alignment.topRight,
        children: [
          IconButton(
            onPressed: () async {
              // Play the sound effect immediately
              AudioService().playClick(); 
              if (deleteIcon) return; 
              
              if (date != null) {
                currentGame = await openCurrentGameBox(gameId);
                currentGame.playerName = settingsBox.values.first.settings["player_name"]!;
                currentArmySettings = await openCurrentArmySettingsBox(gameId);
                navigatorKey.currentState?.push(
                  MaterialPageRoute(builder: (context) => const MainScreen())
                );
              } else {
                await startNewGame();
                navigatorKey.currentState?.push(
                  MaterialPageRoute(builder: (context) => const MainScreen())
                );
              }
            }, 
            icon: Image.asset(asset, scale: 1.7),
          ),

          // Cross icon
          if (deleteIcon && date != null) 
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () async {
                  await deleteSaving(gameId);
                  setState(() {
                    if (gameBox.isEmpty) deleteIcon = false;
                  });
                }, 
                child: Image.asset(
                  "assets/buttons/cancel_icon.png", 
                  height: 30, width: 30
                ),
              ),
            ),
        ]
      ), 
      Text(
        (date != null) ? "Id: $gameId\n$date" : "Empty slot".tr, 
        style: const TextStyle(fontFamily: "Roboto-Regular", fontSize: 10),
        textAlign: TextAlign.center,
      )
    ], 
  );


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getSavings(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 173, 173, 173),
          
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/other/background.png"),
                  fit: BoxFit.fill,
                ),
              ), 
              child: Padding(
                padding: const EdgeInsetsGeometry.symmetric(vertical: 40, horizontal: 20),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [

                    if (snapshot.hasData)
                      for (Game game in snapshot.data[0]) 
                        savingSlotButton(
                          "assets/buttons/save.png", game.gameId, game.gameStartDate
                        ),
                        
                    for (int i = 0; i < totalSlots - (
                        snapshot.hasData ? snapshot.data[0].length : 0); i++
                      )
                      savingSlotButton("assets/buttons/empty_slot.png"),
                    
                    if (snapshot.hasData && snapshot.data[0].isNotEmpty) 
                      deleteSavedGameButton(context),

                    Center(
                      child: IconButton(
                        padding: EdgeInsets.only(
                          top: 10
                        ),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent, 
                        icon: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              scale: 2,
                              "assets/buttons/blank.png"
                            ), 

                            Text(
                              "Back to menu".tr,
                              style: const TextStyle(
                                fontFamily: "Roboto-Bold",
                                fontSize: 16,
                                color: Color.fromARGB(255, 205, 192, 68),
                              ),
                            ),
                          ]
                        ),
                        
                        onPressed: () {
                          // Play the sound effect immediately
                          AudioService().playClick(); 
                          Navigator.of(context).popUntil(
                            ModalRoute.withName("start_screen")
                          );
                        }
                      ), 
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}