import 'package:get/get.dart';

import 'package:flutter_todo/app/modules/todo/bindings/todo_binding.dart';
import 'package:flutter_todo/app/modules/todo/views/todo_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.TODO;

  static final routes = [
    GetPage(
      name: _Paths.TODO,
      page: () => TodoView(),
      binding: TodoBinding(),
    ),
  ];
}
