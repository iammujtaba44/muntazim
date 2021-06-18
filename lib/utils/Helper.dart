import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muntazim/utils/CustomColors.dart';

class Helper {
  static String dateFormat(DateTime date) {
    return DateFormat.yMMMd().format(date).toString();
  }

  static String timeFormat(DateTime date) =>
      DateFormat("h:mma").format(date).toString();

  static text(
      {dynamic value,
      double fSize = 0.0,
      FontWeight fWeight = FontWeight.w400,
      Color fColor,
      TextDecoration tDecoration}) {
    return Text(
      value,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          decoration: tDecoration == null ? null : tDecoration,
          fontSize: fSize != 0.0 ? fSize : 25.0,
          color: fColor != null ? fColor : CustomColors.darkGreenColor,
          fontWeight: fWeight != FontWeight.w400 ? fWeight : FontWeight.w400),
    );
  }

  static CIndicator() {
    return CircularProgressIndicator(
      backgroundColor: CustomColors.darkBackgroundColor,
      valueColor:
          AlwaysStoppedAnimation<Color>(CustomColors.buttonDarkBlueColor),
    );
  }

  static sBar({dynamic text, bool colorCode = true}) {
    return SnackBar(
        content: Text(
          text,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: colorCode ? CustomColors.darkBackgroundColor : Colors.black,
            // fontFamily: 'SF Pro Display'
          ),
        ),
        elevation: 6.0,
        duration: Duration(seconds: 2),
        padding: EdgeInsets.only(left: 10.0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        backgroundColor: CustomColors.buttonDarkBlueColor);
  }

  static myHeader({dynamic text, double height ,Function onTap ,bool isDrawerOpen = false}) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: height * 0.07),
        child: isDrawerOpen? Container():Row(
          children: [
            InkWell(
              onTap: onTap,
              child: Icon(
                Icons.menu_rounded,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Text(
              text.toString().toUpperCase(),
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
