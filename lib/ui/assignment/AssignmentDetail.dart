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
                  Container(
                    width: _width,
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: getRow(key: 'Student', value: 'Asad Khan'),
                  ),
                  SizedBox(
                    height: _height * 0.017,
                  ),
                  Container(
                      width: _width,
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Column(
                        children: [
                          getRow(key: 'Teacher', value: 'XYZ'),
                          getRow(key: 'Assignment type', value: 'XYZ'),
                        ],
                      )),
                  SizedBox(
                    height: _height * 0.017,
                  ),
                  Container(
                      width: _width,
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Column(
                        children: [
                          getRow(key: 'Assigned Date', value: '20/06/2021'),
                          getRow(key: 'Due Date', value: '20/06/2021'),
                        ],
                      )),
                  SizedBox(
                    height: _height * 0.017,
                  ),
                  Container(
                      width: _width,
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Helper.text(
                              value: 'Description', fSize: _height * 0.032),
                          SizedBox(
                            height: _height * 0.017,
                          ),
                          Container(
                            child: Helper.text(
                                value:
                                    'XYZ XYZ XYZ XYZ XYZ XYZ XYZ XYZ XYZ XYZ XYZ XYZ',
                                fSize: _height * 0.03),
                          )
                        ],
                      )),
                  SizedBox(
                    height: _height * 0.017,
                  ),
                  Container(
                      width: _width,
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Helper.text(
                              value: 'Attachments', fSize: _height * 0.032),
                          SizedBox(
                            height: _height * 0.017,
                          ),
                          Wrap(
                              runSpacing: 5.0,
                              children: List.generate(3, (index) {
                                return InkWell(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: _height * 0.023,
                                          backgroundColor:
                                              CustomColors.darkGreenColor,
                                          child: CircleAvatar(
                                            radius: _height * 0.021,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.download_rounded,
                                              color:
                                                  CustomColors.darkGreenColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Helper.text(
                                            value: 'Attachment.pdf',
                                            fSize: _height * 0.03)
                                      ],
                                    )
                                    // child: Helper.text(
                                    //     value: data['attachment'][index],
                                    //     fSize: height * 0.016,
                                    //     fColor: CustomColors.darkGreenColor,
                                    //     fWeight: FontWeight.bold),
                                    );
                              }))
                        ],
                      ))
                ],
              )),
            ),
          ),
        ),
        Helper.myHeader(text: 'Assignment Detail', height: _height),
      ],
    );
  }

  Widget getRow({String key, String value, double height}) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Helper.text(value: '$key', fSize: height * 0.032),
        Spacer(),
        Helper.text(value: '$value', fSize: height * 0.03)
      ],
    );
  }

  Widget myAppBar(_height) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
            padding: EdgeInsets.only(bottom: 50.0),
            child: Icon(Icons.arrow_back_sharp)),
      ),
      leadingWidth: _height * 0.035,
      title: Padding(
        padding: EdgeInsets.only(bottom: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Helper.text(
                value: 'Assignment 1',
                fSize: _height * 0.03,
                fColor: Colors.white)
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
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 15.0, bottom: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Helper.text(
                    value: '(10/100) ',
                    fWeight: FontWeight.bold,
                    fColor: Colors.white,
                    fSize: _height * 0.03,
                  ),
                  Helper.text(
                    value: 'Graded',
                    fWeight: FontWeight.bold,
                    fColor: Colors.white,
                    fSize: _height * 0.03,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
