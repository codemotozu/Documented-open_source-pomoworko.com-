import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routemaster/routemaster.dart';

import '../../common/widgets/domain/entities/todo_entity.dart';
import '../notifiers/providers.dart';
import '../notifiers/task_notifier.dart';
import '../repository/auth_repository.dart';
import '../repository/local_storage_repository.dart';

class LoginGoogleScreen extends ConsumerWidget {
  const LoginGoogleScreen({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {

/*
    print('Attempting to sign in with Google...'); 
    try {
      final sMessenger = ScaffoldMessenger.of(context);
      final navigator = Routemaster.of(context);
      final errorModel =
          await ref.read(authRepositoryProvider).signInWithGoogle(ref);
      if (errorModel.error == null) {
          final user = errorModel.data;
          ref.read(userProvider.notifier).update((state) => user);

   // Check if the user has previously deleted the task card
    if (!user.taskDeletionByTrashIcon) {
      // Only add a new task if the user hasn't deleted it before
      var todo = Todo(
         title: user.taskCardTitle ?? '', 
        description: "",
        isEditable: true,
      );
      ref.read(taskListProvider.notifier).addTask(todo);

      // Update the server state
      await ref.read(authRepositoryProvider).updateCardTodoTask(
        user.toDoHappySadToggle,
        false,
        user.taskCardTitle??'', 
      );
    }
*/


 print('Attempting to sign in with Google...'); 
    try {
      final sMessenger = ScaffoldMessenger.of(context);
      final navigator = Routemaster.of(context);
      
      // Obtener el título guardado antes del inicio de sesión
      final localStorageRepository = ref.read(localStorageRepositoryProvider);
      final savedTaskCardTitle = await localStorageRepository.getTaskCardTitle();
      print('Saved taskCardTitle before sign in: $savedTaskCardTitle');

      final errorModel = await ref.read(authRepositoryProvider).signInWithGoogle(ref);
      
      if (errorModel.error == null) {
        final user = errorModel.data;
        print('User data after sign in: ${user.toJson()}');  // Agregar este log
        
        // Actualizar el provider con el título del usuario
        if (user.taskCardTitle.isNotEmpty) {
          print('Setting taskCardTitle from user: ${user.taskCardTitle}');
          ref.read(taskCardTitleProvider.notifier).updateTitle(user.taskCardTitle);
          // await localStorageRepository.setTaskCardTitle(user.taskCardTitle);
        } else if (savedTaskCardTitle.isNotEmpty) {
          print('Setting saved taskCardTitle: $savedTaskCardTitle');
          ref.read(taskCardTitleProvider.notifier).updateTitle(savedTaskCardTitle);
          // Actualizar en el servidor también
          await ref.read(authRepositoryProvider).updateCardTodoTask(
            user.toDoHappySadToggle,
            user.taskDeletionByTrashIcon,
            savedTaskCardTitle,
          );
        }

        ref.read(userProvider.notifier).update((state) => user);

        // Check if the user has previously deleted the task card
        if (!user.taskDeletionByTrashIcon) {
          // Crear la tarea con el título correcto
          final todoTitle = user.taskCardTitle.isNotEmpty 
              ? user.taskCardTitle 
              : savedTaskCardTitle;
              
          var todo = Todo(
            // title: todoTitle,
            title: user.taskCardTitle,
            description: "",
            isEditable: false,
          );
          
          print('Creating new todo with title: $todoTitle');
          ref.read(taskListProvider.notifier).addTask(todo);
        }

            ref.read(toDoHappySadToggleProvider.notifier).set(user.toDoHappySadToggle);
            ref.read(taskDeletionsProvider.notifier).set(user.taskDeletionByTrashIcon);

   

        // Obtener los colores guardados localmente
        final localStorageRepository = LocalStorageRepository();
        final savedPomodoroColor = await localStorageRepository.getPomodoroColor();
        final savedShortBreakColor = await localStorageRepository.getShortBreakColor();
        final savedLongBreakColor = await localStorageRepository.getLongBreakColor();

        // Si es la primera vez que el usuario inicia sesión, usar los colores por defecto
        if (savedPomodoroColor == '#74F143' && savedShortBreakColor == '#ff9933' && savedLongBreakColor == '#0891FF') {
          ref.read(darkPomodoroColorProvider.notifier).state = const Color(0xFF74F143);
          ref.read(darkShortBreakColorProvider.notifier).state = const Color(0xFFFF9933);
          ref.read(darkLongBreakColorProvider.notifier).state = const Color(0xFF0891FF);
        } else {
          // Si no es la primera vez, usar los colores guardados
          ref.read(darkPomodoroColorProvider.notifier).state = Color(int.parse(savedPomodoroColor.substring(1), radix: 16));
          ref.read(darkShortBreakColorProvider.notifier).state = Color(int.parse(savedShortBreakColor.substring(1), radix: 16));
          ref.read(darkLongBreakColorProvider.notifier).state = Color(int.parse(savedLongBreakColor.substring(1), radix: 16));
        }

        // Actualizar los colores en el servidor
        await ref.read(authRepositoryProvider).updateUserSettings(
          user.pomodoroTimer,
          user.shortBreakTimer,
          user.longBreakTimer,
          user.longBreakInterval,
          ref.read(selectedSoundProvider),
          user.browserNotificationsEnabled,
          ref.read(darkPomodoroColorProvider),
          ref.read(darkShortBreakColorProvider),
          ref.read(darkLongBreakColorProvider),
        );

         navigator.replace('/');
        Navigator.of(context).pop();
      } else {
        sMessenger.showSnackBar(
          SnackBar(
            content: Text(errorModel.error!),
          ),
        );
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () {
        print('Google sign-in button pressed.');
        signInWithGoogle(ref, context);
      },
      icon: Image.asset(
        'assets/images/google_logo.png',
        height: 20,
      ),
      label: Text(
        'Continue with Google',
        style: GoogleFonts.nunito(
            color: const Color(0xffF2F2F2),
            fontSize: 15.5,
            fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
}
