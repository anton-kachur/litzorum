import 'package:litzorum/services/shared_imports.dart';
import 'package:litzorum/services/translation_service.dart';

class Science extends StatefulWidget {
  const Science({super.key});

  @override
  State<Science> createState() => _ScienceState();
}

class _ScienceState extends State<Science> {
  
  Map<String, String> toolTips = {
    "Education" : "",
    "Research" : "",
    "Big projects" : "",
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

            Column(
              children: [
                
                infoButton(toolTips[headText]!, true),

                IconButton(
                  onPressed: () {
                    // Play the sound effect immediately
                    AudioService().playClick(); 
                    if (headText == "Education") {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ParamsPage("education")));
                    } else if (headText == "Research") {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ParamsPage("research")));
                    } else if (headText == "Big projects") {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ParamsPage("big_projects")));
                    }
                    
                  }, 
                  icon: Image.asset("assets/expand_icon.png", height: 22)
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
              image: AssetImage("assets/background.png"), fit: BoxFit.fill),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              parameter("assets/education.png", "Education", ["${double.parse(currentGame.educationLevel.toStringAsFixed(3))}%"]),
              parameter("assets/research.png", "Research", ["${'Research centers'.tr}: ${currentGame.researchCentersNumber}"]),
              parameter("assets/big_projects.png", "Big projects", ["${'Already have'.tr}: ${currentGame.bigProjects.length}"]),

              backButton(context),
            ]
          ), 
        ),
      )     
    );
  }
}