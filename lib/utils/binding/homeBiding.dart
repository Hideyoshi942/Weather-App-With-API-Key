import 'package:get/get.dart';
import 'package:weartherproject/controller/homeController.dart';

class HomeBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(city: 'Hà Nội'));
  }
}