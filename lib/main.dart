import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
import 'package:paganini/presentation/pages/screens.dart';
import 'package:paganini/presentation/providers/contact_provider.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/introduction_provider.dart';
import 'package:paganini/presentation/providers/payment_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  
  // Espera inicializaciones necesarias
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('settingsBox');

  final hiveService = HiveService();
  await hiveService.init();

  final remoteDataSource = CreditCardRemoteDataSourceImpl();
  final creditCardRepository = CreditCardRepositoryImpl(remoteDataSource: remoteDataSource);
  final creditCardsUseCase = CreditCardsUseCase(repository: creditCardRepository);

  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CreditCardProvider(creditCardsUseCase: creditCardsUseCase)),
        ChangeNotifierProvider(create: (_) => SaldoProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        Provider<HiveService>(create: (_) => hiveService),
        Provider<ContactUseCase>(create: (context) => ContactUseCase(context.read<HiveService>())),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => ThemeProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => IntroductionProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false).initializeUser();
    final isIntroductionPage = Provider.of<IntroductionProvider>(context).isIntroductionPage;

    return MaterialApp(
      title: 'Paganini',
      debugShowCheckedModeBanner: false,
      initialRoute: isIntroductionPage ? Routes.INTRODUCTIONPAGE : Routes.INITIAL,
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
        Routes.NAVIGATIONPAGE: (context) => const NavigationPage(),
      },
      theme: Provider.of<ThemeProvider>(context).isDarkMode
          ? AppTheme().themeDarkMode()
          : AppTheme().themeLightMode(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showAllMovements = false;
  List<String> movements = [
    'Compra en Supermercado',
    'Pago de Servicios',
    'Transferencia recibida',
    'Recarga de saldo',
    'Pago en Restaurante',
    'Suscripción mensual',
  ];

  @override
  Widget build(BuildContext context) {
    final saldoProvider = context.watch<SaldoProvider>();
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('Saldo', style: TextStyle(color: Colors.white, fontSize: 20)),
                Text('\$${saldoProvider.saldo}', style: const TextStyle(color: Colors.white, fontSize: 24)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Últimos Movimientos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(showAllMovements ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() => showAllMovements = !showAllMovements),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: showAllMovements ? movements.length : 3,
              itemBuilder: (context, index) => ListTile(
                title: Text(movements[index]),
                leading: const Icon(Icons.check_circle, color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
