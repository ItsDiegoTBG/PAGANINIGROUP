import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/data/datasources/credit_card_datasource.dart';
import 'package:paganini/data/repositories/credit_card_repository_impl.dart';
import 'package:paganini/domain/usecases/credit_cards_use_case.dart';
import 'package:paganini/firebase_options.dart';
import 'package:paganini/presentation/pages/auth_page.dart';
import 'package:paganini/presentation/pages/cards/card_delete_page.dart';
import 'package:paganini/presentation/pages/cards/card_page.dart';
import 'package:paganini/presentation/pages/home_page.dart';
import 'package:paganini/presentation/pages/initial_page.dart';
import 'package:paganini/presentation/pages/login_page.dart';
import 'package:paganini/presentation/pages/qr_pages.dart';
import 'package:paganini/presentation/pages/cards/wallet_page.dart';
import 'package:paganini/presentation/pages/register_page.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  //wait firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final remoteDataSource = CreditCardRemoteDataSourceImpl();
  final creditCardRepository =
      CreditCardRepositoryImpl(remoteDataSource: remoteDataSource);
  final creditCardsUseCase =
      CreditCardsUseCase(repository: creditCardRepository);

  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => CreditCardProvider(
                  creditCardsUseCase: creditCardsUseCase,
                )),
        ChangeNotifierProvider(create: (_) => SaldoProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

void setup() async {
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
  WidgetsFlutterBinding.ensureInitialized();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false).initializeUser();
    return MaterialApp(
      title: 'Paganini',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.INITIAL,
      routes: {
        Routes.INITIAL: (context) => const InitialPage(),
        Routes.HOME: (context) => const HomePage(),
        Routes.LOGIN: (context) => const LoginPage(),
        Routes.QRPAGE: (context) => const QrPage(),
        Routes.WALLETPAGE: (context) => const WalletPage(),
        Routes.CARDPAGE: (context) => const CardPage(),
        Routes.CARDDELETEPAGE: (context) => const CardDeletePage(),
        Routes.AUTHPAGE: (context) => const AuthPage(),
        Routes.REGISTER: (context) => const RegisterPage()
      },
      theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Colors.white),
          scaffoldBackgroundColor: Colors.white),
    );
  }
}
