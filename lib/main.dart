import 'package:flutter/material.dart';
import 'package:paganini/presentation/pages/home_page.dart';
import 'package:paganini/presentation/pages/initial_page.dart';
import 'package:paganini/presentation/pages/login_page.dart';
import 'package:paganini/presentation/pages/qr_pages.dart';
import 'package:paganini/presentation/pages/wallet_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setup();
  runApp(const MainApp());
}

void setup() async {
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paganini',
      debugShowCheckedModeBanner: false,
      initialRoute: "initial_page",
      theme: ThemeData(appBarTheme:  const AppBarTheme(color: Colors.white)),
      routes: {
        "initial_page": (BuildContext context) => const InitialPage(),
        "login_page": (BuildContext context) => const LoginRegisterScreen(),
        "home_page" : (BuildContext context) => const HomePage(),
        "qr_page" : (BuildContext context) => const QrPage(),
        "wallet_page" : (BuildContext context) => const WalletPage(),
      },
    );
  }
}
