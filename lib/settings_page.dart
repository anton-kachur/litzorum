import 'shared_imports.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /// Local map to hold settings during the session.
  Map<String, String> settings = {};
  
  /// Flag to prevent UI from rendering before data is loaded.
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// Loads settings from Hive once when the page opens.
  Future<void> _loadSettings() async {
    final data = settingsBox.get("settings0");
    if (data != null) {
      // Create a copy to avoid direct Hive object mutation during UI interaction
      settings = Map<String, String>.from(data.settings);
    }
    setState(() {
      _isLoaded = true;
    });
  }

  /// Persists the current [settings] map to Hive.
  Future<void> saveSettings(String playerName) async {
    await settingsBox.put(
      "settings0",
      Settings(
        settings: settings
      )
    );
  }

  /// Builds an SFX volume control with a functional [Slider].
  /// 
  /// Uses the exact same UI structure as the music volume parameter.
  Widget _buildSfxVolumeParameter(String asset, String title) {
    // Безопасно парсим громкость эффектов или ставим 0.5 по умолчанию
    double currentSfxVolume = double.tryParse(settings["sfx_volume"] ?? "0.5") ?? 0.5;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 96,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 63, 63, 63),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.24,
              height: 96,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 159, 145, 110),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), 
                  bottomLeft: Radius.circular(10)
                )
              ),
              child: Row(
                children: [
                  Image.asset(asset, height: 96, width: 96),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(
                        fontSize: 16, 
                        color: Color.fromARGB(255, 63, 63, 63),
                        fontFamily: "Monda-Bold",
                      )),

                      Container(
                        alignment: Alignment.centerLeft,
                        height: 62, 
                        width: MediaQuery.of(context).size.width / 1.88,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color.fromARGB(255, 63, 63, 63),
                            inactiveTrackColor: const Color.fromARGB(160, 63, 63, 63),
                            thumbColor: const Color.fromARGB(255, 85, 85, 85),
                            overlayColor: const Color.fromARGB(0, 0, 0, 0),
                            valueIndicatorColor: const Color.fromARGB(255, 63, 63, 63),
                            trackHeight: 6.0,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            trackShape: const RoundedRectSliderTrackShape(), 
                          ),
                          child: Slider(
                            value: currentSfxVolume,
                            onChanged: (double newValue) {
                              setState(() {
                                settings["sfx_volume"] = newValue.toStringAsFixed(2);
                              });
                            },
                            onChangeEnd: (double value) {
                              AudioService().playClick();
                              saveSettings(settings["player_name"]!);
                            },
                          ),
                        )
                      )
                    ]
                  ),
                ],
              ),
            ),
          ]
        )
      )
    );
  }

  /// Builds a volume control with a functional [Slider].
  Widget _buildVolumeParameter(String asset, String title) {
    // Convert String to double safely for the Slider widget
    double currentVolume = double.tryParse(settings["music_volume"] ?? "0.5") ?? 0.5;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 96,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 63, 63, 63),
            borderRadius: BorderRadius.all(Radius.circular(10))),
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
                      Text(title, style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 63, 63, 63),
                        fontFamily: "Monda-Bold",
                      )),

                      Container(
                        alignment: Alignment.centerLeft,
                        height: 62, 
                        width: MediaQuery.of(context).size.width / 1.88,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            // Колір активної частини (ліворуч від повзунка)
                            activeTrackColor: const Color.fromARGB(255, 63, 63, 63),
                            // Колір неактивної частини (задній план)
                            inactiveTrackColor: const Color.fromARGB(160, 63, 63, 63),
                            // Колір самого кружка (трохи світліше за 63, 63, 63)
                            thumbColor: const Color.fromARGB(255, 85, 85, 85),
                            // Колір "сяйва" при натисканні
                            overlayColor: const Color.fromARGB(0, 0, 0, 0),
                            valueIndicatorColor: const Color.fromARGB(255, 63, 63, 63),
                            
                            valueIndicatorTextStyle: const TextStyle(
                              color: Color.fromARGB(255, 159, 145, 110),
                              fontSize: 10.0,
                            ),
                            showValueIndicator: ShowValueIndicator.onDrag,
                            // Налаштування меж та форми
                            trackHeight: 6.0,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 12.0,
                            ),
                            // Якщо потрібна чітка рамка навколо треку, використовуємо кастомний Paint
                            trackShape: const RoundedRectSliderTrackShape(), 
                          ),
                          child: Slider(
                            value: currentVolume,
                            onChanged: (double newValue) {
                              // 1. Update UI immediately
                              setState(() {
                                settings["music_volume"] = newValue.toStringAsFixed(2);
                              });
                              // 2. Apply sound change in real-time
                              AudioService().setVolume(newValue);
                            },
                            onChangeEnd: (value) {
                              // 3. Save to disk only when user releases the slider
                              saveSettings(settings["player_name"]!);
                            },
                          ),
                        )
                      )
                    ]
                  ),
                ],
              ),
            ),
          ]
        )
      )
    );
  }

  /// Helper to build a text-based setting parameter (like Player Name).
  Widget _textParameter(String asset, String headText, List<String> textList) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 96,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 63, 63, 63),
            borderRadius: BorderRadius.all(Radius.circular(10))),
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
                      
                      Text(headText,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 63, 63, 63),
                          fontFamily: "Monda-Bold",
                        )),

                      for (String i in textList)
                        Text(i,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 63, 63, 63),
                            fontFamily: "Monda",
                          )),
                    ]
                  ),
                ],
              ),
            ),

            Column(
              children: [
                IconButton(
                  onPressed: () { 
                    // Play the sound effect immediately
                    AudioService().playClick(); 
                    _showNameEditDialog();
                  },
                  icon: Image.asset("assets/edit_icon.png", height: 22),
                ),
              ]
            ),
          ]
        )
      )
    );
  }

  /// Displays an [AlertDialog] to edit the player's name.
  void _showNameEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 159, 145, 110),
        title: const Text("Enter your name",
            style: TextStyle(fontFamily: "Monda-Bold", fontSize: 16)),
        content: TextFormField(
          initialValue: settings["player_name"],
          onChanged: (value) => settings["player_name"] = value,
          decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 63, 63, 63)),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel", style: TextStyle(color: Color.fromARGB(255, 63, 63, 63), fontFamily: "Monda-Regular", fontSize: 16)),
            onPressed: () {
              // Play the sound effect immediately
              AudioService().playClick(); 
              Navigator.of(context).pop();
            }
          ),

          TextButton(
            onPressed: () {
              // Play the sound effect immediately
              AudioService().playClick(); 
              saveSettings(settings["player_name"]!);
              Navigator.of(context).pop();
            },
            child: const Text("Save", style: TextStyle(color: Color.fromARGB(255, 63, 63, 63))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loader if Hive hasn't finished reading yet
    if (!_isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
          child: Column(
            children: [
              _textParameter("assets/player_name.png", "Player's name",
                      [settings["player_name"] ?? "Noname"]),
              // Your existing name parameter logic here
              _buildVolumeParameter("assets/music.png", "Music"),
              _buildSfxVolumeParameter("assets/sound.png", "Sounds"),
              const Spacer(),
              backButton(context),
            ],
          ),
        ),
      ),
    );
  }
}