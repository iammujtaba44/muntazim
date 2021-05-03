import 'dart:async';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/ui/assignment/AssignmentDetail.dart';
import 'package:muntazim/utils/CustomColors.dart';
import 'package:muntazim/utils/Helper.dart';
import 'package:muntazim/utils/animatedDialogBox.dart';
import 'package:muntazim/utils/openDocument.dart';

class AssignmnetScreen extends StatefulWidget {
  @override
  _AssignmnetScreenState createState() => _AssignmnetScreenState();
}

class _AssignmnetScreenState extends State<AssignmnetScreen> {
  final GlobalKey<ExpansionTileCardState> stCard = new GlobalKey();

  var schoolId;
  String schoolIdName;
  StreamController<bool> dataController = StreamController<bool>.broadcast();
  PermissionService _permissionService = PermissionService();
  List<bool> tileExpansion = List<bool>.filled(4, false);
  bool tileExpansion1 = true,
      tileExpansion2 = false,
      tileExpansion3 = false,
      tileExpansion4 = false;
  final GlobalKey expansionTileKey = GlobalKey();
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
                  bodyWidget(
                      height: _height,
                      tileTitle: 'Due Assignments',
                      widgetChild:
                          assignmentData(height: _height), //_mylistview2(),
                      initiallyExpanded: tileExpansion1,
                      tileExpansionM: tileExpansion1,
                      onChange: (bool ex) {
                        setState(() {
                          if (ex) {
                            tileExpansion1 = true;
                            tileExpansion2 = false;
                            // tileExpansion[0] = ex;
                            // tileExpansion[1] = !ex;
                            // tileExpansion[2] = !ex;
                            // tileExpansion[3] = !ex;
                          } else
                            tileExpansion1 = false;
                        });

                        print(tileExpansion);
                      }),
                  SizedBox(
                    height: _height * 0.005,
                  ),
                  bodyWidget(
                      height: _height,
                      tileTitle: 'Graded Assignments',
                      widgetChild:
                          assignmentData(height: _height), //_mylistview2(),
                      tileExpansionM: tileExpansion2,
                      initiallyExpanded: tileExpansion2,
                      onChange: (bool ex) {
                        setState(() {
                          if (ex) {
                            tileExpansion1 = false;
                            tileExpansion2 = true;
                            // tileExpansion[0] = !ex;
                            // tileExpansion[1] = ex;
                            // tileExpansion[2] = !ex;
                            // tileExpansion[3] = !ex;

                          } else
                            tileExpansion2 = false;
                        });

                        print(tileExpansion);
                      }),
                  SizedBox(
                    height: _height * 0.005,
                  ),
                  bodyWidget(
                      height: _height,
                      tileTitle: 'Canceled Assignments',
                      widgetChild:
                          assignmentData(height: _height), //_mylistview2(),
                      tileExpansionM: tileExpansion3,
                      initiallyExpanded: tileExpansion3,
                      onChange: (bool ex) {
                        setState(() {
                          if (ex) {
                            tileExpansion1 = false;
                            tileExpansion2 = false;
                            tileExpansion3 = true;
                            // tileExpansion[0] = !ex;
                            // tileExpansion[1] = ex;
                            // tileExpansion[2] = !ex;
                            // tileExpansion[3] = !ex;

                          } else
                            tileExpansion3 = false;
                        });

                        print(tileExpansion);
                      })
                ],
              )),
            ),
          ),
        ),
        Helper.myHeader(text: 'Assignments', height: _height),
      ],
    );
  }

  Widget bodyWidget(
      {double height,
      Widget widgetChild,
      String tileTitle,
      bool initiallyExpanded = false,
      Function onChange,
      bool tileExpansionM}) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          trailing: tileExpansionM
              ? Icon(Icons.keyboard_arrow_up)
              : Icon(Icons.keyboard_arrow_down),
          onExpansionChanged: onChange,
          title: Helper.text(value: '$tileTitle', fSize: height * 0.02),
          children: <Widget>[
            Container(
              //height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 3.0, bottom: 10.0),
                    child: SizedBox(
                        //height: 30.0,
                        child: Wrap(
                      spacing: height * 0.1,
                      children: <Widget>[
                        Helper.text(
                            value: "Title",
                            fSize: height * 0.017,
                            fColor: Colors.black),
                        Helper.text(
                            value: "Due Date",
                            fSize: height * 0.017,
                            fColor: Colors.black),
                        Helper.text(
                            value: "Actions",
                            fSize: height * 0.017,
                            fColor: Colors.black),
                      ],
                    )),
                  ),
                  Divider(
                    thickness: 2.0,
                    height: 5,
                    indent: 10.0,
                    endIndent: 10.0,
                  ),
                  SizedBox(
                    child: widgetChild,
                  ),
                  // Flexible(
                  //   child: SizedBox(
                  //     child: widgetChild,
                  //   ),
                  // ),
                  ListTile(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget assignmentData({double height}) {
    return Column(
      children: List.generate(
          5,
          (index) => Wrap(
                children: <Widget>[
                  ListTile(
                    title: Wrap(
                      spacing: height * 0.06,
                      children: <Widget>[
                        //   Text("Assignment ${index}"),
                        //   Text("0${index}/01/2020"),
                        Helper.text(
                            value: 'Assignment ${index}',
                            fSize: height * 0.017),
                        Helper.text(
                            value: '0${index}/01/2020', fSize: height * 0.017),
                        //  Helper.text(value: 'View Details',fSize: height*0.017)
                      ],
                    ),
                    trailing: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AssignmnetDetailScreen()));
                      },
                      child: Helper.text(
                          value: 'View Details',
                          fSize: height * 0.017,
                          tDecoration: TextDecoration.underline,
                          fColor: CustomColors.buttonDarkBlueColor),
                    ),
                    // trailing: Wrap(
                    //   spacing: 10,
                    //   children: <Widget>[
                    //     InkWell(
                    //       child: Icon(
                    //         Icons.download_rounded,
                    //         color: Color.fromRGBO(5, 115, 106, 100),
                    //       ),
                    //     ),
                    //     InkWell(
                    //       child: Icon(
                    //         Icons.remove_red_eye,
                    //         color: Colors.red,
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ),
                  Divider(
                    thickness: 1,
                    height: 0,
                    indent: 10.0,
                    endIndent: 10.0,
                  ),
                ],
              )),
    );
  }

  Widget _mylistview2() {
    return ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Wrap(
            children: <Widget>[
              ListTile(
                title: Wrap(
                  spacing: 50.0,
                  children: <Widget>[
                    Text("Assignment ${index}"),
                    Text("0${index}/01/2020"),
                  ],
                ),
                trailing: Wrap(
                  spacing: 10,
                  children: <Widget>[
                    InkWell(
                      child: Icon(
                        Icons.download_rounded,
                        color: Color.fromRGBO(5, 115, 106, 100),
                      ),
                    ),
                    InkWell(
                      child: Icon(
                        Icons.remove_red_eye,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                height: 0,
                indent: 10.0,
                endIndent: 10.0,
              ),
            ],
          );
        });
  }

  Widget myAppBar(_height) {
    return AppBar(
      backgroundColor: Colors.transparent,
      // leading: Padding(
      //     padding: EdgeInsets.only(bottom: 50.0),
      //     child: Icon(Icons.menu_rounded)),
      // title: Padding(
      //   padding: EdgeInsets.only(bottom: 50.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'Welcome',
      //         style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15.0),
      //       ),
      //       Text('Raheel Zain')
      //     ],
      //   ),
      // ),
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
//
// class AssignmentScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return AssignmentScreenState();
//   }
// }
//
// class AssignmentScreenState extends State<AssignmentScreen> {
//   bool showBottomMenu = false;
//   bool isExpanded = true;
//   bool isExpanded2 = false;
//
//   Widget _mylistview2() {
//     return ListView.builder(
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           return Wrap(
//             children: <Widget>[
//               ListTile(
//                 title: Wrap(
//                   spacing: 50.0,
//                   children: <Widget>[
//                     Text("Assignment ${index}"),
//                     Text("0${index}/01/2020"),
//                   ],
//                 ),
//                 trailing: Wrap(
//                   spacing: 10,
//                   children: <Widget>[
//                     InkWell(
//                       child: Icon(
//                         Icons.download_rounded,
//                         color: Color.fromRGBO(5, 115, 106, 100),
//                       ),
//                     ),
//                     InkWell(
//                       child: Icon(
//                         Icons.remove_red_eye,
//                         color: Colors.red,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Divider(
//                 thickness: 1,
//                 height: 0,
//                 indent: 10.0,
//                 endIndent: 10.0,
//               ),
//             ],
//           );
//         });
//   }
//
//   Widget build(BuildContext context) {
//     var Screenheight = MediaQuery.of(context).size.height;
//     var ScreenWidth = MediaQuery.of(context).size.width;
//     double threshold = 100;
//     return Scaffold(
//         body: ColorfulSafeArea(
//           color: Color.fromRGBO(108, 171, 145, 10),
//           minimum: EdgeInsets.only(top: 42.0),
//           child: Container(
//               height: Screenheight,
//               decoration: BoxDecoration(color: Color.fromRGBO(228, 229, 230, 100)),
//               child: CustomScrollView(slivers: <Widget>[
//                 SliverAppBar(
//                   title: Column(
//                     children: <Widget>[
//                       Text(
//                         "Welcome to",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w300,
//                           //fontSize: 15.0,
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                       Text(Constants.loginModel.data.displayAs,
//                           style: TextStyle(
//                               fontWeight: FontWeight.w900, fontSize: 20.0))
//                     ],
//                   ),
//                   titleSpacing: 0.5,
//                   actions: <Widget>[
//                     Padding(
//                       padding: EdgeInsets.only(right: 5.0),
//                       child: CircleAvatar(
//                         backgroundColor: Color.fromRGBO(5, 115, 106, 10),
//                         radius: 23,
//                         child: CircleAvatar(
//                           radius: 20,
//                           backgroundColor: Colors.white,
//                           child: IconButton(
//                             icon: Icon(
//                               Icons.person,
//                               color: Color.fromRGBO(5, 115, 106, 10),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                   floating: true,
//                   pinned: true,
//                   backgroundColor: Color.fromRGBO(108, 171, 145, 10),
//                   expandedHeight: 100.0,
//                   flexibleSpace: FlexibleSpaceBar(
//                     title: Padding(
//                       padding: EdgeInsets.only(left: ScreenWidth * 0.1),
//                       child: Text(
//                         "ASSIGNMENTS",
//                         style: TextStyle(fontSize: 15.0, letterSpacing: 1.5),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SliverFillRemaining(
//                   child: Stack(
//                     children: <Widget>[
//                       Container(
//                         height: 80.0,
//                         decoration: BoxDecoration(
//                           color: Color.fromRGBO(5, 115, 106, 30),
//                         ),
//                         child: ListTile(
//                           leading: CircleAvatar(
//                             backgroundColor: Color.fromRGBO(5, 115, 106, 10),
//                             radius: 23,
//                             child: CircleAvatar(
//                               radius: 20,
//                               backgroundColor: Colors.white,
//                               child: IconButton(
//                                 icon: Icon(
//                                   Icons.person,
//                                   color: Color.fromRGBO(5, 115, 106, 10),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           trailing: Text(
//                             "98.50%",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20.0,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           title: Text(
//                             "Raheel zain",
//                             style: TextStyle(color: Colors.white, fontSize: 20.0),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding:
//                         EdgeInsets.only(left: 12.0, right: 12.0, top: 65.0),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 color: Color.fromRGBO(228, 229, 230, 10)),
//                             child: ExpansionTile(
//                               initiallyExpanded: true,
//                               trailing: isExpanded
//                                   ? Icon(Icons.keyboard_arrow_up)
//                                   : Icon(Icons.keyboard_arrow_down),
//                               onExpansionChanged: (bool ex) {
//                                 setState(() {
//                                   isExpanded = ex;
//                                 });
//                               },
//                               title: Text("Assignments"),
//                               children: <Widget>[
//                                 isExpanded
//                                     ? Container(
//                                   height:
//                                   MediaQuery.of(context).size.height / 2,
//                                   decoration:
//                                   BoxDecoration(color: Colors.white),
//                                   child: Column(
//                                     children: <Widget>[
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                             top: 10.0,
//                                             left: 10.0,
//                                             bottom: 10.0),
//                                         child: SizedBox(
//                                           //height: 30.0,
//                                             child: Wrap(
//                                               spacing: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                                   3.5,
//                                               children: <Widget>[
//                                                 Text(
//                                                   "Title",
//                                                   style:
//                                                   TextStyle(fontSize: 15.0),
//                                                 ),
//                                                 Text(
//                                                   "Due Date",
//                                                   style:
//                                                   TextStyle(fontSize: 15.0),
//                                                 ),
//                                                 Text(
//                                                   "Actions",
//                                                   style:
//                                                   TextStyle(fontSize: 15.0),
//                                                 ),
//                                               ],
//                                             )),
//                                       ),
//                                       Divider(
//                                         thickness: 2.0,
//                                         height: 5,
//                                         indent: 10.0,
//                                         endIndent: 10.0,
//                                       ),
//                                       Flexible(
//                                         child: SizedBox(
//                                           child: _mylistview2(),
//                                         ),
//                                       ),
//                                       ListTile(),
//                                     ],
//                                   ),
//                                 )
//                                     : SizedBox(
//                                   width: 1,
//                                   height: 1,
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ])),
//         ));
//   }
// }
