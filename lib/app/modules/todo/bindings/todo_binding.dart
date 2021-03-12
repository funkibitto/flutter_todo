import 'package:flutter_todo/app/modules/todo/controllers/toggle_textfield_controller.dart';
import 'package:get/get.dart';

import 'package:flutter_todo/app/modules/todo/controllers/todo_controller.dart';

class TodoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodosFilter>(
      () => TodosFilter(),
    );
    Get.lazyPut<TodosSearch>(
      () => TodosSearch(),
    );
    Get.lazyPut<Todos>(
      () => Todos(),
    );
    Get.lazyPut<ActiveCount>(
      () => ActiveCount(),
    );
    Get.lazyPut<FilteredTodos>(
      () => FilteredTodos(),
    );
    // Get.lazyPut<ToggleTextfieldController>(
    //   () => ToggleTextfieldController(),
    // );
    // Get.create<ToggleTextfieldController>(
    //   () => ToggleTextfieldController(),
    // );

    // Get.lazyPut<ToggleTextfieldController>(
    //   () => ToggleTextfieldController(),
    // );
    // Get.create<TestCreate>(
    //   () => TestCreate(),
    // );

    Get.lazyPut<TestCreate>(
      () => TestCreate(),
    );
  }
}
