import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
 const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool dartThemeSelected = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Setting Page',
          ),
          Switch(
            value: dartThemeSelected,
            onChanged: (value) {
              value = !dartThemeSelected;
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme(); 
              setState(() {
                dartThemeSelected = value;
              });
            },
          )
        ],
      ),
    );
  }
}
