import 'package:litzorum/services/translation_service.dart';

import 'services/shared_imports.dart';

/// The battlefield screen where the player engages in combat with other countries.
/// 
/// Manages the visual representation of army stats (Air Defence, Frontline, Back),
/// calculates turn-based battle damage, and handles victory or defeat logic.
class WarPage extends StatefulWidget {
  final String countryName;

  const WarPage(this.countryName, {super.key});

  @override
  State<WarPage> createState() => _WarPageState();
}

class _WarPageState extends State<WarPage> {
  final Random random = Random();

  // Main parameters for battle
Padding parameter(String asset, String headText, List<String> text, [bool isPlayer = true]) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Transform.flip(
      flipX: isPlayer ? false : true,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.25,
        constraints: const BoxConstraints(minHeight: 96 * (5 / 6)),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 159, 145, 110),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(asset, height: 80, width: 80),
            const SizedBox(width: 8),
            
            Expanded(
              child: Transform.flip(
                flipX: isPlayer ? false : true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: isPlayer ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    
                    Text(
                      headText.tr,
                      textAlign: isPlayer ? TextAlign.start : TextAlign.end,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 63, 63, 63),
                        fontFamily: "Roboto-Bold",
                      ),
                    ),
                    
                    const SizedBox(height: 2),
                    
