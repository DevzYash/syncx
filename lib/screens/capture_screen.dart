import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncx/screens/capture_screen_controller.dart';

class ScreenCaptureScreen extends GetView<CaptureScreenController> {
  const ScreenCaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CaptureScreenController());
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            CircleAvatar(
                child: IconButton(
                    onPressed: () {
                     Get.back();
                    },
                    icon: Icon(Icons.arrow_back))),
            Expanded(
              child: Obx(() => Image(
                    image: MemoryImage(
                        controller.provisioningController.screenCapture.value),
                    height: Get.height,
                    fit: BoxFit.fill,
                  )),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
      ),
    );
  }
}
