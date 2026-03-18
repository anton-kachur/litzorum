import 'shared_imports.dart';

// Generate id for new game
String generateGameId() {
  String gameId = "";

  Random range = Random();
  for (int i=0; i<9; i++) {
    gameId += range.nextInt(10).toString();
  }
  return gameId;
}


// Format DateTime into human-readable string
String formatDateTime(DateTime date) => 
  "${"${date.day}".length < 2 ? "0${date.day}-" : "${date.day}-"}${"${date.month}".length < 2 ? "0${date.month}-" : "${date.month}-"}${date.year} ${"${date.hour}".length < 2 ? "0${date.hour}:" : "${date.hour}:"}${"${date.minute}".length < 2 ? "0${date.minute}" : "${date.minute}"}";


// Format long numbers in thousands, millions etc. 
String formatLongNumber(var number, {bool isDouble = false}) {
  String numberStr = "$number";
  var formatter = NumberFormat.compact();
  if (isDouble) return formatter.format(number);

  String result = "";

  for (int i = numberStr.length; i >= 1; i--) {
    if (i%3 == 0 && i != 1) { result += "."; }
    result += numberStr[numberStr.length-i];
  }

  return result; 
}


String getShortNumberForm(var number) {
  if (number >= 1000000000) {
    return (number / 1000000000).toStringAsFixed(1) + "b";
  } else if (number >= 1000000) {
    return (number / 1000000).toStringAsFixed(1) + "m";
  } else if (number >= 1000) {
    return (number / 1000).toStringAsFixed(1) + "k";
  } else if (number <= 1000) {
    return (number).toStringAsFixed(1);
  } else {
    return number.toString();
  }
}


/*Future newGameStats() async {
  var gameStatsBox = await Hive.openBox<GameStats>("game_stats");
  gameStatsBox.put(
    "game_stats", 
    GameStats(
      stats: {
        "exchange_amount": "1",
        "": "",
        "": "",
        "": "",
        "": "",
        "": "",
        "": "",
        "": "",
      }
    )
  );
  gameStatsBox.close();
}*/


// Save game state 
Future saveGame({String playerName = ""}) async {
  for (Game i in gameBox.values) {
    if (i.gameId == currentGame.gameId) {
      
      await gameBox.put(
        "game${i.gameId}",
        Game(
          gameId: currentGame.gameId,
          gameStartDate: formatDateTime(DateTime.now()),
          playerName: (playerName != "Noname" || playerName != "") ? playerName : currentGame.playerName,
          reigningYears: currentGame.reigningYears,
          ideology: currentGame.ideology,
          leadersPopularity: currentGame.leadersPopularity,
          population: currentGame.population,
          budget: currentGame.budget,
          goods: currentGame.goods,
          exchangeRate: currentGame.exchangeRate,
          educationLevel: currentGame.educationLevel,
          purchasingPower: currentGame.purchasingPower,
          lifeQuality: currentGame.lifeQuality,
          heavyIndustryFactoriesNumber: currentGame.heavyIndustryFactoriesNumber,
          heavyIndustryGoodsOutput: currentGame.heavyIndustryGoodsOutput,
          lightIndustryFactoriesNumber: currentGame.lightIndustryFactoriesNumber,
          lightIndustryGoodsOutput: currentGame.lightIndustryGoodsOutput,
          agricultureFarmsNumber: currentGame.agricultureFarmsNumber,
          agricultureFarmsGoodsOutput: currentGame.agricultureFarmsGoodsOutput,
          schoolsNumber: currentGame.schoolsNumber,
          universitiesNumber: currentGame.universitiesNumber,
          researchCentersNumber: currentGame.researchCentersNumber,
          bigProjects: currentGame.bigProjects,
          HQLevel: currentGame.HQLevel,
          attackLevel: currentGame.attackLevel,
          defenceLevel: currentGame.defenceLevel,
          cultureLevel: currentGame.cultureLevel,
          highCultureLevel: currentGame.highCultureLevel,
          massCultureLevel: currentGame.massCultureLevel
        )
      );
    }
  }

  for (ArmySettings i in countriesArmiesBox.values) {
    if (i.gameId == currentGame.gameId) {
      await countriesArmiesBox.put("Litzórum", currentArmySettings["Litzórum"]!);
    }
  }
  
}


