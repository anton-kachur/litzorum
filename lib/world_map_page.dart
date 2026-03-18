import 'shared_imports.dart';

class WorldMapPage extends StatefulWidget {
  const WorldMapPage({super.key});

  @override
  State<WorldMapPage> createState() => _WorldMapPageState();
}

class _WorldMapPageState extends State<WorldMapPage> {
  final transformationController = TransformationController();
  final Map<String, List<double>> _countries = {
    "Litzórum": [257, 277, -30, 17, 139],
    "Imrenia": [248, 236, 0, 6, 184],
    "Semnuria": [300, 200, 35, 19, 139],
    "Vojtrajt": [340, 307, 0, 9, 184],
    "Arga": [250, 341, 0, 8, 184],
    "Ștemerkenź": [208, 261, 7, 7, 184],
    "Serkamenia": [191, 291, 50, 7, 184],
    "Vajläulä": [230, 145, -15, 15, 139],
    "Kamraiștanź": [135, 175, -77, 9, 184],
    "Zrașpolj\nRiatst": [142, 260, -77, 14, 139],
  };

  void showDiplomacyDialog(String countryName, BuildContext context) async {
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(255, 63, 63, 63), width: 2),
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          backgroundColor: const Color.fromARGB(237, 159, 145, 110), // Кастомний фон діалогу
          title: Row(
            children: [
              Text(
                countryName, 
                style: const TextStyle(
                  color:  Color.fromARGB(255, 63, 63, 63),
                  fontFamily: "Monda-Bold"
                )
              ),

              infoButton("No information", false),
            ]
          ),
          
          children: [
            if (!currentArmySettings[countryName]!.isConquired)
              buildOption(context, 'Declare war', countryName),

            buildOption(context, 'Propose trade', countryName),
            buildOption(context, 'Propose union', countryName),
          ],
        );
      },
    );
  }

  // Помічник для створення варіантів з межами
  Widget buildOption(BuildContext context, String text, String countryName) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 192, 176, 135),
        border: Border.all(color: const Color.fromARGB(255, 63, 63, 63), width: 2),
        borderRadius: BorderRadius.circular(3)
      ),
      
      child: SimpleDialogOption(
        onPressed: () {
          // Play the sound effect immediately
          AudioService().playClick(); 
          if (text == "Declare war") {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WarPage(countryName)));
          } else if (text == "Propose trade") {
            executeTrade(countryName);
          } else {
            executeUnion(countryName);
          }
        },
        child: Text(
          text, 
          style: const TextStyle(fontFamily: "Monda-Regular", fontSize: 16)),
        ),
    );
  }


  void executeTrade(String countryName) {
    final countryData = currentArmySettings[countryName]!;

    setState(() {
      if (countryData.relations >= 20) {
        currentGame.budget += countryData.tradeMoneyAmount;
      } else {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$countryName refused to trade with you"),
          duration: const Duration(seconds: 5),
        ));
      }
    });
  }


  void executeUnion(String countryName) {
    final countryData = currentArmySettings[countryName]!;

    setState(() {
      if (countryData.relations >= 60) {
        countryData.isInUnion = !countryData.isInUnion;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("$countryName refused to join your union"),
          duration: const Duration(seconds: 5),
        ));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 173, 173, 173),
      
      appBar: statsAppBar(context),
     
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 63, 63, 63),
                width: 4,
              ),
            ),

            child: InteractiveViewer(
              transformationController: transformationController, // pass the transformation controller
              onInteractionEnd: (details) {
                setState(() {
                  transformationController.toScene(Offset.zero); // return to normal size after scaling has ended
                });
              },
              minScale: 0.1, // min scale
              maxScale: 5.0, // max scale
              scaleEnabled: true,
              panEnabled: true,
              child: Stack(
                children: [
                  
                  ClipRRect(
                    child: Image.asset(
                      "assets/map.png",
                      fit: BoxFit.fill,
                    )
                  ), 

                  for (var country in _countries.entries) 
                    Positioned(
                      left: country.value[0],
                      top: country.value[1],
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Відображаємо PNG мітку, якщо країна захоплена
                          if (currentArmySettings[country.key]?.isConquired ?? false)
                            Opacity(
                              opacity: 0.97, // Щоб мітка не перекривала назву повністю
                              child: Image.asset(
                                "assets/coquired_mark.png", // Ваша PNG мітка
                                width: country.value[3] * 3, // Масштабуємо під розмір тексту
                              ),
                            ),
                          
                          TextButton(
                            style: TextButton.styleFrom(backgroundColor: Colors.transparent),
                            onPressed: () {
                              // Play the sound effect immediately
                              AudioService().playClick(); 
                              showDiplomacyDialog(country.key, context);
                            },
                            child: RotationTransition(
                              turns: AlwaysStoppedAnimation(country.value[2] / 360),
                              child: Text(
                                country.key, 
                                style: TextStyle(
                                  fontSize: country.value[3], 
                                  color: Color.fromARGB(country.value[4].toInt(), 63, 63, 63),
                                  fontFamily: "Monda-Bold"
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              
              
            )
          ), 

          backButton(context),
        ]
      )
    );
  }
}