                    for (String i in text)
                      Text(
                        i.tr,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 63, 63, 63),
                          fontFamily: "Roboto",
                        ),
                      ),

                  ],
                ),
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    ),
  );
}

  // Creates battle parameters for each fraction like air_defence, frontline and back
  Widget battleParametersList([bool isPlayer = true]) => Column(
    children: [
      parameter(
        isPlayer? "assets/buttons/air_defence.png" : "assets/buttons/air_defence_enemy.png", "Air defence", 
        [isPlayer? getShortNumberForm(currentArmySettings['Litzórum']!.airDefenceAmount) :
          getShortNumberForm(currentArmySettings[widget.countryName]!.airDefenceAmount)],
        isPlayer
      ),
      parameter(
        isPlayer? "assets/buttons/frontline.png" : "assets/buttons/frontline_enemy.png", "Frontline", 
        [isPlayer? getShortNumberForm(currentArmySettings['Litzórum']!.frontlineAmount) :
          getShortNumberForm(currentArmySettings[widget.countryName]!.frontlineAmount)],
        isPlayer
      ),
      parameter(
        isPlayer? "assets/buttons/home_front.png" : "assets/buttons/home_front_enemy.png", "Back", 
        [isPlayer? getShortNumberForm(currentArmySettings['Litzórum']!.backAmount) :
          getShortNumberForm(currentArmySettings[widget.countryName]!.backAmount)],
        isPlayer
      ),
      
      isPlayer? attackButton() : retreatButton(),
    ]
  ); 

  // Check if all countries conquired
  // Important for the emergence of a military ending
  bool checkIfAllCountriesConquired() {
    int counter = 0;
    for (var i in currentArmySettings.values) {
      if (i.isConquired) counter++;
    }

    return counter == currentArmySettings.length ? true : false;
  }

  // Attack button
  SizedBox attackButton() => SizedBox(
    height: 65, width: 185,
    child: IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,

      onPressed: () {
        // Play the sound effect immediately
        AudioService().playClick(); 
        setState(() {
        // player attacks ======================================================
          var enemy = currentArmySettings[widget.countryName]!;
          var player = currentArmySettings['Litzórum']!;
          double ideologyBonus = getIdeologyBonus("Army");

          // Casualty calculation function: returns the number of units killed
          double calculateDamage(
            double attackers, double attackLv, double defenders, 
            double defenseLv, {double defBonus = 0}
          ) {
            if (attackers < 1.0) return 0;

            // Power ratio (how much stronger the attack is than the defense)
            // The higher the technology (Level), the more effective each soldier is.
            double techFactor = (attackLv + 1) / (defenseLv + 1 + defBonus);
            
            // Main damage: Attackers kill 5% to 15% of their number
            // Multiply by techFactor so that a stronger army deals more damage
            double rawDamage = attackers * (0.05 + random.nextDouble() * 0.1) * techFactor;

            // Limiter: cannot kill more than 30% of the enemy army at once
            // (so that the battle doesn't end in 1 click)
            double maxDamagePerTurn = defenders * 0.3;
            
            return rawDamage.clamp(0, maxDamagePerTurn);
          }

          // 1. COUNTING LOSSES
          // The player hits the enemy (we take into account the ideology of the 
          // attacking player)
          double enemyLossF = calculateDamage(
            player.frontlineAmount, currentGame.attackLevel, 
            enemy.frontlineAmount, enemy.defenceLevel
          );
          double enemyLossA = calculateDamage(
            player.airDefenceAmount, currentGame.attackLevel, 
            enemy.airDefenceAmount, enemy.defenceLevel
          );
          double enemyLossB = calculateDamage(
            player.backAmount, currentGame.attackLevel, 
            enemy.backAmount, enemy.defenceLevel
          );

          // The enemy hits the player (we take into account the player's 
          // ideology in defense)
          double playerLossF = calculateDamage(
            enemy.frontlineAmount, enemy.attackLevel, player.frontlineAmount, 
            currentGame.defenceLevel, defBonus: ideologyBonus
          );
          double playerLossA = calculateDamage(
            enemy.airDefenceAmount, enemy.attackLevel, player.airDefenceAmount, 
            currentGame.defenceLevel, defBonus: ideologyBonus
          );
          double playerLossB = calculateDamage(
            enemy.backAmount, enemy.attackLevel, player.backAmount, 
            currentGame.defenceLevel, defBonus: ideologyBonus
          );

          // 2. APPLY LOSSES
          enemy.frontlineAmount -= enemyLossF;
          enemy.airDefenceAmount -= enemyLossA;
          enemy.backAmount -= enemyLossB;

          player.frontlineAmount -= playerLossF;
          player.airDefenceAmount -= playerLossA;
          player.backAmount -= playerLossB;

          // 3. THRESHOLD CHECK (100 UNITS) AND VICTORY
          // If someone has less than 100 in at least one type of troops - 
          // defeat/victory
          bool enemyDefeated = enemy.frontlineAmount < 100 || enemy.airDefenceAmount < 100 || enemy.backAmount < 100;
          bool playerDefeated = player.frontlineAmount < 100 || player.airDefenceAmount < 100 || player.backAmount < 100;

          if (enemyDefeated) {
            enemy.isConquired = true;
            player.armyAmount = (player.frontlineAmount + player.airDefenceAmount + player.backAmount);
            if (!checkIfAllCountriesConquired()) {
              saveGame();
              showWarResultDialog(false, context);
            } else {
              saveGame();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("GG WP!!!"),
                duration: Duration(seconds: 5),
              ));
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const EndingPage(type: "military")));
            }
            
          } else if (playerDefeated) {
            player.armyAmount = (player.frontlineAmount + player.airDefenceAmount + player.backAmount);
            showWarResultDialog(true, context);
            saveGame();
          }
        });
      }, 

    
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset("assets/buttons/attack_button.png") 
        ),
      )
  );

  // Retreat button
  SizedBox retreatButton() => SizedBox(
    height: 65, width: 185,
    child: IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,

      onPressed: () {
        // Play the sound effect immediately
        AudioService().playClick(); 
      }, 
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset("assets/buttons/retreat_button.png") 
        ),
      )
  );

  // War results dialog
  void showWarResultDialog(bool lose, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(255, 63, 63, 63), width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: const Color.fromARGB(237, 159, 145, 110),
          title: Text(
            lose 
              ? "${'YOU LOST TO'.tr} ${widget.countryName.toUpperCase()}\n${'Better luck next time'.tr}!" 
              : "${'YOU WON'.tr}!\n${widget.countryName.toUpperCase()} ${'is now part of Litzórum'.tr}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color.fromARGB(255, 63, 63, 63),
              fontFamily: "Roboto-Bold",
              fontSize: 18,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 63, 63, 63),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: () {
                        // Play the sound effect immediately
                        AudioService().playClick(); 
                        saveGame();
                        Navigator.of(context).pop(); // closing dialog
                        Navigator.of(context).pop(); 
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop(); // returning to main_screen
                        
                      },
                      child: Text(
                        lose ? "Sakjemeh!" : "C̦eantu máre", // buttons' names
                        style: const TextStyle(
                          color: Color.fromARGB(255, 159, 145, 110),
                          fontFamily: "Roboto-Bold",
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 173, 173, 173),
      
      appBar: statsAppBar(context),
     
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/other/background.png"),
            fit: BoxFit.fill,
          ),
        ), 
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                battleParametersList(),
                battleParametersList(false)
              ],
            )
          ),
        )
      )
    );
  }
}