// Display appBar stats
Wrap stat(String asset, var displayableData) => Wrap(
    runAlignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: 15,
    children: [
      Text(
        "${displayableData.runtimeType == double ? double.parse(displayableData.toStringAsFixed(1)) : displayableData}", 
        style: const TextStyle(
          fontSize: 16, color: Color.fromARGB(255, 63, 63, 63),
          fontFamily: "Monda-Bold",
        )),
      Image.asset(asset, height: 27, width: 34),
    ],
  );


/*void showToastMessage(BuildContext context, String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 1,
    backgroundColor: const Color.fromARGB(255, 63, 63, 63),
    textColor: const Color.fromARGB(255, 159, 145, 110),
    fontSize: 16.0,
  );  
}*/

// Back button
SizedBox backButton(BuildContext context, {String asset = ''}) => SizedBox(
  height: 75, width: 300,
  child: IconButton(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,

    onPressed: () {
      // Play the sound effect immediately
      AudioService().playClick(); 
      Navigator.pop(context, true);
    }, 
    icon: ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(asset == '' ? "assets/back_button.png" : "assets/$asset.png") 
      ),
    )
);


// Info iconButton
Tooltip infoButton(String message, bool isDark) => Tooltip(
    textStyle: const TextStyle(
      color: Color.fromARGB(255, 63, 63, 63), 
      fontFamily: "Monda-Regular",
      fontSize: 14
    ),
    
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 159, 145, 110),
      border: Border.all(width: 2, color: const Color.fromARGB(255, 63, 63, 63)),
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      
    ),

    showDuration: const Duration(seconds: 5),
    triggerMode: TooltipTriggerMode.tap,
    message: message, 
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13), 
      child: Image.asset(
        isDark ? "assets/info_icon.png" : "assets/info_icon_1.png", 
        height: 22
      )
    )
  );


// Create appBar
AppBar statsAppBar(BuildContext context) => AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: const Color.fromARGB(255, 159, 145, 110),
    toolbarHeight: MediaQuery.of(context).size.height / 6,
    centerTitle: true,
    title: Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.spaceEvenly,
      runAlignment: WrapAlignment.spaceEvenly,
      spacing: MediaQuery.of(context).size.width / 8,
      children: [
        Wrap(
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 15,
          children: [
            Image.asset("assets/ideologies/${currentIdeology.name}_ideology.png", height: 90, width: 90),
            RichText(
              text: TextSpan(
                  text: currentGame.playerName.split(" ").join("\n"), 
                  style: const TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 63, 63, 63),
                    fontFamily: "Monda-Bold",
                  ),

                  children: <TextSpan>[
                    TextSpan(
                      text: "\nyears: ${double.parse(currentGame.reigningYears.toStringAsFixed(1))}", 
                      style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 63, 63, 63),
                      fontFamily: "Monda",
                    )),

                  ],
              )
            )
            
          ],
        ),

        Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.vertical,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,

          children: [
            stat("assets/money_small.png", formatLongNumber(currentGame.budget, isDouble: true)),
            stat("assets/goods_small.png", formatLongNumber(currentGame.goods, isDouble: true)),
            stat("assets/rate_small.png", currentGame.leadersPopularity),
          ],
        ),
      ],
    ),
  );


double getIdeologyBonus(String fractionName) {
  for (var i in currentIdeology.bonuses.keys) {
    if (i.contains(fractionName)) {
      return currentIdeology.bonuses[i] ?? 1.0;
    }
  }

  return 0.0;
}

