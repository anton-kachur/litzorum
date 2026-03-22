import 'package:litzorum/services/shared_imports.dart';
import 'package:litzorum/services/translation_service.dart';

/// The cultural development screen for managing national identity and soft power.
/// 
/// Provides controls to invest in high and mass culture, which directly impact 
/// the overall quality of life. Reaching the maximum cultural level triggers 
/// a unique "Cultural Victory" ending.
class Culture extends StatefulWidget {
  const Culture({super.key});

  @override
  State<Culture> createState() => _CultureState();
}

class _CultureState extends State<Culture> {
  // Dynamic expense calculation based on current ideology bonuses.
  double highCultureExpense = 100000.0 - (100000.0  * getIdeologyBonus("Culture"));
  double massCultureExpense = 50000.0 - (50000.0  * getIdeologyBonus("Culture"));

  late Map<String, String> toolTips;

  @override
  void initState() {
    // Initialize tooltips with calculated costs and descriptions.
    toolTips = {
      "Overall culture" : "Has impact on life quality",
      "High culture" : "$highCultureExpense to upgrade",
      "Mass culture" : "$massCultureExpense to upgrade",
    };
    super.initState();
  }

  // Builds a parameter card with an icon, statistics, and a funding button.
  // [asset] is the icon path, [headText] is the parameter name, and [text] is the stats list.
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
            // Main information container (icon and text data).
            Container(
              width: MediaQuery.of(context).size.width / 1.24,
              height: 96,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 159, 145, 110),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), 
                  bottomLeft: Radius.circular(10)
                )
              ),
              child: Wrap(
                children: [
                  Image.asset(asset, height: 96, width: 96),
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
                    
                  ]),
                ],
              ),
            ),

            // Interaction column containing information and action buttons.
            Column(
              children: [
                infoButton(toolTips[headText]!, true),

                if (headText != "Overall culture")
                  IconButton(
                    onPressed: () {
                      // Play the sound effect immediately
                      AudioService().playClick(); 

                      // Only show the fund button for specific 
                      // upgradeable parameters.
                      if (headText == "High culture") {
                        if (currentGame.budget < highCultureExpense) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Not enough money"),
                            ));
                        } else {
                          if (currentGame.highCultureLevel < 9.9) {
                            setState(() {
                              currentGame.budget -= highCultureExpense; 
                              currentGame.highCultureLevel += 0.1; 
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Max level"),
                              ));
                          }
                        }

                      // Handle mass culture upgrade logic.
                      } else if (headText == "Mass culture") {
                        if (currentGame.budget < massCultureExpense) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Not enough money"),
                            ));
                        } else {
                          if (currentGame.massCultureLevel < 9.9) {
                            setState(() {
                              currentGame.budget -= massCultureExpense; 
                              currentGame.massCultureLevel += 0.1;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Max level"),
                              ));
                          }
                        }
                      }
                      
                      // Recalculate combined culture level for global statistics.
                      currentGame.cultureLevel = double.parse(
                        ((currentGame.highCultureLevel + 
                        currentGame.massCultureLevel) / 2).toStringAsFixed(1)
                      );

                      // Update overall life quality index.
                      currentGame.lifeQuality = (currentGame.purchasingPower + 
                        currentGame.educationLevel + currentGame.cultureLevel
                        ) / 3;
                      
                      // Check for victory condition: cultural ending.
                      if (currentGame.cultureLevel == 10.0) {
                        saveGame();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("GG WP!!!"),
                          duration: Duration(seconds: 5),
                        ));
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (BuildContext context) => const EndingPage(
                              type: "cultural"
                            )
                          )
                        );
                      }

                    }, 
                    icon: Image.asset("assets/fund_icon.png", height: 22)
                  ),
              ]
            ),

          ],
        )
      )
    );
  }

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
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [

              parameter(
                "assets/overall_culture.png", "Overall culture", 
                ["${'Level'.tr}: ${
                  double.parse(currentGame.cultureLevel.toStringAsFixed(2))
                }"]
              ),
              parameter(
                "assets/high_culture.png", "High culture", 
                ["${'Level'.tr}: ${
                  double.parse(currentGame.highCultureLevel.toStringAsFixed(1))
                  }",
                "${'To next level'.tr}: ${
                  double.parse((currentGame.highCultureLevel.ceil() - 
                  currentGame.highCultureLevel ).toStringAsFixed(1))
                  }"]
              ),
              parameter(
                "assets/mass_culture.png", "Mass culture", 
                ["${'Level'.tr}: ${
                  double.parse(currentGame.massCultureLevel.toStringAsFixed(1))
                  }",
                "${'To next level'.tr}: ${
                  (currentGame.massCultureLevel.ceil() - 
                  currentGame.massCultureLevel).toStringAsFixed(1)
                  }"]
              ),

              backButton(context),
            ]
          ), 
        ),
      )    
    );
  }
}