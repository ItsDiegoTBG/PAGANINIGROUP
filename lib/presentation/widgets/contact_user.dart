import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ContactUserWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final String nameUser;
  final String phoneUser;
  final bool isRegistered;

  const ContactUserWidget({
    super.key,
    this.width = 200,
    this.height = 100,
    this.color = AppColors.primaryColor,
    required this.nameUser,
    required this.phoneUser,
    this.isRegistered = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final dynamicColor = isRegistered
        ? (themeProvider.isDarkMode
            ? Colors.white
            : color) // Color para registrados
        : AppColors.secondaryColor; // Color para no registrados
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: dynamicColor),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nameUser,
                  style: TextStyle(
                    color: isRegistered
                        ? (themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.white)
                        : Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.visible,
                  ),
                ),
                
                if (isRegistered)
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      "Paganini",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
              ],
            ),
            Text(
              "📱$phoneUser",
              style: TextStyle(
                  color: isRegistered
                      ? (themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.white) // Color para registrados
                      : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.visible),
            ),
          ],
        ),
      ),
    );
  }
}
