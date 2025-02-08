import 'package:flutter/material.dart';
import 'package:paganini/app_data.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/theme/app_theme.dart';
import 'package:paganini/presentation/pages/biometric_login_page.dart';
import 'package:paganini/presentation/providers/introduction_provider.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:paganini/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:paganini/presentation/pages/screens.dart';

class MainApp extends StatelessWidget {
  final AppData? appData;
  const MainApp({super.key,  this.appData});
  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false).initializeUser();
    final isIntroductionPage = Provider.of<IntroductionProvider>(context).isIntroductionPage;

    return MaterialApp(
        title: 'Paganini',
        debugShowCheckedModeBanner: false,
        initialRoute: isIntroductionPage ? Routes.APPTUTORIALSCREEN : Routes.INITIAL,
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
         // Routes.RECEIPTRANSFER: (context) => TransferReceipt(),
          Routes.TRANSFERPAGE: (context) => const TransferPage(),
          Routes.INTRODUCTIONPAGE: (context) => const OnBoardingPage(),
          Routes.APPTUTORIALSCREEN : (context) => const AppTutorialScreen(),
          Routes.NAVIGATIONPAGE: (context) => const NavigationPage(),
          Routes.RETURNAMOUNTPAGE: (context) => const ReturnAmountPage(),
          Routes.FORGETPASSWORD : (context) => const   ForgetPasswordPage(),
          Routes.SETTINGSPAGE: (context) => const SettingPage(),
          Routes.HISTORYPAGE: (context) => const HistoryMovement(),
          Routes.BIOLOGIN : (context) => const BiometricAuthPage(),
          Routes.EDITPROFILEPAGE : (context) => const EditProfilePage(),
          Routes.PRIVACYPAGE : (context)  => const PrivacyPage()
        },
        theme: Provider.of<ThemeProvider>(context).isDarkMode
            ? AppTheme().themeDarkMode()
            : AppTheme().themeLightMode());
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
