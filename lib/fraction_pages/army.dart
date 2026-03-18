import 'package:litzorum/shared_imports.dart';

class Army extends StatefulWidget {
  const Army({super.key});

  @override
  State<Army> createState() => _ArmyState();
}

class _ArmyState extends State<Army> {
  double hqExpence = 50000.0 - (50000.0  * getIdeologyBonus("Army"));
  double attackExpense = 100000.0 - (100000.0  * getIdeologyBonus("Army"));
  double defenceExpense = 50000.0 - (50000.0  * getIdeologyBonus("Army"));

  late Map<String, String> toolTips = {
    "Attack" : "Costs ${(attackExpense / 1000).round()}k",
    "Defence" : "Costs ${(defenceExpense / 1000).round()}k",
    "HQ" : "Costs ${(hqExpence / 1000).round()}k",
    "World map" : "Map of the world",
    "Air defence" : "Costs ",
    "Back" : "Costs ",
    "Frontline" : "Costs ",
  };

    // Create parameter
  Padding parameter(String asset, String headText, List<String> text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 96,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 63, 63, 63),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),

        child: Wrap(
          children: [

            Container(
              width: MediaQuery.of(context).size.width / 1.24,
              height: 96,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 159, 145, 110),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
              ),
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  Image.asset(asset, height: 96, width: 96),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(headText, style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 63, 63, 63),
                      fontFamily: "Monda-Bold",
                    )),
                    
                    for (String i in text) 
                      Text(i, style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 63, 63, 63),
                        fontFamily: "Monda",
                      )),

                    if (headText == "Air defence" || headText == "Back" || 
                      headText == "Frontline") 
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 42, 
                          width: MediaQuery.of(context).size.width / 1.88, 
                          child: sliderPersonnel(headText)
                        ),
                    
                  ]),
                ],
              ),
            ),

            Column(
              children: [
                infoButton(toolTips[headText]!, true),

                IconButton(
                  onPressed: () {
                    // Play the sound effect immediately
                    AudioService().playClick(); 
                    if (headText == "World map") {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const WorldMapPage()));
                    } else {
                      if (headText == "HQ") {
                        if (currentGame.budget < hqExpence) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Not enough money"),
                          ));
                        } else {
                          if (currentGame.HQLevel < 10.0) {
                            setState(() {
                              currentGame.budget -= hqExpence; 
                              currentGame.HQLevel += 0.1; 
                            });
                          } else {}
                        }
                      } else if (headText == "Attack") {
                        if (currentGame.budget < attackExpense) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Not enough money"),
                          ));
                        } else {
                          if (currentGame.attackLevel < 10.0) {
                            setState(() {
                              currentGame.budget -= attackExpense; 
                              currentGame.attackLevel += 0.1;
                            });
                          } else {}
                        }
                      } else if (headText == "Defence") {
                        if (currentGame.budget < defenceExpense) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Not enough money"),
                          ));
                        } else {
                          if (currentGame.defenceLevel < 10.0) {
                            setState(() {
                              currentGame.budget -= defenceExpense; 
                              currentGame.defenceLevel += 0.1;
                            });
                          } else {}
                        }
                      } else if (headText == "Air defence") {
                        if (currentGame.budget < defenceExpense) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Not enough money"),
                          ));
                        } else {
                          setState(() {
                            //currentGame.budget -= defenceExpense; 
                            //currentGame.defenceLevel += 0.1;
                          });
                        }
                      } else if (headText == "Back") {
                        if (currentGame.budget < defenceExpense) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Not enough money"),
                          ));
                        } else {
                          setState(() {
                            //currentGame.budget -= defenceExpense; 
                            //currentGame.defenceLevel += 0.1;
                          });
                        }
                      } else if (headText == "Frontline") {
                        if (currentGame.budget < defenceExpense) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Not enough money"),
                          ));
                        } else {
                          setState(() {
                            //currentGame.budget -= defenceExpense; 
                            //currentGame.defenceLevel += 0.1;
                          });
                        }
                      }
                      
                      currentGame.cultureLevel = (currentGame.highCultureLevel + currentGame.massCultureLevel) / 2;
                      currentGame.lifeQuality = (currentGame.purchasingPower + currentGame.educationLevel + currentGame.cultureLevel) / 3;
                    }
                  }, 
                  icon: headText == "World map" ? 
                    Image.asset("assets/expand_icon.png", height: 22) :
                      (headText == "Attack" || headText == "Defence" 
                      || headText == "HQ") ?
                      Image.asset("assets/fund_icon.png", height: 22) : 
                      Image.asset("assets/accept_icon.png", height: 22)
                ),
              ]
            ),

          ],
        )
      )
    );
  }

  SliderTheme sliderPersonnel(String parameter) => SliderTheme(
    data: SliderTheme.of(context).copyWith(
      activeTrackColor: const Color.fromARGB(255, 63, 63, 63),
      inactiveTrackColor: const Color.fromARGB(160, 63, 63, 63),
      thumbColor: const Color.fromARGB(255, 85, 85, 85),
      overlayColor: const Color.fromARGB(0, 0, 0, 0),
      valueIndicatorColor: const Color.fromARGB(255, 63, 63, 63),
      
      valueIndicatorTextStyle: const TextStyle(
        color: Color.fromARGB(255, 159, 145, 110),
        fontSize: 10.0,
      ),
      showValueIndicator: ShowValueIndicator.onDrag,
      // Налаштування меж та форми
      trackHeight: 6.0,
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 12.0,
      ),
      // Якщо потрібна чітка рамка навколо треку, використовуємо кастомний Paint
      trackShape: const RoundedRectSliderTrackShape(), 
    ),
    child: Slider(
      value: parameter == "Air defence" ? 
        currentArmySettings['Litzórum']!.airDefenceAmount : 
        parameter == "Frontline" ? currentArmySettings['Litzórum']!.frontlineAmount : 
        currentArmySettings['Litzórum']!.backAmount,
      label: (parameter == "Air defence" ? 
        currentArmySettings['Litzórum']!.airDefenceAmount : 
        parameter == "Frontline" ? currentArmySettings['Litzórum']!.frontlineAmount : 
        currentArmySettings['Litzórum']!.backAmount).round().toString(),
      min: 0,
      max: currentArmySettings['Litzórum']!.armyAmount,
      onChanged: (value) {
        if (parameter == "Air defence") {
          if (value <= (currentArmySettings['Litzórum']!.armyAmount - currentArmySettings['Litzórum']!.frontlineAmount - currentArmySettings['Litzórum']!.backAmount)) {
              currentArmySettings['Litzórum']!.airDefenceAmount = value;
          }
        } else if (parameter == "Frontline") {
          if (value <= (currentArmySettings['Litzórum']!.armyAmount - currentArmySettings['Litzórum']!.airDefenceAmount - currentArmySettings['Litzórum']!.backAmount)) {
              currentArmySettings['Litzórum']!.frontlineAmount = value;
          }
        } else {
          if (value <= (currentArmySettings['Litzórum']!.armyAmount - currentArmySettings['Litzórum']!.frontlineAmount - currentArmySettings['Litzórum']!.airDefenceAmount)) {
              currentArmySettings['Litzórum']!.backAmount = value;
          }
        }
        setState(() {});
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 173, 173, 173),
      
      appBar: statsAppBar(context),
     
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background.png"), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                parameter(
                  "assets/world_map.png", "World map", 
                  ["Countries conquired: ${getNumberOfConquiredCountries()}",
                  "${((getNumberOfConquiredCountries()*100)/currentArmySettings.length).round()}%"]
                ),
                parameter(
                  "assets/hq.png", "HQ", 
                  ["Level: ${
                    currentGame.HQLevel < 10? 
                      "${double.parse(currentGame.HQLevel.toStringAsFixed(2))}" :
                      "MAX"}",
                    currentGame.HQLevel < 10? 
                      "To next level: ${double.parse(((currentGame.HQLevel + 1.0).round() - currentGame.HQLevel ).toStringAsFixed(2))}" :
                      ""
                  ]
                ),
                parameter(
                  "assets/attack.png", "Attack", 
                  ["Level: ${
                    currentGame.attackLevel < 10?
                      "${double.parse(currentGame.attackLevel.toStringAsFixed(2))}" :
                      "MAX"}",
                    currentGame.attackLevel < 10? 
                      "To next level: ${double.parse(((currentGame.attackLevel + 1.0).round() - currentGame.attackLevel ).toStringAsFixed(2))}" :
                      ""
                  ]
                ),
                parameter(
                  "assets/defence.png", "Defence", 
                  ["Level: ${
                    currentGame.defenceLevel < 10? 
                      "${double.parse(currentGame.defenceLevel.toStringAsFixed(2))}" :
                      "MAX"}",
                    currentGame.defenceLevel < 10? 
                      "To next level: ${double.parse(((currentGame.defenceLevel + 1.0).round() - currentGame.defenceLevel ).toStringAsFixed(2))}" :
                      ""
                  ]
                ),
                parameter(
                  "assets/air_defence.png", "Air defence", 
                  ["Active personnel: ${getShortNumberForm(currentArmySettings['Litzórum']!.airDefenceAmount.round())}"]
                ),
                parameter(
                  "assets/frontline.png", "Frontline", 
                  ["Active personnel: ${getShortNumberForm(currentArmySettings['Litzórum']!.frontlineAmount.round())}"]
                ),
                parameter(
                  "assets/home_front.png", "Back", 
                  ["Active personnel: ${getShortNumberForm(currentArmySettings['Litzórum']!.backAmount.round())}"]
                ),
                
                backButton(context),
              ]
            ), 
          ),
        )
      )    
    );
  }
}