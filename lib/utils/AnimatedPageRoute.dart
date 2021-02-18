import 'package:flutter/material.dart';

class AnimatedPageRoute extends PageRouteBuilder {
  final Widget widget;
  AnimatedPageRoute({this.widget})
      : super(
            transitionDuration: Duration(seconds: 2),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> Secanimation,
                Widget child) {
              // animation =
              //     CurvedAnimation(parent: animation, curve: Curves.easeInOutSine);
              var begin = Offset(0, 1);
              var end = Offset.zero;
              var curve = Curves.bounceInOut;
              // var tween = Tween(begin: begin, end: end);
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              var curveTween = CurveTween(curve: curve);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
              // return ScaleTransition(
              //   alignment: Alignment.center,
              //   scale: animation,
              //   child: child,
              // );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> Secanimation) {
              return widget;
            });
}
