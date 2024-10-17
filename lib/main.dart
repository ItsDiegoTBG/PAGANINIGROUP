import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/presentation/pages/card_page.dart';
import 'package:paganini/presentation/pages/home_page.dart';
import 'package:paganini/presentation/pages/initial_page.dart';
import 'package:paganini/presentation/pages/login_page.dart';
import 'package:paganini/presentation/pages/qr_pages.dart';
import 'package:paganini/presentation/pages/wallet_page.dart';


void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setup();
  runApp(const MainApp());
}

void setup() async {
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paganini',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.INITIAL,
      routes: {
        Routes.INITIAL: (context) => const InitialPage(),
        Routes.HOME: (context) => const HomePage(),
        Routes.LOGIN : (context) => const LoginRegisterScreen(),
        Routes.QRPAGE : (context) => const QrPage(),
        Routes.WALLETPAGE : (context) => const WalletPage(),
        Routes.CARDPAGE : (context) => const CardPage(),
      },
      theme: ThemeData(appBarTheme:  const AppBarTheme(color: Colors.white),scaffoldBackgroundColor: Colors.white),
      
    );
  }
}
