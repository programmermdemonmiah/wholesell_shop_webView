import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebShowViewModel extends GetxController {
  late InAppWebViewController webController;
  RxDouble progress = 0.0.obs;

  // @override
  // void onClose() {
  //   if (webController != null) {
  //     webController.dispose();
  //   }
  //   super.onClose();
  // }
}
