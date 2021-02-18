import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muntazim/ui/TranscriptScreen.dart';
import 'package:muntazim/ui/bottom_bar_navigation_pattern/bottom_bar_navigation_pattern_example.dart';
import 'package:muntazim/utils/AnimatedPageRoute.dart';
import 'package:muntazim/utils/CustomColors.dart';
import 'package:muntazim/utils/Helper.dart';
import 'package:muntazim/utils/animatedDialogBox.dart';

class AnnouncementsScreen extends StatefulWidget {
  @override
  _AnnouncementsScreenState createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final GlobalKey<ExpansionTileCardState> stCard = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          appBar: myAppBar(_height),
          backgroundColor: CustomColors.lightBackgroundColor,
          body: Padding(
            padding: EdgeInsets.fromLTRB(25, _height * 0.05, 25, 0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                height: _height,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListView.separated(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (contex, index) {
                          return AnnouncementBox(
                              width: _width, height: _height, index: index);
                        },
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: _height * 0.01),
                            child: Divider(
                              color: Colors.black45,
                            ),
                          );
                        },
                        itemCount: 2)
                  ],
                ),
              ),
            ),
          ),
        ),
        Helper.myAlign(text: 'Announcements', height: _height),
      ],
    );
  }

  Widget AnnouncementBox({double width, double height, int index}) {
    return Container(
      width: width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Helper.text(
            value: 'Announcement Title ${index + 1}', fSize: height * 0.03),
        Row(children: [
          Column(children: [
            Helper.text(value: 'From : Sender', fSize: height * 0.02),
            Helper.text(value: '', fSize: height * 0.02)
          ]),
          Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Helper.text(value: '01/01/2021', fSize: height * 0.02),
            Helper.text(value: '6:45', fSize: height * 0.02)
          ])
        ]),
        Helper.text(
            value:
                'All students and staff invited. This is test announcement to be sent to all parents from Muntazim App',
            fSize: height * 0.016,
            fColor: Colors.black45,
            fWeight: FontWeight.bold),
        Row(children: [
          Spacer(),
          InkWell(
            onTap: () async {
              await animated_dialog_box.showScaleAlertBox(
                  title: Column(children: [
                    Helper.text(
                        value: 'Announcement Title ${index + 1}',
                        fSize: height * 0.03),
                    Divider(
                      color: Colors.black45,
                    )
                  ]), // IF YOU WANT TO ADD
                  context: context,
                  firstButton: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Helper.text(value: '01/01/2021', fSize: height * 0.02),
                        Helper.text(value: '6:45', fSize: height * 0.02)
                      ]),
                  secondButton: Column(children: [
                    Helper.text(value: '', fSize: height * 0.02),
                    Helper.text(value: 'Share', fSize: height * 0.02),
                  ]), // IF YOU WANT TO ADD ICON
                  yourWidget: Container(
                    // height: height * 0.2,
                    margin: EdgeInsets.only(bottom: height * 0.05),
                    child: Helper.text(
                        value:
                            'All students and staff invited. This is test announcement to be sent to all parents from Muntazim App All students and staff invited. This is test announcement to be sent to all parents from Muntazim App All students and staff invited. This is test announcement to be sent to all parents from Muntazim App secondly All students and staff invited. This is test announcement to be sent to all parents from Muntazim App',
                        fSize: height * 0.016,
                        fColor: Colors.black45,
                        fWeight: FontWeight.bold),
                  ));
            },
            child: Helper.text(
                value: 'More', fSize: height * 0.02, fWeight: FontWeight.bold),
          )
        ])
      ]),
    );
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