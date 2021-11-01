import 'dart:async';

import 'package:flutter/material.dart';
import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/core/services/public_service.dart';
import 'package:muntazim/ui/fees/FeesScreen.dart';

class DrawerView extends StatefulWidget {
  @override
  _DrawerViewState createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> with TickerProviderStateMixin {
  AnimationController animationController;
  DrawerService _drawerService;
  PublicService _publicService;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();

    _drawerService = Provider.of(context, listen: false);
    _drawerService.setIsOpenStatus(true);
  }

  @override
  void dispose() {
    super.dispose();
    _drawerService.setIsOpenStatus(false);
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    _publicService = context.watch();
    final drawerHeader = DrawerHeader(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              CustomColors.buttonLightBlueColor,
              CustomColors.buttonDarkBlueColor
            ])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: _height * 0.05,
                ),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/user_avatar.png'),
                ),
                SizedBox(
                  height: 5,
                ),
                Helper.text(
                    value:
                        "${user.parentData == null ? 'NA' : user.parentData.displayAs}",
                    fColor: Colors.white),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: new Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ));
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        child: Container(
          color: CustomColors.lightBackgroundColor,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              drawerHeader,
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BottomBarNavigationPatternExample(
                                screenIndex: 0,
                              )));
                },
                leading: SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: Icon(Icons.home),
                ),
                title: Container(
                  transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Helper.text(
                          value: 'Home',
                          fColor: Colors.black,
                          fWeight: FontWeight.w300,
                          fSize: _height * 0.02)
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BottomBarNavigationPatternExample(
                                screenIndex: 1,
                              )));
                },
                leading: SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: Icon(Icons.assignment),
                ),
                title: Container(
                  transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Helper.text(
                          value: 'Report Card',
                          fColor: Colors.black,
                          fWeight: FontWeight.w300,
                          fSize: _height * 0.02)
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BottomBarNavigationPatternExample(
                                screenIndex: 2,
                              )));
                },
                leading: SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: Icon(Icons.calendar_today),
                ),
                title: Container(
                  transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Helper.text(
                          value: 'Attendance',
                          fColor: Colors.black,
                          fWeight: FontWeight.w300,
                          fSize: _height * 0.02)
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BottomBarNavigationPatternExample(
                                screenIndex: 3,
                              )));
                },
                leading: SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: Icon(Icons.assignment_outlined),
                ),
                title: Container(
                  transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Helper.text(
                          value: 'Assignment',
                          fColor: Colors.black,
                          fWeight: FontWeight.w300,
                          fSize: _height * 0.02)
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BottomBarNavigationPatternExample(
                                screenIndex: 4,
                              )));
                },
                leading: SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: Icon(Icons.notifications),
                ),
                title: Container(
                  transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Helper.text(
                          value: 'Notifications',
                          fColor: Colors.black,
                          fWeight: FontWeight.w300,
                          fSize: _height * 0.02)
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FeesScreen()));
                },
                leading: SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: Icon(Icons.payment),
                ),
                title: Container(
                  transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Helper.text(
                          value: 'Fees',
                          fColor: Colors.black,
                          fWeight: FontWeight.w300,
                          fSize: _height * 0.02)
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Auth().signOut(context: context);
                },
                leading: SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: Icon(Icons.logout),
                ),
                title: Container(
                  transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Helper.text(
                          value: 'Logout',
                          fColor: Colors.black,
                          fWeight: FontWeight.w300,
                          fSize: _height * 0.02)
                    ],
                  ),
                ),
              ),
              Container(
                transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                margin:
                    EdgeInsets.only(left: _width * 0.04, top: _height * 0.1),
                child: Column(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // /  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Helper.text(
                        value: 'Version',
                        fColor: Colors.black,
                        fWeight: FontWeight.w300,
                        fSize: _height * 0.03),
                    Helper.text(
                        value: '${_publicService.version ?? ''}',
                        fColor: Colors.black54,
                        fWeight: FontWeight.w300,
                        fSize: _height * 0.02),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerService {
  StreamController<bool> _statusController = StreamController.broadcast();
  Stream<bool> get status => _statusController.stream;

  setIsOpenStatus(bool openStatus) {
    _statusController.add(openStatus);
  }
}
