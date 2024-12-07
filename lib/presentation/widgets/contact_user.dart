import 'package:flutter/material.dart';
import 'package:paganini/core/utils/colors.dart';

class ContactUserWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final String nameUser;
  final String phoneUser;
  final String numberAccount;

  const ContactUserWidget(
      {super.key,
      this.width = 200,
      this.height = 100,
      this.color = AppColors.secondaryColor,
      required this.nameUser,
      required this.phoneUser,
      required this.numberAccount});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nameUser,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w400,overflow: TextOverflow.visible)),
                 Text("📱$phoneUser",style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400,overflow: TextOverflow.visible),),
                Text("Nro +$numberAccount")
              ],
            ),
          )
        /*const Padding(
            padding:EdgeInsets.only(top: 7, right: 10),
            child: Align(
                alignment: Alignment.topRight,
                child: Text("Paganini Mobile",
                    style:  TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400,overflow: TextOverflow.visible))),
          )*/
        ],
      ),
    );
  }
}
