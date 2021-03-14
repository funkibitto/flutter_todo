import 'package:flutter/material.dart';
import 'package:flutter_todo/app/modules/todo/controllers/toggle_textfield_controller.dart';
import 'package:flutter_todo/data/model/todo.dart';
import 'package:get/get.dart';
import 'package:flutter_todo/app/modules/todo/controllers/todo_controller.dart';

class TodoView extends StatelessWidget {
  final newTodoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Column(
                children: [
                  Header(),
                  TextField(
                    controller: newTodoController,
                    decoration: InputDecoration(labelText: 'What to do?'),
                    onSubmitted: (value) {
                      Todos.to.addTodo(value);
                      newTodoController.clear();
                    },
                  ),
                  const SizedBox(height: 20.0),
                  SearchAndFilter(),
                  Obx(() {
                    final currentTodos = FilteredTodos.to.filteredTodos;

                    return ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: currentTodos.length,
                      itemBuilder: (context, i) {
                        return Dismissible(
                          key: ValueKey(currentTodos[i].id),
                          onDismissed: (_) {
                            Todos.to.removeTodo(currentTodos[i]);
                          },
                          confirmDismiss: (_) {
                            return Get.defaultDialog(
                              title: 'Are you sure?',
                              middleText: 'Do you really want to delete',
                              actions: [
                                TextButton(
                                  child: Text('YES'),
                                  onPressed: () {
                                    return Get.back(result: true);
                                  },
                                ),
                                TextButton(
                                  child: Text('NO'),
                                  onPressed: () {
                                    return Get.back(result: false);
                                  },
                                ),
                              ],
                            );
                          },
                          child: TodoItem(todo: currentTodos[i]),
                        );
                      },
                      separatorBuilder: (context, i) => Divider(
                        color: Colors.grey,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Todo',
          style: TextStyle(fontSize: 40),
        ),
        Obx(
          () => Text(
            '${ActiveCount.to.activeCount} items left',
            style: TextStyle(fontSize: 18.0),
          ),
        )
      ],
    );
  }
}

class SearchAndFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: TodosSearch.to.searchController,
          decoration: InputDecoration(
            labelText: 'Search Todos ...',
            border: InputBorder.none,
            icon: Icon(Icons.search),
          ),
          onChanged: (value) {
            TodosSearch.to.searchTerm.value = value;
          },
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilterButton(filterValue: Filter.all),
            FilterButton(filterValue: Filter.active),
            FilterButton(filterValue: Filter.completed),
          ],
        ),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final Filter filterValue;

  const FilterButton({Key? key, required this.filterValue}) : super(key: key);

  Color? textColor(Filter value) {
    final todoListFilter = TodosFilter.to.todosFilter;
    return todoListFilter.value == value ? Colors.blue : Colors.grey;
  }

  String filterName(Filter value) {
    late String name;
    switch (value) {
      case Filter.active:
        name = 'ACTIVE';
        break;

      case Filter.completed:
        name = 'COMPLEATE';
        break;

      case Filter.all:
      default:
        name = 'ALL';
        break;
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        TodosFilter.to.todosFilter.value = filterValue;
      },
      child: Obx(
        () => Text(
          filterName(filterValue),
          style: TextStyle(
            color: textColor(filterValue),
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  final Todo todo;

  const TodoItem({Key? key, required this.todo}) : super(key: key);

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late FocusNode itemFocusNode;
  late FocusNode textFieldFocusNode;
  late TextEditingController textEditingController;

  @override
  void initState() {
    itemFocusNode = FocusNode();
    textFieldFocusNode = FocusNode();
    textEditingController = TextEditingController();

    super.initState();
  }

  void requestFocus() {
    setState(() {
      itemFocusNode.requestFocus();
      textFieldFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    itemFocusNode.dispose();
    textFieldFocusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      child: Focus(
        focusNode: itemFocusNode,
        onFocusChange: (value) {
          if (value) {
            textEditingController.text = widget.todo.text;
          } else {
            Todos.to.editTodo(widget.todo.id, textEditingController.text);
          }
        },
        child: ListTile(
          onTap: () {
            requestFocus();
          },
          leading: Checkbox(
            value: widget.todo.completed,
            onChanged: (value) {
              Todos.to.toggleTodo(widget.todo.id);
            },
          ),
          title: itemFocusNode.hasFocus
              ? TextField(
                  controller: textEditingController,
                  autofocus: true,
                  focusNode: textFieldFocusNode,
                )
              : Text(widget.todo.text),
        ),
      ),
    );
  }
}
