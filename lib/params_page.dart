import 'shared_imports.dart';

class ParamsPage extends StatefulWidget {
  final String mode;
  const ParamsPage(this.mode, {super.key});

  @override
  State<ParamsPage> createState() => _ParamsPageState();
}

class _ParamsPageState extends State<ParamsPage> {

  Map<String, double> buildAndDestructionCosts = {
    "build_school": 1200.0,
    "destroy_school": 840.0,
    "build_university": 2000.0,
    "destroy_university": 1400.0,
    "build_research_center": 4000.0,
    "destroy_research_center": 2800.0,
  };

  Map<String, int> bigProjectsCosts = {
    "Mission \"Integra\"": 10000000,
    "Large Hadron Collider": 20000000,
    "Air Energy Plant": 30000000,
    "Human Genome Storage": 50000000,
    "Itir Miz nar Litzórum": 75000000,
  };

  // Get all ideologies
  Future getIdeologies() async {
    return Future.value(ideologiesBox.values);
  }

  // Get current ideology
  Future getIdeology() async {
    for (Ideology i in ideologiesBox.values) {
      if (i.isChosen == true) {
        currentIdeology = i;
      }
    }

    return Future.value(ideologiesBox.values);
  }

  // Get all ideologies
  Future chooseIdeology(String name) async {
    for (Ideology i in ideologiesBox.values) {
      if (i.name == name) {
        await ideologiesBox.put(
          i.key,
          Ideology(
            name: i.name, 
            bonuses: i.bonuses, 
            isChosen: true
          )
        );

        currentIdeology = i;
      } else {
        await ideologiesBox.put(
          i.key, 
          Ideology(
            name: i.name, 
            bonuses: i.bonuses, 
            isChosen: false
          )
        );
      }
    }

  }


