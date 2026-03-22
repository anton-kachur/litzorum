import 'services/shared_imports.dart';

class GameStatsPage extends StatefulWidget {
  const GameStatsPage({super.key});

  @override
  State<GameStatsPage> createState() => _GameStatsPageState();
}

class _GameStatsPageState extends State<GameStatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 173, 173, 173),
      
      appBar: statsAppBar(context),
     
      body: SingleChildScrollView(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.png"), fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Game statistics", style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 63, 63, 63),
                  fontFamily: "Monda-Bold",
                )),
                
                Text(currentGame.toString(), style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 63, 63, 63),
                  fontFamily: "Monda",
                ))
              ],
            )
          )
        )
      )
    );
  }
}