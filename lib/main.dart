import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/data/datasources/credit_card_datasource.dart';
import 'package:paganini/data/repositories/credit_card_repository_impl.dart';
import 'package:paganini/domain/repositories/credit_card_repository.dart';
import 'package:paganini/domain/usecases/add_credit_card.dart';
import 'package:paganini/domain/usecases/get_credit_cards.dart';
import 'package:paganini/presentation/pages/card_page.dart';
import 'package:paganini/presentation/pages/home_page.dart';
import 'package:paganini/presentation/pages/initial_page.dart';
import 'package:paganini/presentation/pages/login_page.dart';
import 'package:paganini/presentation/pages/qr_pages.dart';
import 'package:paganini/presentation/pages/wallet_page.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setup();
  final remoteDataSource = CreditCardRemoteDataSourceImpl();
  final creditCardRepository = CreditCardRepositoryImpl(remoteDataSource: remoteDataSource);
  final getCreditCardsUseCase = GetCreditCardsUseCase(repository: creditCardRepository);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CreditCardProvider(
              getCreditCardsUseCase: getCreditCardsUseCase,
              addCreditCardUseCase:
                  AddCreditCardUseCase(repository: creditCardRepository)),
        ),
        ChangeNotifierProvider(create: (_) => SaldoProvider()),
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
    return MaterialApp(
      title: 'Paganini',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.INITIAL,
      routes: {
        Routes.INITIAL: (context) => const InitialPage(),
        Routes.HOME: (context) => const HomePage(),
        Routes.LOGIN: (context) => const LoginRegisterScreen(),
        Routes.QRPAGE: (context) => const QrPage(),
        Routes.WALLETPAGE: (context) => const WalletPage(),
        Routes.CARDPAGE: (context) => const CardPage(),
      },
      theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Colors.white),
          scaffoldBackgroundColor: Colors.white),
    );
  }
}
