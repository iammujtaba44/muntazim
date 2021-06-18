
import 'dart:async';

import 'package:muntazim/core/plugins.dart';

class HeaderView extends StatefulWidget {
  Function onTap;
  String name;
  HeaderView({this.name,this.onTap});
  @override
  _HeaderViewState createState() => _HeaderViewState();
}

class _HeaderViewState extends State<HeaderView> {
  bool isDrawerOpen = false;
  StreamController _drawerController = StreamController<bool>.broadcast();
  DrawerService _drawerService;



  @override
  void initState() {
    super.initState();
    _drawerController.add(false);
    _drawerService = Provider.of(context, listen: false);
    _listenDrawerService();
    Future.delayed(Duration(milliseconds: 200),(){
      _drawerController.sink.add(true);
    });

    // DatabaseServices().test();
  }
  _listenDrawerService() {
    _drawerService.status.listen((status) {
      isDrawerOpen = status;
      _drawerController.sink.add(true);
    });
  }
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: _drawerController.stream,
        builder: (context,drawerShot){
          if(!drawerShot.hasData)
            return Center();
          else
          {
            return Helper.myHeader(
                text: '${widget.name}',
                height: _height,
                isDrawerOpen: this.isDrawerOpen,
                onTap: widget.onTap);
          }
        });
  }
}
