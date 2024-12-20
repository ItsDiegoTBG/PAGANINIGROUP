import 'package:flutter/material.dart';
import 'package:paganini/core/routes/app_routes.dart';
import 'package:paganini/core/utils/colors.dart';


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
                  Navigator.pushReplacementNamed(context, Routes.HOME);
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
                  Navigator.pushReplacementNamed(context, Routes.WALLETPAGE);
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
            ),
            

          ],
        ),
      ),
    );
  }
}
