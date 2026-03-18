import 'shared_imports.dart';

/// The initial screen of the game, providing access to main menu options.
/// 
/// Includes navigation to new game, settings, and application exit functionality.
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    // Start the main theme only when the menu is displayed
    _initializeMusic();
  }

  /// Sets the volume from saved settings and starts playback.
  Future<void> _initializeMusic() async {
    final settings = settingsBox.get("settings0");
    double volume = 0.5;

    if (settings != null) {
      volume = double.tryParse(settings.settings["music_volume"] ?? "0.5") ?? 0.5;
    }

    // Apply the preferred volume before playing
    await AudioService().setVolume(volume);
    await AudioService().playMainTheme();
    //await audioService.playMainTheme();

  }

  /// Builds the 'New Game' button to initiate a fresh session.
  SizedBox _newGameButton(BuildContext context) => SizedBox(
    height: 75, width: 300,
  
    child: IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,

      onPressed: () {
        // Play the sound effect immediately
        AudioService().playClick(); 
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder:(BuildContext context) => const LoadSaveScreen()
          )
        );
      }, 
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset("assets/new_game.png")
        ),
      )
    );

  /// Builds the 'Continue' button to resume the last saved session.
  SizedBox _continueButton(BuildContext context) => SizedBox(
    height: 75, width: 300,
  
    child: IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,

      onPressed: () {
        // Play the sound effect immediately
        AudioService().playClick(); 
        Navigator.push(
          context, 
          MaterialPageRoute(builder: 
            (BuildContext context) => const LoadSaveScreen()
          )
        );
      }, 
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset("assets/continue.png")
        ),
      ),  
    );

  /// Builds the 'Settings' button to navigate to the options menu.
  SizedBox _settingsButton(BuildContext context) => SizedBox(
    height: 75, width: 300,
  
    child: IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,

      iconSize: MediaQuery.of(context).size.width /2,
      onPressed: () {
        // Play the sound effect immediately
        AudioService().playClick(); 
        Navigator.push(context, 
          MaterialPageRoute(builder: 
            (BuildContext context) => const SettingsPage()
          )
        );
      }, 
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset("assets/settings.png")
        ),
      )
    );

  /// Builds the 'About' button which currently pops the context.
  SizedBox _aboutButton(BuildContext context) => SizedBox(
    height: 75, width: 300,
  
    child: IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,

      iconSize: MediaQuery.of(context).size.width /2,
      onPressed: () {
        // Play the sound effect immediately
        AudioService().playClick(); 
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const EndingPage(type: "uberhedonism")));
      }, 
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset("assets/about.png")
        ),
      )
    );

  /// Builds the 'Quit' button to close all Hive boxes and exit the app.
  SizedBox _quitButton(BuildContext context) => SizedBox(
    height: 75, width: 300,
  
    child: IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      alignment: Alignment.center,

      iconSize: MediaQuery.of(context).size.width /2,
      onPressed: () {
        // Play the sound effect immediately
        AudioService().playClick(); 
        gameBox.close();
        ideologiesBox.close();
        countriesArmiesBox.close();
        gameStatsBox.close();
        settingsBox.close();
        exit(0);
      }, 
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset("assets/quit.png")
        ),
      )
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 173, 173, 173),
      
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            children: [
              // Main Game Logo
              Image.asset(
                "assets/Litzorum.png", 
                width: MediaQuery.of(context).size.width / 4, 
                height: MediaQuery.of(context).size.height / 4
              ),

              const Text(
                "Litzórum",
                style: TextStyle(
                  fontFamily: "Monda-Bold",
                  fontSize: 25
                )
              ),

              _newGameButton(context),
              _continueButton(context),
              _settingsButton(context),
              _aboutButton(context),
              _quitButton(context)
              
            ]
          ), 
        )
      )      
    );
  }
}