import 'services/shared_imports.dart';

/// A page displayed at the end of the game session.
/// 
/// The background artwork changes dynamically based on the achieved [type] 
/// of ending (e.g., military, cultural, etc.).
class EndingPage extends StatefulWidget {
  /// The specific ending category achieved by the player.
  final String type;
   const EndingPage({super.key, required this.type});

  @override
  State<EndingPage> createState() => _EndingPageState();
}

class _EndingPageState extends State<EndingPage> {
  /// Player instance dedicated to this page's background music.
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
  
    // 1. Останавливаем общую музыку через синглтон
    AudioService().stopMainTheme(); 
    
    // 2. Запускаем музыку эндинга (твой старый код)
    _audioPlayer = AudioPlayer();
    _playEndingMusic();
  }

  @override
  void dispose() {
    // Stops the music and releases resources when the widget is removed from the tree
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Initializes and plays the ending theme music in a loop.
  Future<void> _playEndingMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    String musicPath = _getMusicPath();
    
    await _audioPlayer.play(AssetSource(musicPath));
  }

  /// Returns the music asset path relative to the 'assets' folder.
  /// 
  /// Different tracks are assigned to 'good' and 'bad' ending categories.
  String _getMusicPath() {
    switch (widget.type) {
      case "cultural":
        return "audio/cultural.mp3";
      case "uberprogressivism":
        return "audio/uberprogressivism_v2.mp3";
      case "uberhedonism":
        return "audio/uberhedonism.mp3";
      case "military":
        return "audio/military.mp3";
      case "science":
        return "audio/science.mp3";
      case "mitsulon":
        return "audio/uberprogressivism_v1.mp3";

      case "revolution":
        return "audio/bad_ending.mp3";
      case "hidden_imrenia":
        return "audio/alien_imrenia.mp3";
        
      default:
        return "audio/bad_ending.mp3";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 173, 173, 173),
     
      body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_getBackgroundImagePath()), 
              fit: BoxFit.cover
            ),
          ),
          child: Center(
            child: IconButton(
              // Offset the button downwards to avoid obscuring the center of the art
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height/2.5
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent, 
              icon: Image.asset(
                scale: 2,
                "assets/back_to_menu_button.png"
              ), 
              onPressed: () {
                // Play the sound effect immediately
                AudioService().playClick(); 
                // Restart the main theme before leaving the ending screen
                AudioService().playMainTheme(); 

                // Return to the main menu by popping until the start screen route
                Navigator.of(context).popUntil(
                  ModalRoute.withName("start_screen")
                );
              }
            ), 
          ),
          
      )
    );
  }


  /// Maps the [type] string to its corresponding asset path.
  /// 
  /// Defaults to the revolution asset if the type is unrecognized.
  String _getBackgroundImagePath() {
    switch (widget.type) {
      case "military":
        return "assets/endings/military.png";
      case "cultural":
        return "assets/endings/cultural.png";
      case "revolution":
        return "assets/endings/revolution.png";
      case "uberhedonism":
        return "assets/endings/uberhedonism.png";
      case "uberprogressivism":
        return "assets/endings/uberprogressivism.png";
      case "science":
        return "assets/endings/science.png";
      case "hidden_imrenia":
        return "assets/endings/hidden_imrenia.png";
      case "mitsulon":
        return "assets/endings/mitsulon.png";
      default:
        return "assets/endings/revolution.png";
    }
  }
}