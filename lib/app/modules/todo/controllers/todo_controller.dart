import 'package:flutter/material.dart';
import 'package:flutter_todo/data/model/todo.dart';
import 'package:get/get.dart';

enum Filter { all, active, completed }

class TodosFilter extends GetxController {
  Rx<Filter> todosFilter = Filter.all.obs;

  static TodosFilter get to => Get.find();
}

class TodosSearch extends GetxController {
  RxString searchTerm = ''.obs;
  late TextEditingController searchController;

  @override
  void onInit() {
    searchController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  static TodosSearch get to => Get.find();
}

class Todos extends GetxController {
  var todos = <Todo>[
    Todo(id: '1', text: 'Build todo app'),
    Todo(id: '2', text: 'Do homework'),
    Todo(id: '3', text: 'Wash the dish')
  ].obs;


  static Todos get to => Get.find();

  void addTodo(String todoText) {
    todos.add(Todo(text: todoText));
  }

  void removeTodo(Todo todo) {
    todos.assignAll(todos.where((t) => t.id != todo.id).toList());
  }

  void toggleTodo(int index) {
    var changed = todos[index];
    changed.completed = !changed.completed;
    todos[index] = changed;
  }

  void editTodo(int index, String desc) {
    var changed = todos[index];
    changed.text = desc;
    todos[index] = changed;
  }
}

class ActiveCount extends GetxController {
  RxInt activeCount = 0.obs;

  void calculateActiveCount() {
    activeCount.value =
        Todos.to.todos.where((todo) => !todo.completed).toList().length;
  }

  @override
  void onInit() {
    calculateActiveCount();

    ever(Todos.to.todos, (_) {
      calculateActiveCount();
    });

    super.onInit();
  }

  static ActiveCount get to => Get.find();
}

class FilteredTodos extends GetxController {
  final todos = Todos.to.todos;
  final search = TodosSearch.to.searchTerm;
  final filter = TodosFilter.to.todosFilter;

  RxList<Todo> filteredTodos = <Todo>[].obs;

  static FilteredTodos get to => Get.find();

  @override
  void onInit() {
    filteredTodos.assignAll(todos);

    everAll([todos, search, filter], (_) {
      late List<Todo> tempTodos;

      switch (filter.value) {
        case Filter.active:
          tempTodos = todos.where((todo) => !todo.completed).toList();
          break;

        case Filter.completed:
          tempTodos = todos.where((todo) => todo.completed).toList();
          break;

        case Filter.all:
        default:
          tempTodos = todos.toList();
          break;
      }

      if (search.value!.isNotEmpty) {
        tempTodos =
            tempTodos.where((t) => t.text.contains(search.value!)).toList();
      }
      filteredTodos.assignAll(tempTodos);
    });

    super.onInit();
  }
}

class TestCreate extends GetxController {
  RxInt count = 0.obs;

  // late FocusNode itemFocusNode;
  // late FocusNode textFieldFocusNode;
  // late TextEditingController textEditingController;

  // @override
  // void onInit() {
  //   itemFocusNode = FocusNode();
  //   textFieldFocusNode = FocusNode();
  //   textEditingController = TextEditingController();
  //   super.onInit();
  // }

  // void requestFocus() {
  //   itemFocusNode.requestFocus();
  //   textFieldFocusNode.requestFocus();
  //   update();
  // }

  // @override
  // void onClose() {
  //   itemFocusNode.dispose();
  //   textFieldFocusNode.dispose();
  //   textEditingController.dispose();
  //   super.onClose();
  // }

  static TestCreate get to => Get.find();
}

