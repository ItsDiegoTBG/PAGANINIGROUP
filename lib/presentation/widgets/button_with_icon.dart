import 'package:flutter/material.dart';
import 'package:paganini/utils/colors.dart';

class ButtonWithIcon extends StatelessWidget {
  final Function function;
  final String textButton;
  final IconData icon;
  final Color? color;
  const ButtonWithIcon({super.key, required this.function, required this.textButton, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5,bottom: 5),
      child: SizedBox(
        width: 230, 
        child: TextButton(
          style: TextButton.styleFrom(
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              
            ),
            backgroundColor: color ?? AppColors.primaryColor,
            padding: const EdgeInsets.only(top: 12,bottom: 12,left: 10,right: 10),
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          onPressed: ()=> {
            function()
          },
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround, 
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(icon, color: Colors.white),
              ), 
              const SizedBox(width: 20), 
              Expanded(
                child: Text(
                  textButton,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
