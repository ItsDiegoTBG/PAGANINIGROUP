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
  final bool? withoutIconArrowGo;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback? onPressed;

  const ContainerSettings(
      {super.key,
      required this.text,
      required this.iconData,
      this.needSwitch,
      this.darkThemeSelected,
      this.onSwitchChanged,
      this.withoutIconArrowGo,
      this.onPressed
    });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeProvider = context.watch<ThemeProvider>();
    return  Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            //width: size.width * 0.9,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondaryColor,
                        ),
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              color: themeProvider.isDarkMode
                                  ? Colors.black
                                  : Colors.black,
                              iconData,
                              size: 30,
                            )),
                      ),
                    ),
                    Text(
                      text,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
                
                 if(withoutIconArrowGo!=true)
                   needSwitch ?? false
                      ? Switch(
                          value: darkThemeSelected ?? false,
                          onChanged: onSwitchChanged,
                        )
                      : IconButton(
                          onPressed: (){},
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        )
                 
              ],
            ),
          ),
        ),
      
    );
  }
}
