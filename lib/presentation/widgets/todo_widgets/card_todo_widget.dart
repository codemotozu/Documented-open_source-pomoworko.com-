import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../common/widgets/domain/entities/todo_entity.dart';
import '../../notifiers/providers.dart';
import '../../notifiers/task_notifier.dart';
import '../../pages/6.todo_task/todo_option_1.dart/glassmorphism_screen/widget_glassmorphism.dart';
import '../../repository/auth_repository.dart';
import 'editable_task_title.dart';
import 'null_editable_task_title.dart';
import 'todo_item_controls.dart';

class CardTodoWidget extends ConsumerStatefulWidget {
  const CardTodoWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CardTodoWidgetState();
}

class _CardTodoWidgetState extends ConsumerState<CardTodoWidget> {
  bool isActive = false;
  List<Todo> todos = [];
  static const String DEFAULT_TITLE = 'Write task title...';

  @override
  void initState() {
    super.initState();
    _initializeTaskCard();
  }

  Future<void> _initializeTaskCard() async {
    final user = ref.read(userProvider);
    if (user != null && todos.isEmpty) {
      // Crear un nuevo todo solo si no hay ninguno y el usuario está autenticado
      if (!user.taskDeletionByTrashIcon) {
        var todo = Todo(
          title: user.taskCardTitle ?? DEFAULT_TITLE,
          description: "",
          isEditable: false,
        );
        ref.read(taskListProvider.notifier).addTask(todo);
      }
    }
  }

  Future<void> _handleSave(Todo todo) async {
    final user = ref.read(userProvider);
    if (user == null) return;

    final title = todo.titleController.text;

    // No guardar si es el título por defecto
    if (title == DEFAULT_TITLE) return;

    setState(() {
      todo.title = title;
      todo.description = todo.descriptionController.text;
      todo.isEditable = false;
    });

    // Actualizar en el servidor
    await ref.read(authRepositoryProvider).updateCardTodoTask(
          ref.read(toDoHappySadToggleProvider),
          ref.read(taskDeletionsProvider),
          title,
        );

    // Actualizar estado de foco si es necesario
    if (todo.isFocused) {
      ref.read(focusedTaskProvider.notifier).state = todo;
      ref.read(focusedTaskTitleProvider.notifier).state = title;
      todo.titleController.addListener(updateFocusedTitle);
    }
  }

  @override
  void dispose() {
    for (var todo in todos) {
      todo.titleController.dispose();
      todo.descriptionController.dispose();
    }
    super.dispose();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
    });

    final Todo item = todos.removeAt(oldIndex);
    todos.insert(newIndex, item);
    ref.read(taskListProvider.notifier).reorderList(todos);
  }

  void updateFocusedTitle() {
    if (ref.read(focusedTaskProvider.notifier).state != null) {
      ref.read(focusedTaskTitleProvider.notifier).state =
          ref.read(focusedTaskProvider.notifier).state!.titleController.text;
    }
  }

  void reorderList(List<Todo> reorderedList) {}

  @override
  Widget build(BuildContext context) {
    double todoPageHeight = ref.watch(todoPageHeightProvider);
    todos = ref.watch(taskListProvider);
    final currentTaskCardTitle = ref.watch(taskCardTitleProvider);
    final user = ref.watch(userProvider);

    return SizedBox(
      height: todoPageHeight,
      child: ReorderableListView(
        onReorder: _onReorder,
        buildDefaultDragHandles: false,
        children: todos.map((todo) {
          // Si el usuario está autenticado y tiene un título guardado, úsalo
          if (user != null && user.taskCardTitle.isNotEmpty) {
            todo.title = user.taskCardTitle;
            todo.titleController.text = user.taskCardTitle;
          }

          return Padding(
            key: ValueKey(todo),
            padding: const EdgeInsets.fromLTRB(23, 8, 23, 16),
            child: Align(
              alignment: Alignment.center,
              child: Glassmorphism(
                blur: 5,
                opacity: 0.2,
                radius: 15,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                               
                                    IconButton(
                                      color: const Color(0xffF2F2F2),
                                      icon: const Icon(CupertinoIcons.pencil),
                                      onPressed: () {
                                        setState(() {
                                          todo.isEditable = !todo.isEditable;
                                          if (todo.isEditable) {
                                            // todo.originalTitle = todo.title;
                                            todo.titleController.text =
                                                todo.title; // Añade esta línea
                                            // todo.originalDescription = todo.description;
                                            todo.descriptionController.text = todo
                                                .description; // Añade esta línea
                                          }
                                        });
                                      },
                                    ),
                                    TodoItemControllers(todo: todo),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      if (user == null) EditableTaskTitleNull(todo: todo),

                      if (user != null) EditableTaskTitle(todo: todo),

                      // EditableTaskTitle(todo: todo),
                      // EditableTaskDescription(todo: todo),
                      const SizedBox(
                        height: 5,
                      ),
                      if (todo.isEditable)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                //make the button larger

                                onPressed: () async {
                               
                                  final newTitle = todo.titleController.text;

                                  // Actualizar estado local y providers
                                  setState(() {
                                    todo.title = newTitle;
                                    todo.isEditable = false;
                                  });

                               
                                  ref
                                      .read(taskCardTitleProvider.notifier)
                                      .updateTitle(newTitle);

                                  if (todo.isFocused) {
                                    ref
                                        .read(focusedTaskProvider.notifier)
                                        .state = todo;
                                    ref
                                        .read(focusedTaskTitleProvider.notifier)
                                        .state = newTitle;
                                  }

                                },

                                style: ButtonStyle(
                                  //make the button larger
                                  minimumSize: WidgetStateProperty.all(
                                      const Size(100, 50)),
                                  padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15)),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          // const Color(0xff1BBF72)),
                                          const Color(0xff36E261)),
                                  
                                
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                          const Color.fromARGB(255, 0, 0, 0)),
                                  
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                                // child: Text(
                         
                                  child: Text(
                                  'Save',
                                  style: GoogleFonts.nunito(fontSize: 18, 
                                  
                                  //add bold
                                   fontWeight: FontWeight.w800
                                 ),
                              ),
                            ),
                        
                        )],
                        )
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
