import 'package:litzorum/services/shared_imports.dart';
import 'package:litzorum/services/translation_service.dart';

/// The central government management screen for overseeing national affairs.
/// 
/// This page handles core state mechanics, including ideology selection, 
/// population monitoring, leader popularity, and the central bank's currency 
/// exchange system for converting goods into budget.
class Government extends StatefulWidget {
  const Government({super.key});

  @override
  State<Government> createState() => _GovernmentState();
}

class _GovernmentState extends State<Government> {
  // Tooltips describing various government parameters for the player.
  Map<String, String> toolTips = {
    "Ideology" : "Ideologies give boost to fractions",
    "Leader's popularity" : "Depends on life quality, purchasing power and overall culture level",
    "Population" : "Population of Litzórum. Can change depending on life quality and wars",
    "Bank of Litzórum" : "Exchange rate = goods / money. Can be stimulated by funding (1M to stimulate)",
    "Army": "Army of Litzórum. You can recruit units for some money"
  };

  // Asynchronously retrieves the currently active state ideology from the Hive database.
  // Sets the [currentIdeology] global variable and updates the UI state.
  Future getIdeology() async {
    var box = await Hive.openBox("ideologies");

    for (Ideology i in box.values) {
      if (i.isChosen == true) {
        currentIdeology = i;
        setState(() {
          
        });
      }
    }

    return Future.value(box.values);
  }

