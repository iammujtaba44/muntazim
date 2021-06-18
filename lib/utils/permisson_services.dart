import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  final PermissionHandler _permissionHandler = PermissionHandler();


  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> hasPermission(PermissionGroup permission) async {
    var permissionStatus =
    await _permissionHandler.checkPermissionStatus(permission);
    return permissionStatus == PermissionStatus.granted;
  }

  Future<bool> requestStoragePermission() async {
    bool status = await hasPermission(PermissionGroup.storage);
    if (!status) {
      return await _requestPermission(PermissionGroup.storage);
    } else {
      return true;
    }
  }

  Future<bool> requestMicrophonePermission() async {
    bool status = await hasPermission(PermissionGroup.microphone);
    if (!status ) {
      return await _requestPermission(PermissionGroup.microphone);
    } else {
      return true;
    }
  }

}
