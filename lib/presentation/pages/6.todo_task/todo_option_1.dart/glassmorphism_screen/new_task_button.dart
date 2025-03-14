import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../common/widgets/domain/entities/todo_entity.dart';
import '../../../../notifiers/providers.dart';
import '../../../../notifiers/task_notifier.dart';
import '../../../../repository/auth_repository.dart';


class NewTaskButton extends ConsumerWidget {
  final Function(Todo) onNewTask;

  

  const NewTaskButton({
    super.key,
    required this.onNewTask,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    final user = ref.watch(userProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 23.0, right: 23.0),
        ),
        FloatingActionButton.extended(
          heroTag: 'fab1',
          icon: const Icon(CupertinoIcons.add),
          label: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100, maxHeight: 20),
            child: Text(
              'Add task',
              style: GoogleFonts.nunito(
                color: const Color(0xffF2F2F2),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          backgroundColor:
          // const Color(0xff3B3B3B),
           const Color.fromARGB(255, 0, 0, 0),
          onPressed: () async {
            if (tasks.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(CupertinoIcons.lightbulb, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Your brain loves it when you tackle one task at a time. Let's embrace the power of single-tasking, and watch how efficiently you complete it!",
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            color: const Color(0xffF2F2F2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  duration: const Duration(seconds: 8),
                  // backgroundColor: const Color(0xff3B3B3B),
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                ),
              );
            } else {

              var todo = Todo(
                title: '',
                description: "",
                isEditable: true,
              );
              
              // Si el usuario está logueado, actualizar el estado en el servidor
              if (user != null) {
                ref.read(taskDeletionsProvider.notifier).set(false);
                //add the toggle
                // ref.read(todoHappySadToggleProvider.notifier).set(false);
                   ref.read(toDoHappySadToggleProvider.notifier).set(false);

                  ref.read(taskCardTitleProvider.notifier).updateTitle('');
                  // ref.read(taskCardTitleProvider.notifier).reset();

                await ref.read(authRepositoryProvider).updateCardTodoTask(
                  // ref.read(toDoHappySadToggleProvider),
                  false,
                  false,
                  ''
                );
              }
              
              // Añadir la tarea localmente
              onNewTask(todo);
              
              // Guardar en almacenamiento local
              // await HiveServices.saveTodoUUID(todo.id);
              
            }
          },
        ),
      ],
    );
  }
}


