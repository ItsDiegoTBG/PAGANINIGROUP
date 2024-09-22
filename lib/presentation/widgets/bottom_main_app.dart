import 'package:flutter/material.dart';
import 'package:paganini/utils/colors.dart';


class BottomMainAppBar extends StatelessWidget {
  const BottomMainAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          //order: Border.symmetric(color: AppColors.primaryColor),
         // boxShadow: <BoxShadow>[
           
         // ]
      ),
      child: BottomAppBar(
        //height: 68,
        color: AppColors.primaryColor,
        elevation: 10,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        // ignore: sized_box_for_whitespace
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: MaterialButton(
                // color: Colors.black,
                minWidth: 40,
                onPressed: () {
                  Navigator.pushNamed(context, "home_page");
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home_outlined,
                      color:Colors.white
                    ),
                    Text("Home",style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: MaterialButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, "wallet_page");
                },
                minWidth: 40,
                // color:  Colors.black,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wallet_outlined,
                      color: Colors.white,
                    ),
                    Text("Wallet",style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
