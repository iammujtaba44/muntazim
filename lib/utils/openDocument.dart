import 'package:flutter/services.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';

void openDocument(String url) {
  var disabledElements = [
    Buttons.shareButton,
    Buttons.searchButton,
    Buttons.fillAndSignButton,
    Buttons.prepareFormButton,
    Buttons.editPagesButton,
    Buttons.toolsButton,
    Buttons.printButton
  ];
  var disabledTools = [
    Tools.annotationCreateLine,
    Tools.annotationCreateRectangle,
    Tools.annotationEdit
  ];

  var config = Config();
  config.disabledElements = disabledElements;
  config.disabledTools = disabledTools;

  PdftronFlutter.openDocument(url, config: config);
}

Future<void> initPlatformState() async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    PdftronFlutter.initialize(
        "Insert commercial license key here after purchase");
    await PdftronFlutter.version;
  } on PlatformException {
    print('Failed to get platform version.');
  }
}
