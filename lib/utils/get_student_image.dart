import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/core/services/models/studentModel/StudentModel.dart';
import 'package:muntazim/core/services/providers/AccountProvider.dart';
import 'package:muntazim/utils/CustomColors.dart';

class GetStudentImage extends StatelessWidget {
  AccountProvider model;
  GetStudentImage({
    Key key,
    @required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return StreamBuilder<StudentModel>(
        stream: model.studentStream(stId: model.studentId),
        builder: (_, photo) {
          if (!photo.hasData) {
            return CircleAvatar(
              radius: _height * 0.025,
              backgroundColor: CustomColors.lightGreenColor,
              child: CircleAvatar(
                radius: _height * 0.022,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/user_avatar.png'),
              ),
            );
          }
          return CachedNetworkImage(
            fit: BoxFit.cover,
            fadeInCurve: Curves.easeInCirc,
            imageUrl: photo.data.photo,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: _height * 0.025,
              backgroundColor: CustomColors.lightGreenColor,
              child: CircleAvatar(
                radius: _height * 0.022,
                backgroundColor: Colors.white,
                backgroundImage: imageProvider,
              ),
            ),
            placeholder: (context, url) => CircleAvatar(
              radius: _height * 0.025,
              backgroundColor: CustomColors.lightGreenColor,
              child: CircleAvatar(
                radius: _height * 0.022,
                backgroundColor: Colors.white,
                child: Helper.CIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              radius: _height * 0.025,
              backgroundColor: CustomColors.lightGreenColor,
              child: CircleAvatar(
                radius: _height * 0.022,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/user_avatar.png'),
              ),
            ),
          );
        });
  }
}