  // Generates a UI parameter card for specific government metrics.
  // 
  // [asset] - Path to the visual icon.
  // [headText] - Title of the parameter (e.g., "Exchange" or "Population").
  // [text] - List of strings displaying current values or descriptions.
  Padding parameter(String asset, String headText, List<String> text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: headText == "Exchange" ? 180 : 96,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 63, 63, 63),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),

        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.24,
              // Dynamic height adjustment for the Exchange UI block
              height: headText == "Exchange" ? 180 : 96,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 159, 145, 110),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), 
                  bottomLeft: Radius.circular(10)
                )
              ),
              child: Row(
                children: [
                  Container(
                    alignment: AlignmentGeometry.centerLeft,
                    height: headText == "Exchange" ? 200 : 96,
                    width: headText == "Exchange" ? 100 : 96,
                    child: Image.asset(asset),
                  ),
                  
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(headText.tr, style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 63, 63, 63),
                        fontFamily: "Monda-Bold",
                      )),
                      
                      for (String i in text) 
                        Text(i, style: const TextStyle(
                          fontSize: 16, color: Color.fromARGB(255, 63, 63, 63),
                          fontFamily: "Monda",
                        )),

                      if (headText == "Exchange")
                        // Special UI layout for the goods exchange system
                        SizedBox(
                          width: MediaQuery.of(context).size.width/1.9,
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.spaceAround,
                            children: [
                              increaseExchangeButton("+100"),
                              increaseExchangeButton("+1k"),
                              increaseExchangeButton("+10k"),
                              increaseExchangeButton("-100"),
                              increaseExchangeButton("-1k"),
                              increaseExchangeButton("-10k"),
                            ],
                          ),
                        ),
                  ]),
                ],
              ),
            ),

            // Action column for buttons (Info, Expand, or Exchange actions)
            Column(
              children: [
                
                if (headText != "Exchange")
                  infoButton(toolTips[headText]!, true),

                // Logic for the goods-to-budget currency exchange
                if (headText == "Exchange")
                  IconButton(
                    onPressed: () {
                      // Play the sound effect immediately
                      AudioService().playClick(); 
                      setState(() {
                        currentgameStats.stats["exchange_amount"] = "${
                          int.parse(currentgameStats.stats["exchange_amount"]!) + 1
                          }";
                      });
                    }, 
                    icon: Image.asset("assets/add_icon.png", height: 22)
                  ),

                if (headText == "Exchange")
                  IconButton(
                    onPressed: () {
                      // Play the sound effect immediately
                      AudioService().playClick(); 
                      if (
                        int.parse(currentgameStats.stats["exchange_amount"]!) - 1 <= 0
                      ) {
                      } else {
                        setState(() {
                          currentgameStats.stats["exchange_amount"] = "${
                            int.parse(currentgameStats.stats["exchange_amount"]!) - 1
                            }";
                        });
                      }
                    }, 
                    icon: Image.asset("assets/minus_icon.png", height: 22)
                  ),

                if (headText == "Exchange")
                  IconButton(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    onPressed: () {
                      // Play the sound effect immediately
                      AudioService().playClick(); 
                      if (currentGame.goods == 0.0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Not enough goods to exchange"),
                          ));
                        
                      } else {
                        setState(() {
                          if (
                            currentGame.goods - 
                            double.parse(currentgameStats.stats["exchange_amount"]!) >= 0
                          ) {
                            currentGame.goods -= int.parse(
                              currentgameStats.stats["exchange_amount"]!
                            ); 
                            currentGame.budget += (
                              double.parse(currentGame.exchangeRate[0]) * 
                              int.parse(currentgameStats.stats["exchange_amount"]!)
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Not enough goods to exchange"),
                              ));
                          }
                        });
                      }
                    }, 
                    icon: Image.asset("assets/exchange_icon.png", height: 22)
                  ),

                if (headText == "Ideology")
                  IconButton(
                    onPressed: () {
                      // Play the sound effect immediately
                      AudioService().playClick(); 
                      Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) => const ParamsPage("ideologies")));
                    }, 
                    icon: Image.asset("assets/expand_icon.png", height: 22)
                  ),

                if (headText == "Bank of Litzórum")
                  IconButton(
                    onPressed: () { 
                      // Play the sound effect immediately
                      AudioService().playClick(); 
                      if (currentGame.budget < 1000000.0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Not enough money"),
                          ));
                      } else {
                        setState(() {
                          currentGame.budget -= 1000000.0; 
                          currentGame.exchangeRate = "${
                            double.parse(currentGame.exchangeRate[0]) + 1}/1";
                        });
                      }
                      
                    }, 
                    icon: Image.asset("assets/fund_icon.png", height: 22)
                  ),

                 if (headText == "Army")
                  IconButton(
                    onPressed: () { 
                      // Play the sound effect immediately
                      AudioService().playClick(); 
                      if (currentGame.budget < 2000.0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Not enough money"),
                          ));
                      } else if (currentGame.population <= 1000) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Not enough population. WHAT HAVE YOU DONE??!"
                            ),
                          ));
                      } else {
                        setState(() {
                          currentGame.budget -= 2000.0; 
                          currentArmySettings["Litzórum"]!.armyAmount += 1000.0;
                          currentGame.population -= 1000;
                        });
                      }
                      
                    }, 
                    icon: Image.asset("assets/fund_icon.png", height: 22)
                  ), 
              ]
            ),
          ]
        )
      )
    );
  }


  OutlinedButton increaseExchangeButton(String text) => OutlinedButton(      
    style: OutlinedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 192, 176, 135),
      shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(5.0),
      ),
      side: const BorderSide(
        color: Color.fromARGB(255, 63, 63, 63),
        width: 2.3,
        
      ),
    ),
    onPressed: () {
      // Play the sound effect immediately
      AudioService().playClick(); 
      setState(() {
        currentgameStats.stats["exchange_amount"] = 
          "${int.parse(currentgameStats.stats["exchange_amount"]!) + 
          int.parse(text.contains("k") ? 
            "${text.substring(0, text.length - 1)}000" : 
        text)}";
      });
    }, 
    child: Text(text, style: const TextStyle(
      fontSize: 10, color: Color.fromARGB(255, 63, 63, 63),
      fontFamily: "Monda-Bold",
    ))
  );


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getIdeology(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 173, 173, 173),
            
            appBar: statsAppBar(context),

            body: DecoratedBox(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background.png"), 
                    fit: BoxFit.cover
                  ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      parameter(
                        "assets/ideologies/${currentIdeology.name}_ideology.png", 
                        "Ideology", currentIdeology.bonuses.keys.toList()
                      ),
                      parameter(
                        "assets/rate.png", "Leader's popularity", 
                        ["${
                          double.parse(currentGame.leadersPopularity.toStringAsFixed(1))
                        }%"]
                      ),
                      parameter(
                        "assets/population.png", "Population", 
                        [(getShortNumberForm(currentGame.population))]
                      ),
                      parameter(
                        "assets/army_number.png", "Army", 
                        [getShortNumberForm(
                          currentArmySettings['Litzórum']!.armyAmount.round()
                        )]
                      ),
                      parameter(
                        "assets/money.png", "Bank of Litzórum", 
                        ["${"Budget".tr}: ${formatLongNumber(
                          currentGame.budget, isDouble: true
                        )}", 
                        "${"Exchange rate".tr}: ${currentGame.exchangeRate}"]
                      ),
                      parameter(
                        "assets/exchange.png", "Exchange", 
                        ["${"Goods for exchange".tr}:", "${
                          currentgameStats.stats["exchange_amount"]
                        }"], 
                      ),

                      backButton(context),
                    ]
                  ), 
                ),
              )
            )     
          );
        }
    );
  }
}