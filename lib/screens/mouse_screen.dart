import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncx/screens/provisioning_screen_controller.dart';

class MouseScreen extends StatelessWidget {
  const MouseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProvisioningController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Control'),
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard),
            onPressed: () {
              _showTypingDialog(context, controller);
            },
          ),
        ],
      ),
      
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (details) {
                  int dx =
                      (details.delta.dx * 4).round(); // Increased sensitivity
                  int dy =
                      (details.delta.dy * 4).round(); // Increased sensitivity
                  controller.socket?.emit(
                      'mouseEvent', {'event': 'move', 'dx': dx, 'dy': dy});
                },
                onTap: () {
                  controller.socket
                      ?.emit('mouseAction', {'action': 'left_click'});
                },
                onDoubleTap: () {
                  controller.socket
                      ?.emit('mouseAction', {'action': 'double_click'});
                },
                child: Container(
                  // width: Get.width, // Set width to full screen width
                  color: Colors.grey.shade400,
                  child: const Center(child: Text('Trackpad')),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.00))),
                          backgroundColor:
                              WidgetStatePropertyAll<Color>(Colors.black87)),
                      onPressed: () {
                        controller.socket
                            ?.emit('mouseAction', {'action': 'left_click'});
                      },
                      child: Text(
                        'Left',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.00))),
                          backgroundColor:
                              WidgetStatePropertyAll<Color>(Colors.black87)),
                      onPressed: () {
                        controller.socket
                            ?.emit('mouseAction', {'action': 'right_click'});
                      },
                      child: const Text(
                        'Right',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTypingDialog(
      BuildContext context, ProvisioningController controller) {
    final textController = TextEditingController();
    String previousText = '';
    FocusNode focusNode = FocusNode();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Type Here'),
          content: KeyboardListener(
            focusNode: focusNode,
            onKeyEvent: (key) {
              if (key is KeyDownEvent &&
                  key.logicalKey == LogicalKeyboardKey.backspace) {
                controller.socket?.emit('backspace');
              }
            },
            child: TextField(
              maxLines: 2,
              controller: textController,
              onChanged: (newText) {
                if (newText.length > previousText.length) {
                  // Send the new character
                  controller.socket?.emit('write',
                      {'text': newText.substring(previousText.length)});
                }
                previousText = newText;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
