import 'package:flutter/material.dart';
import 'package:paganini/presentation/pages/initial_page.dart';
import 'package:paganini/presentation/pages/login_page.dart';

void main(){
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "initial_page",
      theme: ThemeData(),
      routes: {"initial_page":(BuildContext context)=> const InitialPage(),"login_page":(BuildContext context)=> const LoginRegisterScreen()},
    ) ;
}
}