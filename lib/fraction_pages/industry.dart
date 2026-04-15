import 'package:litzorum/services/shared_imports.dart';
import 'package:litzorum/services/translation_service.dart';

class Industry extends StatefulWidget {
  const Industry({super.key});

  @override
  State<Industry> createState() => _IndustryState();
}

class _IndustryState extends State<Industry> {

  Map<String, double> buildAndDestructionCosts = {
    "build_heavy_industry": 5000.0,
    "destroy_heavy_industry": 3500.0,
    "build_light_industry": 2500.0,
    "destroy_light_industry": 1750.0,
    "build_farm": 1000.0,
    "destroy_farm": 700.0,
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

        child: Row(
          children: [

            Container(
              width: MediaQuery.of(context).size.width / 1.24,
              height: 96,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 159, 145, 110),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
              ),
              child: Row(
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
                IconButton(
                  onPressed: () {
                    // Play the sound effect immediately
                    AudioService().playClick(); 
                    setState(() {
                      if (headText == "Heavy industry") {
                        if (!(currentGame.budget - buildAndDestructionCosts["build_heavy_industry"]!).isNegative) {
                          currentGame.budget -= buildAndDestructionCosts["build_heavy_industry"]!;
                          currentGame.heavyIndustryFactoriesNumber++;
                          currentGame.heavyIndustryGoodsOutput = 3*(currentGame.heavyIndustryFactoriesNumber + (currentGame.heavyIndustryFactoriesNumber * getIdeologyBonus("Industry")));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Not enough money"),
                          ));
                        }
                      } else if (headText == "Light industry") {
                        if (!(currentGame.budget - buildAndDestructionCosts["build_light_industry"]!).isNegative) {
                          currentGame.lightIndustryFactoriesNumber++;
                          currentGame.budget -= buildAndDestructionCosts["build_light_industry"]!;
                          currentGame.lightIndustryGoodsOutput = 2*(currentGame.lightIndustryFactoriesNumber + (currentGame.lightIndustryFactoriesNumber * getIdeologyBonus("Industry")));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Not enough money"),
                          ));
                        }
                      } else if (headText == "Agriculture") {
                        if (!(currentGame.budget - buildAndDestructionCosts["build_farm"]!).isNegative) {
                          currentGame.agricultureFarmsNumber++;
                          currentGame.budget -= buildAndDestructionCosts["build_farm"]!;
                          currentGame.agricultureFarmsGoodsOutput = 1*(currentGame.agricultureFarmsNumber + (currentGame.agricultureFarmsNumber * getIdeologyBonus("Industry")));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Not enough money"),
                          ));
                        }
                      } 
                    });
                  }, 
                  icon: Image.asset("assets/buttons/build_icon.png", height: 22)
                ),

                IconButton(
                  onPressed: () {
                    // Play the sound effect immediately
                    AudioService().playClick(); 
                    setState(() {
                      if (headText == "Heavy industry") {
                        currentGame.heavyIndustryFactoriesNumber--;
                        currentGame.budget += buildAndDestructionCosts["destroy_heavy_industry"]!;
                        currentGame.heavyIndustryGoodsOutput = currentGame.heavyIndustryFactoriesNumber + (currentGame.heavyIndustryFactoriesNumber * getIdeologyBonus("Industry"));
                        
                      } else if (headText == "Light industry") {
                        currentGame.lightIndustryFactoriesNumber--;
                        currentGame.budget += buildAndDestructionCosts["destroy_light_industry"]!;
                        currentGame.lightIndustryGoodsOutput = currentGame.lightIndustryFactoriesNumber + (currentGame.lightIndustryFactoriesNumber * getIdeologyBonus("Industry"));
                        
                      } else if (headText == "Agriculture") {
                        currentGame.agricultureFarmsNumber--;
                        currentGame.budget += buildAndDestructionCosts["destroy_farm"]!;
                        currentGame.agricultureFarmsGoodsOutput = currentGame.agricultureFarmsNumber + (currentGame.agricultureFarmsNumber * getIdeologyBonus("Industry"));
                      } 
                    });
                  }, 
                  icon: Image.asset("assets/buttons/destroy_icon.png", height: 22)
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
              image: AssetImage("assets/other/background.png"), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              parameter(
                "assets/buttons/heavy_industry.png", 
                "Heavy industry", 
                ["${'Factories'.tr}: ${currentGame.heavyIndustryFactoriesNumber}", 
                "${'Goods output'.tr}: ${double.parse(currentGame.heavyIndustryGoodsOutput.toStringAsFixed(2))}"]),
              parameter(
                "assets/buttons/light_industry.png", 
                "Light industry", 
                ["${'Factories'.tr}: ${currentGame.lightIndustryFactoriesNumber}", 
                "${'Goods output'.tr}: ${double.parse(currentGame.lightIndustryGoodsOutput.toStringAsFixed(2))}"]),
              parameter(
                "assets/buttons/agriculture.png", 
                "Agriculture", 
                ["${'Farms'.tr}: ${currentGame.agricultureFarmsNumber}", 
                "${'Goods output'.tr}: ${double.parse(currentGame.agricultureFarmsGoodsOutput.toStringAsFixed(2))}"]),

              backButton(context),
            ]
          ), 
        ),
      )      
    );
  }
}