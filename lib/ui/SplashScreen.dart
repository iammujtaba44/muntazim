import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:muntazim/ui/LoginScreen.dart';
import 'package:muntazim/utils/AnimatedPageRoute.dart';
import 'package:muntazim/utils/CustomColors.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  static String id = 'splashScreen';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    final curvedAnimation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceIn,
        reverseCurve: Curves.easeOut);
    animation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(curvedAnimation)
          ..addListener(() {
            if (mounted) {
              setState(() {});
            }
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _animationController.forward();
            }
          });
    _animationController.forward();
    Timer(
        Duration(seconds: 3),
        () =>
            Navigator.push(context, AnimatedPageRoute(widget: LoginScreen())));
  }

  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  AnimationController _animationController;
  Animation<double> animation;
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        decoration: BoxDecoration(
            color: CustomColors.darkBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // Container(
            //   decoration:
            //       BoxDecoration(color: CustomColors.darkBackgroundColor),
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Transform.rotate(
                          angle: animation.value,
                          child: Container(
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
                        )

                        // AvatarGlow(
                        //   endRadius: 150,
                        //   duration: Duration(seconds: 2),
                        //   glowColor:
                        //       Color.fromRGBO(1, 116, 111, 0), //Colors.white24,
                        //   repeat: true,
                        //   showTwoGlows: true,
                        //   repeatPauseDuration: Duration(microseconds: 2),
                        //   // startDelay: Duration(seconds: 1),
                        //   child: Material(
                        //       elevation: 8.0,
                        //       shape: CircleBorder(),
                        //       child: CircleAvatar(
                        //         backgroundColor: CustomColors.lightGreenColor,
                        //         child: Image.asset(
                        //           'assets/Logo_Muntazim_Color.png',
                        //           height: 60,
                        //         ),
                        //         radius: 100.0,
                        //       )),
                        // ),
                      ],
                    ),
                  ),
                ),
                // Expanded(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       SpinKitChasingDots(
                //         color: CustomColors.lightGreenColor,
                //         // Color.fromRGBO(1, 116, 111, 10),
                //         size: 70,
                //       ),
                //       Padding(padding: EdgeInsets.only(top: 20.0)),
                //     ],
                //   ),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}