// Create bottomNavigationBar
BottomAppBar bottomBar(BuildContext context) {

  return BottomAppBar(
    surfaceTintColor: Colors.transparent,
    color:const Color.fromARGB(255, 159, 145, 110),
    
    height: 99,
    child: Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      spacing: 7,
      children: [
        
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent, 
          icon: Image.asset(
            scale: 2,
            "assets/back_to_menu_button_1.png"
          ), 
          onPressed: () {
            // Play the sound effect immediately
            AudioService().playClick(); 
            saveGame();
            Navigator.of(context).popUntil(ModalRoute.withName("start_screen"));
          }
        ),
        
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Image.asset(
            scale: 2,
            "assets/save_progress_button_1.png"
          ), 
          onPressed: () {
            // Play the sound effect immediately
            AudioService().playClick(); 
            saveGame();
          }
        ),

        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent, 
          icon: Image.asset(
            scale: 2.7,
            "assets/proceed_button.png"
          ), 
          onPressed: () {
            // Play the sound effect immediately
            AudioService().playClick(); 
            currentGame.reigningYears += 0.1;

            //=====================================================================================================
            // Full-time reigning ending ==========================================================================
            //=====================================================================================================
            if (double.parse(currentGame.reigningYears.toStringAsFixed(1)) == 80.0) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("GG WP!!!"),
                duration: Duration(seconds: 5),
              ));
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const GameStatsPage()));
            } else {
                currentGame.goods += currentGame.heavyIndustryGoodsOutput + 
                  currentGame.lightIndustryGoodsOutput + 
                  currentGame.agricultureFarmsGoodsOutput;


              double el = (((currentGame.schoolsNumber + (currentGame.schoolsNumber * getIdeologyBonus("Science"))) * 700) + 
                  ((currentGame.universitiesNumber + (currentGame.universitiesNumber * getIdeologyBonus("Science"))) * 1200) + 
                  ((currentGame.researchCentersNumber + (currentGame.researchCentersNumber * getIdeologyBonus("Science"))) * 1700)
                  ) / currentGame.population;

              currentGame.educationLevel = el > 1.0 ? 1.0 : el;


              double pp = currentGame.budget / currentGame.population;
              currentGame.purchasingPower = pp > 1.0 ? 1.0 : el;


              currentGame.cultureLevel = (currentGame.highCultureLevel + currentGame.massCultureLevel) / 2; 

              currentGame.lifeQuality = (currentGame.purchasingPower + currentGame.educationLevel + currentGame.cultureLevel) / 3;
              currentGame.leadersPopularity = (currentGame.lifeQuality) /*+ getBigProjectsBonuses(currentGame.bigProjects)*/ * 100;

              if (currentGame.educationLevel <= 0.5 || currentGame.purchasingPower <=0.5) {
                impatienceLevel++;
                currentGame.population = currentGame.population - (currentGame.population * currentGame.lifeQuality * 0.3).round();
              } else {
                impatienceLevel--;
                currentGame.population = currentGame.population + (currentGame.population * currentGame.lifeQuality * 0.3).round();
              }


            //=====================================================================================================
            // Revolution ending ==================================================================================
            //=====================================================================================================
              if (impatienceLevel == 15) {
                saveGame();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("OH NO!!!"),
                  duration: Duration(seconds: 5),
                ));
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const EndingPage(type: "revolution")));
              }

              //====================================================================================================
              // Uberhedonism ending ===============================================================================
              //====================================================================================================
              if (
                currentIdeology.name == "Hedonism" && currentGame.lifeQuality >= 0.95 && 
                currentGame.leadersPopularity >= 87 && (currentGame.budget >= currentGame.population/3)
              ) {
                saveGame();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("GG WP!!!"),
                  duration: Duration(seconds: 5),
                ));
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const EndingPage(type: "uberhedonism")));
              }

              saveGame();
            }
          }
        ),
        
        

      ],
    ),
  );
}


int getNumberOfConquiredCountries() {
  int counter = 0;
  for (ArmySettings i in countriesArmiesBox.values) {
    if (i.isConquired) {
      counter++;
    }
  }

  return counter;
}


Future changeGameStats(String stat, String newValue) async {
  Box<GameStats> gameStatsBox = await Hive.openBox("game_stats");
  if (gameStatsBox.getAt(0)!.stats.keys.contains(stat)) {
    gameStatsBox.getAt(0)!.stats[stat] = newValue;
  } 

  gameStatsBox.close();
}