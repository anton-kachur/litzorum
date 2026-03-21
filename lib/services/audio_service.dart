import '../shared_imports.dart';

/// A global service to manage background music and UI sound effects.
/// 
/// Uses separate players to allow simultaneous playback.
class AudioService {
  AudioService._internal() {
    _configureAudioContext();
  }
  
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  /// Player for long background loops.
  final AudioPlayer _mainPlayer = AudioPlayer();
  
  /// Dedicated player for short, low-latency sound effects.
  final AudioPlayer _sfxPlayer = AudioPlayer();

  /// Global audio configuration to prevent sounds from interrupting each other.
  void _configureAudioContext() {
    AudioPlayer.global.setAudioContext(AudioContext(
      android: const AudioContextAndroid(
        // This prevents the click from stopping the background music
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.game,
        audioFocus: AndroidAudioFocus.none, 
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.ambient,
      ),
    ));
  }

  /// Plays a short interface click sound using SFX volume settings.
  Future<void> playClick() async {
    final settings = settingsBox.get("settings0");
    double volume = 0.9;
    
    if (settings != null) {
      volume = double.tryParse(settings.settings["sfx_volume"] ?? "0.9") ?? 0.9;
    }

    // ВАЖНО: Останавливаем плеер перед новым проигрыванием.
    // Это "сбрасывает" его состояние для корректного повтора в lowLatency.
    await _sfxPlayer.stop();
    await _sfxPlayer.setVolume(volume);
    
    await _sfxPlayer.play(
      AssetSource("sounds/click.mp3"), 
      mode: PlayerMode.lowLatency,
    );
  }

  /// Starts the main game soundtrack in a loop.
  Future<void> playMainTheme() async {
    await _mainPlayer.setReleaseMode(ReleaseMode.loop);
    await _mainPlayer.play(AssetSource("audio/main_soundtrack_v2.mp3"));
  }

  /// Stops the main theme music playback.
  Future<void> stopMainTheme() async {
    await _mainPlayer.stop();
  }

  /// Sets the volume for the main soundtrack.
  Future<void> setVolume(double volume) async {
    await _mainPlayer.setVolume(volume);
  }
}
