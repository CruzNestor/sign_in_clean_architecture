import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'injection_container.dart' as di;
import 'src/features/auth/presentation/pages/sign_in_page.dart';
import 'src/features/auth/presentation/pages/welcome_page.dart';
import 'src/features/home/presentation/pages/home_page.dart';

int? currentUserId;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  currentUserId = prefs.getInt('currentUserId');
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: currentUserId != null && currentUserId != 0
        ? const HomePage() 
        : const WelcomePage(),
      onGenerateRoute: (settings) {
        if(settings.name == '/signin'){
          return MaterialPageRoute(builder: (context) => const SignInPage());
        }
        return MaterialPageRoute(builder: (context) => const WelcomePage());
      },
    );
  }
}