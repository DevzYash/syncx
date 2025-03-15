import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncx/screens/capture_screen.dart';
import 'package:syncx/screens/provisioning_screen_controller.dart';

import 'mouse_screen.dart';

class ProvisioningScreen extends GetView<ProvisioningController> {
  const ProvisioningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProvisioningController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync X'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TextField(
                          controller: controller.ipAddressController,
                          decoration: const InputDecoration(
                            labelText: 'Enter IP Address',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: FilledButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all(Colors.green)),
                                onPressed: controller.connectToDevice,
                                child: const Text('Connect'),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: FilledButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all(Colors.red)),
                                onPressed: controller.disconnectFromDevice,
                                child: const Text('Disconnect'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(() {
                  var color = Colors.red;
                  switch (controller.status.value) {
                    case "Connected":
                      color = Colors.green;
                      break;
                    case "Disconnected":
                      color = Colors.red;
                      break;
                    case "Authenticated successfully":
                      color = Colors.green;
                      break;
                    case "Authentication failed":
                      color = Colors.red;
                      break;
                  }
                  return Text(
                    textAlign: TextAlign.center,
                    controller.status.value,
                    style: TextStyle(
                        color: color,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  );
                }),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.computer_outlined),
                              const Text(
                                'CPU Usage',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Obx(() => Text('${controller.cpuUsage.value}%')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.memory),
                              const Text(
                                'RAM Usage',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Obx(() =>
                                  Text('${controller.memoryUsage.value}%')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.storage_outlined),
                              const Text(
                                'Disk Usage',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Obx(() => Text('${controller.diskUsage.value}%')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.battery_6_bar_sharp),
                              const Text(
                                'Battery Usage',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Obx(() =>
                                  Text('${controller.batteryLevel.value}%')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                    onPressed: () {
                      controller.copyText();
                    },
                    label: Text("Copy to clipboard"),
                    icon: Icon(Icons.copy)),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                        child: FilledButton.icon(
                            onPressed: () {
                              controller.shutdownDevice();
                            },
                            label: Text("ShutDown"),
                            icon: Icon(Icons.power_off))),
                    Expanded(
                        child: FilledButton.icon(
                            onPressed: () {
                              controller.restartDevice();
                            },
                            label: Text("Restart"),
                            icon: Icon(Icons.restart_alt))),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (controller.isConnected.value) {
                            Get.to(()=>ScreenCaptureScreen());
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => ScreenCaptureScreen()),
                            // );
                          } else {
                            Get.snackbar('Error', 'Please connect first');
                          }
                        },
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.screen_share_sharp),
                                const Text(
                                  textAlign: TextAlign.center,
                                  'Screen Mirroring',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (controller.isConnected.value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MouseScreen()),
                            );
                          } else {
                            Get.snackbar('Error', 'Please connect first');
                          }
                        },
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.mouse),
                                const Text(
                                  textAlign: TextAlign.center,
                                  'Mouse & Keyboard',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
