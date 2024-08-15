// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebShowViewModel extends GetxController {
  @override
  void onClose() {
    webController.dispose();
    // TODO: implement onClose
    super.onClose();
  }

  // late WebViewController webController;
  late InAppWebViewController webController;
  RxDouble progress = 0.0.obs;
}
