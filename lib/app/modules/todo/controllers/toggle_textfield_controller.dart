import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToggleTextfieldController extends GetxController {
  late FocusNode itemFocusNode;
  late FocusNode textFieldFocusNode;
  late TextEditingController textEditingController;

  static ToggleTextfieldController get to => Get.find();

  @override
  void onInit() {
    itemFocusNode = FocusNode();
    textFieldFocusNode = FocusNode();
    textEditingController = TextEditingController();
    super.onInit();
  }

  void requestFocus() {
    itemFocusNode.requestFocus();
    textFieldFocusNode.requestFocus();
    update();
  }

  @override
  void onClose() {
    itemFocusNode.dispose();
    textFieldFocusNode.dispose();
    textEditingController.dispose();
    super.onClose();
  }
}