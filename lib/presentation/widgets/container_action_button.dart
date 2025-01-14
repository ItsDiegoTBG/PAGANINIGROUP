import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';
import 'package:paganini/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';
class ContainerActionButton  extends StatelessWidget{
  final String text;
  final IconData iconData;
  final Color color;
  final double width;
  final double height;
  const ContainerActionButton({super.key, 
    required this.text,
    required this.iconData,
    required this.color,

    this.width = 80,
    this.height = 80,
  });
  
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(2),
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: const  BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
        
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, color: color,size: 30,),
          const SizedBox(height: 5),
          Text(text, style:  TextStyle(fontSize: 12, color: themeProvider.isDarkMode ? Colors.white : Colors.black87,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
        ],
      ),
    );
  }

  
}