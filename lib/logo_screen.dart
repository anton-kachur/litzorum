import 'package:litzorum/services/shared_imports.dart';

/// The application's entry point and splash screen featuring the studio logo.
/// 
/// Initializes the main app configuration, including the global navigation 
/// routes, and executes a smooth fade-in animation before transitioning 
/// the user to the main menu.
class LoadingLogoScreen extends StatelessWidget {
  const LoadingLogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        'start_screen': (context) => const StartScreen(),
        'load_save_screen':(context) => const LoadSaveScreen(),
        'government_page': (context) => const Government(),
        'people_page': (context) => const People(),
        'industry_page': (context) => const Industry(),
        'science_page': (context) => const Science(),
        'army_page': (context) => const Army(),
        'culture_page': (context) => const Culture(),
        'main_screen': (context) => const MainScreen(),
      },
      home: const StartLoading(),
    );
  }
}


class StartLoading extends StatefulWidget {
  const StartLoading({super.key});

  @override
  State<StartLoading> createState() => _StartLoadingState();
}

class _StartLoadingState extends State<StartLoading> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn
    );

    WidgetsBinding.instance.addPostFrameCallback((_)=>loopOnce(context));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> loopOnce(BuildContext context) async{
    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;

      await Future.delayed(const Duration(seconds: 1));

      if (!context.mounted) return;

      navigatorKey.currentState?.popAndPushNamed('start_screen');
    } on TickerCanceled {
      debugPrint("Animation was cancelled");
    } catch (e) {
      debugPrint("Other error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 45, 45, 45),
     
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/Senkojori_prod_name.png",
                width: MediaQuery.of(context).size.width / 3,  
                height: MediaQuery.of(context).size.height / 3,  
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}