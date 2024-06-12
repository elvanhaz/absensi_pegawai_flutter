import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/op_controller.dart';

class OpView extends GetView<OpController> {
  const OpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'OpView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
