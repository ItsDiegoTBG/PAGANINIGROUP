import 'package:flutter/material.dart';

import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/pages/cards/wallet_page.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';
class ContainerSettings extends StatelessWidget {
  final String text;
  final IconData iconData;
  final bool? needSwitch;
  final bool? darkThemeSelected;
  final ValueChanged<bool>? onSwitchChanged;

  const ContainerSettings({super.key, required this.text, required this.iconData, this.needSwitch, this.darkThemeSelected, this.onSwitchChanged});



  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    final size = MediaQuery.of(context).size;
    final themeProvider = context.watch<ThemeProvider>();
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: size.width * 0.9,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeProvider.isDarkMode ? Colors.black: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          iconData,
                          size: 30,
                        )),
                  ),
                ),
                Text(
                  text,
                  style:  TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: themeProvider.isDarkMode ? Colors.black:Colors.white),
                ),
              ],
            ),
            needSwitch ?? false
                ? Switch(
                    value: darkThemeSelected ?? false,
                    onChanged: onSwitchChanged,
                  )
                : IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
