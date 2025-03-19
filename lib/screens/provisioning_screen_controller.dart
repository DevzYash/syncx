import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ProvisioningController extends GetxController {
  final ipAddressController = TextEditingController();
  final passwordController = TextEditingController();
  final status = RxString('');
  final isConnected = RxBool(false);
  final isAuthorized = RxBool(false);
  final cpuUsage = RxDouble(0);
  final memoryUsage = RxDouble(0);
  final diskUsage = RxDouble(0);
  final batteryLevel = RxString("");
  final screenCapture = Uint8List(0).obs;
  bool _isDialogOpen = false;

  IO.Socket? socket;

  void connectToDevice() async {
    final ipAddress = ipAddressController.text;

    if (socket != null) {
      socket?.disconnect();
    }

    socket = IO.io(
      'http://$ipAddress:6969',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNewConnection()
          .enableAutoConnect()
          .build(),
    );

    socket?.onError((error) {
      print('Error occurred: $error');
    });

    socket?.onConnectError((error) {
    });

    socket?.onConnect((_) {
      status.value = 'Connected';
      isConnected.value = true;
      if (!isAuthorized.value && !_isDialogOpen) {
        _showPasswordDialog();
      }
    });

    socket?.onDisconnect((_) {
      status.value = 'Disconnected';
      isConnected.value = false;
      isAuthorized.value = false;
      _isDialogOpen = false;
      cpuUsage.value = 0;
      memoryUsage.value = 0;
      diskUsage.value = 0;
      batteryLevel.value = "0";
    });

    socket?.on('auth_success', (data) {
      status.value = 'Authenticated successfully';
      isAuthorized.value = true;
      Get.snackbar('Success', 'Connected and authenticated');
    });

    socket?.on('auth_failure', (data) {
      status.value = 'Authentication failed';
      Get.snackbar('Error', 'Authentication failed');
      socket?.disconnect();
    });

    socket?.on('resource_usage', (data) {
      cpuUsage.value = data['cpu'];
      memoryUsage.value = data['memory'];
      diskUsage.value = data['disk'];
    });

    socket?.on('screen_capture', (data) {
      final bytes = base64Decode(data['image']);
      screenCapture.value = bytes;
    });

    socket?.on('battery_level', (data) {
      batteryLevel.value = data['battery'].toString();
    });

    socket?.on('clipboard_text', (data) async {
      if (data != null) {
        await Clipboard.setData(ClipboardData(text: data['text'].toString()));
      }
    });
  }

  void disconnectFromDevice() {
    socket?.disconnect();
  }

  void copyText() {
    socket?.emit('copy');
  }

  void restartDevice() {
    askConfirmationDialog("restart the device", (){
      socket?.emit('restart');
    });
  }

  void shutdownDevice() {
    askConfirmationDialog("shut down the device", (){
      socket?.emit('shutdown');
    });
  }

  askConfirmationDialog(title, Function() onConfirm){
    Get.defaultDialog(
      title: "Alert",
      middleText: "Are you sure you want to $title",
      onConfirm: onConfirm,
      onCancel: (){
        Get.back();
      }
    );
  }

  void _showPasswordDialog() {
    _isDialogOpen = true;
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Password'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!socket!.disconnected) {
                  socket?.disconnect();
                }
                Navigator.of(context).pop();
                _isDialogOpen = false;
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                socket?.emit('auth', {'password': passwordController.text});
                Navigator.of(context).pop();
                _isDialogOpen = false;
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    ).then((value) {
      _isDialogOpen = false;
    });
  }
}
