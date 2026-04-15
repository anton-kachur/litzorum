import 'package:litzorum/services/translation_service.dart';

import 'services/shared_imports.dart';

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
  }

  /// Builds a menu button with a background image and an overlaid translated label.
  Widget _menuButton({
    required String label, 
    required String assetPath, 
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 75,
      width: 300,
      child: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          AudioService().playClick();
          onPressed();
        },
        // Using of Stack to overlay translated text on top of the button asset
        icon: Stack(
          alignment: Alignment.center,
          children: [
            // Background image without text
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                assetPath, 
              ),
            ),
            // Translated text layer
            Text(
              label,
              style: const TextStyle(
                fontFamily: "Roboto-Bold",
                fontSize: 19,
                color: Color.fromARGB(255, 205, 192, 68),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the 'New Game' button.
  Widget _newGameButton(BuildContext context) => _menuButton(
    label: "New game".tr,
    assetPath: "assets/buttons/blank.png",
    onPressed: () {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const LoadSaveScreen()),
      );
    },
  );

  /// Builds the 'Continue' button.
  Widget _continueButton(BuildContext context) => _menuButton(
    label: "Continue".tr,
    assetPath: "assets/buttons/blank.png",
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoadSaveScreen()),
      );
    },
  );

  /// Builds the 'Settings' button.
  Widget _settingsButton(BuildContext context) => _menuButton(
    label: "Settings".tr,
    assetPath: "assets/buttons/blank.png",
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettingsPage()),
      );
    },
  );

  /// Builds the 'About' button.
  Widget _aboutButton(BuildContext context) => _menuButton(
    label: "About".tr,
    assetPath: "assets/buttons/blank.png",
    onPressed: () {
    },
  );

  /// Builds the 'Quit' button.
  Widget _quitButton(BuildContext context) => _menuButton(
    label: "Quit".tr,
    assetPath: "assets/buttons/blank.png",
    onPressed: () {
      gameBox.close();
      ideologiesBox.close();
      countriesArmiesBox.close();
      gameStatsBox.close();
      settingsBox.close();
      exit(0);
    },
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: settingsBox.listenable(),
        builder: (context, box, _) {
          return Scaffold(
          backgroundColor: const Color.fromARGB(255, 173, 173, 173),
          
          body: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/other/background.png"), fit: BoxFit.cover),
            ),
            child: Center(
              child: Column(
                children: [
                  // Game logo
                  Image.asset(
                    "assets/buttons/Litzorum.png",
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.height / 4,
                  ),

                  // Game name
                  const Text(
                    "Litzórum",
                    style: TextStyle(
                      fontFamily: "Roboto-Bold",
                      fontSize: 25,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Menu buttons
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
    );
  }
}