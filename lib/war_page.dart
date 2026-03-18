import 'shared_imports.dart';

class WarPage extends StatefulWidget {
  final String countryName;

  const WarPage(this.countryName, {super.key});

  @override
  State<WarPage> createState() => _WarPageState();
}

class _WarPageState extends State<WarPage> {
  final Random random = Random();


  // Create parameter
  Padding parameter(String asset, String headText, List<String> text, [bool isPlayer=true]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Transform.flip(
        flipX: isPlayer? false : true, // Set to true to flip horizontally
        child: Wrap(
          runAlignment: WrapAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2.25,//1.24,
              height: 96*(5/6),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 159, 145, 110),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  Image.asset(asset, height: 96*(5/6), width: 96*(5/6)),
                
                  const SizedBox(width: 10*(5/6)),
                  
                  Transform.flip(
                    flipX: isPlayer? false : true,
                    child: Column(
                      crossAxisAlignment: isPlayer? CrossAxisAlignment.start : CrossAxisAlignment.end,
                      children: [
                      Text(headText, style: const TextStyle(
                        fontSize: 16*(5/6), color: Color.fromARGB(255, 63, 63, 63),
                        fontFamily: "Monda-Bold",
                      )),
                      
                      for (String i in text) 
                        Text(i, style: const TextStyle(
                          fontSize: 16*(5/6), color: Color.fromARGB(255, 63, 63, 63),
                          fontFamily: "Monda",
                        )),
                      ]
                    )
                  ),

                ],
              )
            ),
          ],
        )
      )
    );
  }


  Widget battleParametersList([bool isPlayer = true]) => Column(
    children: [
      parameter(
        isPlayer? "assets/air_defence.png" : "assets/air_defence_enemy.png", "Air defence", 
        [isPlayer? getShortNumberForm(currentArmySettings['Litzórum']!.airDefenceAmount) :
          getShortNumberForm(currentArmySettings[widget.countryName]!.airDefenceAmount)],
        isPlayer
      ),
      parameter(
        isPlayer? "assets/frontline.png" : "assets/frontline_enemy.png", "Frontline", 
        [isPlayer? getShortNumberForm(currentArmySettings['Litzórum']!.frontlineAmount) :
          getShortNumberForm(currentArmySettings[widget.countryName]!.frontlineAmount)],
        isPlayer
      ),
      parameter(
        isPlayer? "assets/home_front.png" : "assets/home_front_enemy.png", "Back", 
        [isPlayer? getShortNumberForm(currentArmySettings['Litzórum']!.backAmount) :
          getShortNumberForm(currentArmySettings[widget.countryName]!.backAmount)],
        isPlayer
      ),
      
      isPlayer? attackButton() : retreatButton(),
    ]
  ); 


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

          // Функція розрахунку втрат: повертає кількість загиблих юнітів
          double calculateDamage(double attackers, double attackLv, double defenders, double defenseLv, {double defBonus = 0}) {
            if (attackers < 1.0) return 0;

            // Співвідношення сил (наскільки атака сильніша за захист)
            // Чим вища технологія (Level), тим ефективніший кожен солдат
            double techFactor = (attackLv + 1) / (defenseLv + 1 + defBonus);
            
            // Базовий урон: атакуючі вбивають від 5% до 15% від своєї чисельності
            // Множимо на techFactor, щоб сильніша армія завдавала більше шкоди
            double rawDamage = attackers * (0.05 + random.nextDouble() * 0.1) * techFactor;

            // Обмежувач: не можна вбити за один раз більше, ніж 30% армії ворога 
            // (щоб бій не закінчувався за 1 клік)
            double maxDamagePerTurn = defenders * 0.3;
            
            return rawDamage.clamp(0, maxDamagePerTurn);
          }

          // 1. РАХУЄМО ВТРАТИ
          // Гравець б'є ворога (враховуємо ідеологію гравця в атаку)
          double enemyLossF = calculateDamage(player.frontlineAmount, currentGame.attackLevel, enemy.frontlineAmount, enemy.defenceLevel);
          double enemyLossA = calculateDamage(player.airDefenceAmount, currentGame.attackLevel, enemy.airDefenceAmount, enemy.defenceLevel);
          double enemyLossB = calculateDamage(player.backAmount, currentGame.attackLevel, enemy.backAmount, enemy.defenceLevel);

          // Ворог б'є гравця (враховуємо ідеологію гравця в захист)
          double playerLossF = calculateDamage(enemy.frontlineAmount, enemy.attackLevel, player.frontlineAmount, currentGame.defenceLevel, defBonus: ideologyBonus);
          double playerLossA = calculateDamage(enemy.airDefenceAmount, enemy.attackLevel, player.airDefenceAmount, currentGame.defenceLevel, defBonus: ideologyBonus);
          double playerLossB = calculateDamage(enemy.backAmount, enemy.attackLevel, player.backAmount, currentGame.defenceLevel, defBonus: ideologyBonus);

          // 2. ЗАСТОСОВУЄМО ВТРАТИ
          enemy.frontlineAmount -= enemyLossF;
          enemy.airDefenceAmount -= enemyLossA;
          enemy.backAmount -= enemyLossB;

          player.frontlineAmount -= playerLossF;
          player.airDefenceAmount -= playerLossA;
          player.backAmount -= playerLossB;

          // 3. ПЕРЕВІРКА ПОРОГУ (1000 юнітів) ТА ПЕРЕМОГИ
          // Якщо у когось менше 1000 хоча б в одному роді військ — поразка/перемога
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
            // Тут можна додати логіку штрафів для гравця
            saveGame();
          }
        });
      }, 

    
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset("assets/attack_button.png") 
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
        child: Image.asset("assets/retreat_button.png") 
        ),
      )
  );

  // War results dialog
  void showWarResultDialog(bool lose, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Користувач мусить натиснути кнопку
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(255, 63, 63, 63), width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: const Color.fromARGB(237, 159, 145, 110),
          title: Text(
            lose 
              ? "YOU LOST TO ${widget.countryName.toUpperCase()}\nBetter luck next time!" 
              : "YOU WON!\n${widget.countryName.toUpperCase()} is now part of Litzórum",
            textAlign: TextAlign.center, // Центрування тексту
            style: const TextStyle(
              color: Color.fromARGB(255, 63, 63, 63),
              fontFamily: "Monda-Bold",
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
                        saveGame(); // Зберігаємо гру
                        Navigator.of(context).pop(); // Закриваємо діалог
                        Navigator.of(context).pop(); // Повертаємось на карту/попередній екран
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        
                      },
                      child: Text(
                        lose ? "Sakjemeh!" : "C̦eantu máre", // Назви кнопок
                        style: const TextStyle(
                          color: Color.fromARGB(255, 159, 145, 110),
                          fontFamily: "Monda-Bold",
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
            image: AssetImage("assets/background.png"),
            fit: BoxFit.fill,
          ),
        ), 
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //showWarResultDialog(false, context)
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