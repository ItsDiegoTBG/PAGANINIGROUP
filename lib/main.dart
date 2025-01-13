import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paganini/app_loader.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/theme/app_theme.dart';
import 'package:paganini/data/datasources/credit_card_datasource.dart';
import 'package:paganini/data/local/hive_service.dart';
import 'package:paganini/data/local/notification_service.dart';
import 'package:paganini/data/models/contact_model.dart';
import 'package:paganini/data/repositories/auth_respository_impl.dart';
import 'package:paganini/data/repositories/credit_card_repository_impl.dart';
import 'package:paganini/domain/usecases/authenticate_with_biometrics.dart';
import 'package:paganini/domain/usecases/credit_cards_use_case.dart';
import 'package:paganini/domain/usecases/contact_use_case.dart';
import 'package:paganini/firebase_options.dart';
import 'package:paganini/main_app.dart';
import 'package:paganini/presentation/pages/screens.dart';
import 'package:paganini/presentation/providers/biometric_auth_provider.dart';
import 'package:paganini/presentation/providers/contact_provider.dart';
import 'package:paganini/presentation/providers/credit_card_provider.dart';
import 'package:paganini/presentation/providers/introduction_provider.dart';
import 'package:paganini/presentation/providers/payment_provider.dart';
import 'package:paganini/presentation/providers/saldo_provider.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:paganini/presentation/pages/forget_password_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  //wait firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('settingsBox');
  final hiveService = HiveService();
  await hiveService.init();
   final authRepository = AuthRepositoryImpl(
    FirebaseAuth.instance,
    LocalAuthentication(),
    const FlutterSecureStorage(),
  );
  final remoteDataSource = CreditCardRemoteDataSourceImpl();
  final creditCardRepository =
      CreditCardRepositoryImpl(remoteDataSource: remoteDataSource);
  final creditCardsUseCase =
      CreditCardsUseCase(repository: creditCardRepository);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authenticateWithBiometrics = AuthenticateWithBiometrics(authRepository);
  final bioProvider = BiometricAuthProvider(authenticateWithBiometrics);


  
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();
  //await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CreditCardProvider(creditCardsUseCase: creditCardsUseCase)),
        ChangeNotifierProvider(create: (_) => SaldoProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => bioProvider),
        Provider<HiveService>(create: (_) => hiveService),
        Provider<ContactUseCase>(create: (context) => ContactUseCase(context.read<HiveService>()),),
        Provider<NotificationService>(create: (_) => NotificationService(),),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => ThemeProvider()),
        ChangeNotifierProvider(lazy: false,create: (_) => IntroductionProvider()),
      ],
      child: const AppLoader(),
    ),
  );
}

