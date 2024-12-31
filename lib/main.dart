import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/theme/app_theme.dart';
import 'package:paganini/data/datasources/credit_card_datasource.dart';
import 'package:paganini/data/local/hive_service.dart';
import 'package:paganini/data/models/contact_model.dart';
import 'package:paganini/data/repositories/credit_card_repository_impl.dart';
import 'package:paganini/domain/usecases/credit_cards_use_case.dart';
import 'package:paganini/domain/usecases/contact_use_case.dart';

import 'package:paganini/firebase_options.dart';
import 'package:paganini/presentation/pages/auth_page.dart';
import 'package:paganini/presentation/pages/cards/card_delete_page.dart';
import 'package:paganini/presentation/pages/cards/card_page.dart';
import 'package:paganini/presentation/pages/introduction_page.dart';
import 'package:paganini/presentation/pages/navigation_page.dart';
import 'package:paganini/presentation/pages/payment/payment_page.dart';
import 'package:paganini/presentation/pages/transfer/contacts_page.dart';
import 'package:paganini/presentation/pages/confirm_recharge_page.dart';
import 'package:paganini/presentation/pages/transfer/confirm_transfer_page.dart';
import 'package:paganini/presentation/pages/home_page.dart';
import 'package:paganini/presentation/pages/initial_page.dart';
import 'package:paganini/presentation/pages/login_page.dart';
import 'package:paganini/presentation/pages/qr_pages.dart';
import 'package:paganini/presentation/pages/cards/wallet_page.dart';
import 'package:paganini/presentation/pages/recharge_page.dart';
import 'package:paganini/presentation/pages/register_page.dart';
import 'package:paganini/presentation/pages/transfer/transfer_page.dart';
import 'package:paganini/presentation/pages/transfer/transfer_receipt_page.dart';
import 'package:paganini/presentation/providers/contact_provider.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/payment_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  //wait firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await Hive.initFlutter();
  final hiveService = HiveService();
  await hiveService.init();
  final remoteDataSource = CreditCardRemoteDataSourceImpl(FirebaseFirestore.instance);
  final creditCardRepository =CreditCardRepositoryImpl(remoteDataSource: remoteDataSource);
  final creditCardsUseCase = CreditCardsUseCase(repository: creditCardRepository);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) =>CreditCardProvider(creditCardsUseCase: creditCardsUseCase)),
        ChangeNotifierProvider(create: (_) => SaldoProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        Provider<HiveService>(create: (_) => hiveService),
        Provider<ContactUseCase>(create: (context) => ContactUseCase(context.read<HiveService>()),),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
      initialRoute: Routes.INTRODUCTIONPAGE,
      routes: {
        Routes.INITIAL: (context) => const InitialPage(),
        Routes.HOME: (context) => const HomePage(),
        Routes.LOGIN: (context) => const LoginPage(),
        Routes.QRPAGE: (context) => const QrPage(),
        Routes.WALLETPAGE: (context) => const WalletPage(),
        Routes.CARDPAGE: (context) => const CardPage(),
        Routes.CARDDELETEPAGE: (context) => const CardDeletePage(),
        Routes.REGISTER: (context) => const RegisterPage(),
        Routes.RECHARGE: (context) => const RechargePage(),
        Routes.RECEIPTRANSFER: (context) => TransferReceipt(),
        Routes.TRANSFERPAGE: (context) => const TransferPage(),
        Routes.INTRODUCTIONPAGE: (context) => const OnBoardingPage(),
        //Routes.PAYMENTPAGE : (context) => const PaymentPage(),
        Routes.NAVIGATIONPAGE: (context) => const NavigationPage(),
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
  /* return DevicePreview(
      enabled: true,
      builder: (context) => MaterialApp(
        // ignore: deprecated_member_use
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(
            context), // Simula la configuración regional del dispositivo
        builder: DevicePreview.appBuilder,
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
          Routes.REGISTER: (context) => const RegisterPage(),
          Routes.RECHARGE: (context) => const RechargePage(),
          Routes.RECEIPTRANSFER: (context) => TransferReceipt(),
          Routes.TRANSFERPAGE: (context) => const TransferPage(),
        },
        theme: ThemeData(
            appBarTheme: const AppBarTheme(color: Colors.white),
            scaffoldBackgroundColor: Colors.white),
      ),
    );
  }*/
}