  // Create ideology parameter
  Padding ideologyParameter(String headText, List<String> text, bool isChosen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 63, 63, 63),
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),

          child: Row(
            children: [

              Container(
                width: MediaQuery.of(context).size.width / 1.24,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 159, 145, 110),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                ),
                child: Row(
                  children: [
                    Image.asset("assets/ideologies/${headText}_ideology.png", height: 90, width: 90),
                    
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
                          fontSize: 14, color: Color.fromARGB(255, 63, 63, 63),
                          fontFamily: "Monda",
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
                      if (currentGame.reigningYears % 10 == 0) {
                        chooseIdeology(headText);
                        setState(() {});
                      } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("You can't change ideology within 10 years"),
                          ));
                      }
                      
                    },
                    icon: Image.asset(isChosen == true ? "assets/accept_icon.png" : "assets/cancel_icon.png", height: 22)
                  ),

                ]
              ),

            ],
          )
        )
      )
    );
  }


  // Create education parameter
  Padding educationParameter(String asset, String headText, List<String> text) {
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
                    Text(headText, style: const TextStyle(
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
                IconButton(
                  onPressed: () {
                    // Play the sound effect immediately
                    AudioService().playClick(); 
                    setState(() {
                      if (headText == "Schools") {
                        if (!(currentGame.budget - buildAndDestructionCosts["build_school"]!).isNegative) {
                          currentGame.schoolsNumber++;
                          currentGame.budget -= buildAndDestructionCosts["build_school"]!;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Not enough money"),
                          ));
                        }
                      } else if (headText == "Universities") {
                        if (!(currentGame.budget - buildAndDestructionCosts["build_university"]!).isNegative) {
                          currentGame.universitiesNumber++;
                          currentGame.budget -= buildAndDestructionCosts["build_university"]!;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Not enough money"),
                          ));
                        }
                      } 

                      
                      double el = (
                        ((currentGame.schoolsNumber + (currentGame.schoolsNumber * getIdeologyBonus("Science"))) * 500) + 
                        ((currentGame.universitiesNumber + (currentGame.universitiesNumber * getIdeologyBonus("Science"))) * 1000) + 
                        ((currentGame.researchCentersNumber + (currentGame.researchCentersNumber * getIdeologyBonus("Science"))) * 1500)
                        ) / currentGame.population;

                      currentGame.educationLevel = el > 1.0 ? 1.0 : el;
                    });
                  }, 
                  icon: Image.asset("assets/build_icon.png", height: 22)
                ),

                IconButton(
                  onPressed: () {
                    // Play the sound effect immediately
                    AudioService().playClick(); 
                    setState(() {
                      if (headText == "Schools") {
                        currentGame.schoolsNumber--;
                        currentGame.budget += buildAndDestructionCosts["destroy_school"]!;
                      } else if (headText == "Universities") {
                        currentGame.universitiesNumber--;
                        currentGame.budget += buildAndDestructionCosts["destroy_university"]!;
                      } 

                      double el = (
                        ((currentGame.schoolsNumber + (currentGame.schoolsNumber * getIdeologyBonus("Science"))) * 500) + 
                        ((currentGame.universitiesNumber + (currentGame.universitiesNumber * getIdeologyBonus("Science"))) * 1000) + 
                        ((currentGame.researchCentersNumber + (currentGame.researchCentersNumber * getIdeologyBonus("Science"))) * 1500)
                        ) / currentGame.population;

                      currentGame.educationLevel = el > 1.0 ? 1.0 : el;
                    });
                  }, 
                  icon: Image.asset("assets/destroy_icon.png", height: 22)
                ),
              ]
            ),
          ],
        )
      )
    );
  }


  // Create research parameter
  Padding researchParameter(String asset, String headText, List<String> text) {
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
                    Text(headText, style: const TextStyle(
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
                
                IconButton(
                  onPressed: () {
                    // Play the sound effect immediately
                    AudioService().playClick(); 
                    if (!(currentGame.budget - buildAndDestructionCosts["build_research_center"]!).isNegative) {
                      setState(() {
                        
                        currentGame.researchCentersNumber++;
                        currentGame.budget -= buildAndDestructionCosts["build_research_center"]!;
                        
                        double el = (
                          ((currentGame.schoolsNumber + (currentGame.schoolsNumber * getIdeologyBonus("Science"))) * 500) + 
                          ((currentGame.universitiesNumber + (currentGame.universitiesNumber * getIdeologyBonus("Science"))) * 1000) + 
                          ((currentGame.researchCentersNumber + (currentGame.researchCentersNumber * getIdeologyBonus("Science"))) * 1500)
                          ) / currentGame.population;

                        currentGame.educationLevel = el > 1.0 ? 1.0 : el;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Not enough money"),
                      ));
                    }
                  }, 
                  icon: Image.asset("assets/build_icon.png", height: 22)
                ),

                IconButton(
                  onPressed: () {
                    // Play the sound effect immediately
                    AudioService().playClick(); 
                    setState(() {
                      currentGame.researchCentersNumber--;
                      currentGame.budget += buildAndDestructionCosts["destroy_research_center"]!;
                      
                      double el = (
                        ((currentGame.schoolsNumber + (currentGame.schoolsNumber * getIdeologyBonus("Science"))) * 700) + 
                        ((currentGame.universitiesNumber + (currentGame.universitiesNumber * getIdeologyBonus("Science"))) * 1200) + 
                        ((currentGame.researchCentersNumber + (currentGame.researchCentersNumber * getIdeologyBonus("Science"))) * 1700)
                        ) / currentGame.population;

                      currentGame.educationLevel = el > 1.0 ? 1.0 : el;
                    });
                  }, 
                  icon: Image.asset("assets/destroy_icon.png", height: 22)
                ),
              ]
            ),
          ],
        )
      )
    );
  }


  // Create big projects parameter
  Padding bigProjectsParameter(String asset, String headText, List<String> text) {
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
                    Text(headText, style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 63, 63, 63),
                      fontFamily: "Monda-Bold",
                    )),
                    
                    Text("${text[0]}${text[1].substring(0, text[1].length - 6)}M", style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 63, 63, 63),
                      fontFamily: "Monda",
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
                      if (!currentGame.bigProjects.contains(headText)) {
                          if (!(currentGame.budget - bigProjectsCosts[headText]!).isNegative) {
                            setState(() {
                            
                            currentGame.bigProjects.add(headText);
                            
                            double el = (
                              ((currentGame.schoolsNumber + (currentGame.schoolsNumber * getIdeologyBonus("Science"))) * 500) + 
                              ((currentGame.universitiesNumber + (currentGame.universitiesNumber * getIdeologyBonus("Science"))) * 1000) + 
                              ((currentGame.researchCentersNumber + (currentGame.researchCentersNumber * getIdeologyBonus("Science"))) * 1500) +
                              ((currentGame.bigProjects.length + (currentGame.bigProjects.length * getIdeologyBonus("Science"))) * 2000)
                              ) / currentGame.population;

                            currentGame.educationLevel = el > 1.0 ? 1.0 : el;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Not enough money"),
                          ));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("You already built this"),
                        ));
                      }
                      
                      
                    }, 
                    icon: currentGame.bigProjects.contains(headText) ? 
                      Image.asset("assets/info_icon.png", height: 22) : 
                      Image.asset("assets/build_icon.png", height: 22)
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
        
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.fill,
            ),
          ), 
          child: FutureBuilder(
            future: getIdeologies(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      
                      if (widget.mode == "ideologies")
                        if (snapshot.hasData)
                          for (Ideology i in snapshot.data)
                            ideologyParameter(i.name, i.bonuses.keys.toList(), i.isChosen),
                      
                      if (widget.mode == "education") 
                        educationParameter(
                          "assets/school.png", "Schools", 
                          ["Amount: ${currentGame.schoolsNumber}"]
                        ),

                      if (widget.mode == "education") 
                        educationParameter(
                          "assets/university.png", "Universities", 
                          ["Amount: ${currentGame.universitiesNumber}"]
                        ),

                      if (widget.mode == "research") 
                        researchParameter(
                          "assets/research_center.png", "Research centers", 
                          ["Amount: ${currentGame.researchCentersNumber}"]
                        ),

                      if (widget.mode == "big_projects") 
                        for(var i in bigProjectsCosts.entries)
                          bigProjectsParameter(
                            "assets/big_project_${bigProjectsCosts.keys.toList().indexOf(i.key)+1}.png", i.key, 
                            ["Cost: ", "${i.value}"]
                          ),

                      backButton(context),
                    ]
                  ), 
                ),
              );
            }
          ),
        ),
      );
  }
}