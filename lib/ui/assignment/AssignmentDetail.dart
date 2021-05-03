import 'dart:async';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/utils/CustomColors.dart';
import 'package:muntazim/utils/Helper.dart';
import 'package:muntazim/utils/animatedDialogBox.dart';
import 'package:muntazim/utils/openDocument.dart';

class AssignmnetDetailScreen extends StatefulWidget {
 // final assignmentData;

   // AssignmnetDetailScreen({Key key, this.assignmentData}) : super(key: key);
  @override
  _AssignmnetDetailScreenState createState() => _AssignmnetDetailScreenState();
}

class _AssignmnetDetailScreenState extends State<AssignmnetDetailScreen> {
  final GlobalKey<ExpansionTileCardState> stCard = new GlobalKey();

  var schoolId;
  String schoolIdName;
  StreamController<bool> dataController = StreamController<bool>.broadcast();
  PermissionService _permissionService = PermissionService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          appBar: myAppBar(_height),
          backgroundColor: CustomColors.lightBackgroundColor,
          body: Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                    ],
                  )),
            ),
          ),
        ),
        Helper.myHeader(text: 'Assignment Detail', height: _height),
      ],
    );
  }


  Widget myAppBar(_height) {
    return AppBar(
      backgroundColor: Colors.transparent,
      // leading: Padding(
      //     padding: EdgeInsets.only(bottom: 50.0),
      //     child: Icon(Icons.menu_rounded)),
      title: Padding(
        padding: EdgeInsets.only(bottom: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Helper.text(value: 'Assignment 1',fColor: Colors.white)
          ],
        ),
      ),
      toolbarHeight: _height * 0.3,
      elevation: 0.0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/appBack.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      // actions: [
      //   Padding(
      //     padding: EdgeInsets.only(right: 10.0, bottom: 50.0),
      //     child: CircleAvatar(
      //       radius: 30.0,
      //       backgroundColor: CustomColors.darkGreenColor,
      //       child: CircleAvatar(
      //         radius: 27.0,
      //         backgroundColor: Colors.white,
      //         child: Icon(
      //           Icons.person,
      //           color: CustomColors.darkGreenColor,
      //           size: 40.0,
      //         ),
      //       ),
      //     ),
      //   )
      // ],
    );
  }
}
