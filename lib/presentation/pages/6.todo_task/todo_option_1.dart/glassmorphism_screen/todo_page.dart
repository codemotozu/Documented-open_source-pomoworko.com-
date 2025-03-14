import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/widgets/domain/entities/todo_entity.dart';
import '../../../../notifiers/task_notifier.dart';
import '../../../../widgets/todo_widgets/card_todo_widget.dart';
import '../../../../widgets/todo_widgets/header_title_todo.dart';

class ToDoPage extends ConsumerStatefulWidget {
  const ToDoPage({super.key});

  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends ConsumerState<ToDoPage> {
  bool isActive = false;
  List<Todo> todos = [];
  @override
  void dispose() {
    for (var todo in todos) {
      todo.titleController.dispose();
      todo.descriptionController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double todoPageHeight = ref.watch(todoPageHeightProvider);

    return SizedBox(
      height: todoPageHeight,
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor:
         Color.fromARGB(255, 0, 0, 0),

        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderTitleTodo(),
            Expanded(
              child: CardTodoWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
