import 'package:litzorum/services/shared_imports.dart';
import 'package:litzorum/services/translation_service.dart';

class People extends StatefulWidget {
  const People({super.key});

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {

  Map<String, String> toolTips = {
    "Education level" : "Depends on schools and universities",
    "Purchasing power" : "Purchasing power = money / population",
    "Life quality" : "Life quality = Purchasing power * Education level * Culture level",
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
                children: [
                  Image.asset(asset, height: 96, width: 96),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(headText.tr, style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 63, 63, 63),
                      fontFamily: "Roboto-Bold",
                    )),
                    
                    for (String i in text) 
                      Text(i, style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 63, 63, 63),
                        fontFamily: "Roboto",
                      )),
                    
                  ]),
                ],
              ),
            ),

            Column(
              children: [
                infoButton(toolTips[headText]!, true),
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
              image: AssetImage("assets/other/background.png"), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              parameter("assets/buttons/education.png", "Education level", ["${double.parse(currentGame.educationLevel.toStringAsFixed(3))}%"]),
              parameter("assets/buttons/purchasing_power.png", "Purchasing power", ["${double.parse(currentGame.purchasingPower.toStringAsFixed(3))}%"]),
              parameter("assets/buttons/life_quality.png", "Life quality", ["${double.parse(currentGame.lifeQuality.toStringAsFixed(3))}%"]),

              backButton(context),
            ]
          ), 
        ),
      )    
    );
  }
}