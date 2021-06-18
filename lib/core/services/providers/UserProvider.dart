import 'package:muntazim/core/plugins.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  dynamic masjidId;
  dynamic parentId;
  dynamic parentDisplayName;
  ParentData parentData;

  void writeAs({ParentData data}) async {
    this.parentData = data;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString('isLoginData', data.encode());
    notifyListeners();
  }

  void readAs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String data = preferences.getString('isLoginData');

    if (data != null) {
      this.parentData = ParentData.decode(data);
    } else
      this.parentData = null;
    notifyListeners();
  }

  void removeAs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('isLoginData');

    this.parentData = null;
    notifyListeners();
  }
  void clearAs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();

    this.parentData = null;
    notifyListeners();
  }
}
