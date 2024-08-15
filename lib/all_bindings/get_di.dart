import 'package:get/get.dart';
import 'package:wholesell_shop/view_model/controller/web_view/web_show_view_model.dart';

init() {
  Get.lazyPut(() => WebShowViewModel(), fenix: true);
}
