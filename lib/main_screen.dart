import 'shared_imports.dart';

/// The main dashboard screen showing faction icons and navigation.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    super.initState();
    _getIdeology();
  }

  /// Finds and sets the currently active ideology from the Hive box.
  void _getIdeology() {
    for (Ideology i in ideologiesBox.values) {
      if (i.isChosen) {
        setState(() {
          currentIdeology = i;
        });
        break;
      }
    }
  }

  /// Builds a faction button that plays a sound and navigates to [route].
  IconButton _buildFractionButton(String asset, String route) => IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () {
        // Play the sound effect immediately
        AudioService().playClick(); 
        Navigator.of(context).pushNamed(route);
      }, 
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          scale: 4.67,
          asset
        )
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
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFractionButton("assets/government.png", "government_page"),
                  _buildFractionButton("assets/people.png", "people_page"),
                ],
              ),
            
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFractionButton("assets/industry.png", "industry_page"),
                  _buildFractionButton("assets/science.png", "science_page"),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFractionButton("assets/army.png", "army_page"),
                  _buildFractionButton("assets/culture.png", "culture_page"),
                ],
              ),

            ]
          ), 
        ),
      ), 
      
      bottomNavigationBar: bottomBar(context),
              
    );
  }
}