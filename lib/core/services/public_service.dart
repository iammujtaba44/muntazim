import 'package:muntazim/core/plugins.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PublicService extends ChangeNotifier {
  String _appName;
  String _packageName;
  String _version;
  String _buildNumber;

  String get appName => _appName;

  set appName(String value) {
    _appName = value;
    notifyListeners();
  }

  String get packageName => _packageName;

  set packageName(String value) {
    _packageName = value;
    notifyListeners();
  }

  String get version => _version;

  set version(String value) {
    _version = value;
    notifyListeners();
  }

  String get buildNumber => _buildNumber;

  set buildNumber(String value) {
    _buildNumber = value;
    notifyListeners();
  }

  getAllAboutApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }
}
