import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:muntazim/core/services/public_service.dart';
import 'package:muntazim/ui/LoginScreen.dart';
import 'package:muntazim/ui/SplashScreen.dart';
import 'package:muntazim/utils/CustomColors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:muntazim/core/plugins.dart';

class SplashScreenU extends StatefulWidget {
  @override
  _SplashScreenUState createState() => _SplashScreenUState();
}

class _SplashScreenUState extends State<SplashScreenU> {
  PublicService _publicService;
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).readAs();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _publicService.getAllAboutApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    _publicService = context.watch();
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var user = Provider.of<UserProvider>(context);
    print(user.parentData);
    return AnimatedSplashScreen(
        duration: 3000,
        animationDuration: Duration(seconds: 1),
        splashIconSize: _height * 0.2,
        splash: Container(
          padding: EdgeInsets.all(30),
          height: 220,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    CustomColors.buttonLightBlueColor,
                    CustomColors.buttonDarkBlueColor
                  ]),
              shape: BoxShape.circle,
              color: CustomColors.lightGreenColor),
          alignment: Alignment.center,
          child: Image.asset(
            'assets/Logo_Muntazim_Color.png',
            height: 60,
          ),
        ),
        nextScreen: user.parentData == null
            ? LoginScreen()
            : BottomBarNavigationPatternExample(
                screenIndex: 0,
              ),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.bottomToTop,
        backgroundColor: CustomColors.darkBackgroundColor);
  }
}
