import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncx/screens/provisioning_screen_controller.dart';

class CaptureScreenController extends GetxController {
  final ProvisioningController provisioningController = Get.find();
  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    provisioningController.socket?.emit('start_screen_capture');
  }

  @override
  void onClose() {
    provisioningController.socket?.emit('stop_screen_capture');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.onClose();
  }
}
