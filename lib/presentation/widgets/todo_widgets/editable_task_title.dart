import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/widgets/domain/entities/todo_entity.dart';
import '../../notifiers/providers.dart';
import '../../repository/auth_repository.dart';


class EditableTaskTitle extends ConsumerStatefulWidget {
 final Todo todo;
 const EditableTaskTitle({required this.todo, super.key});

 @override
 ConsumerState<ConsumerStatefulWidget> createState() => _EditableTaskTitleState();
}

class _EditableTaskTitleState extends ConsumerState<EditableTaskTitle> {
 static const String DEFAULT_HINT_TEXT = 'Write task title...';
 TextEditingController? _controller;
 
 @override
 void initState() {
   super.initState();
   _initializeController();
 }


void _initializeController() {
  final user = ref.read(userProvider);
  final savedTitle = user?.taskCardTitle ?? '';
  
  // Actualizar el controller y el estado
  _controller = TextEditingController(text: savedTitle);
  widget.todo.title = savedTitle;
  
  // Actualizar el provider
  if (savedTitle.isNotEmpty) {
    ref.read(taskCardTitleProvider.notifier).updateTitle(savedTitle);
  }
  
  _controller?.addListener(_handleTextChange);
}

void _handleTextChange() {
  if (_controller != null && mounted) {
    final text = _controller!.text;
    final user = ref.read(userProvider);
    
    widget.todo.title = text;
    
    if (user != null) {
      // Actualizar tanto en localStorage como en el provider
      ref.read(localStorageRepositoryProvider).setTaskCardTitle(text);
      ref.read(taskCardTitleProvider.notifier).updateTitle(text);
      
      // Actualizar en el servidor
      ref.read(authRepositoryProvider).updateCardTodoTask(
        ref.read(toDoHappySadToggleProvider),
        ref.read(taskDeletionsProvider),
        text,
      );
    }
  }
}

 @override
 void dispose() {
   _controller?.removeListener(_handleTextChange);
   _controller?.dispose();
   super.dispose();
 }

 @override
 Widget build(BuildContext context) {
   final user = ref.watch(userProvider);
   
   return Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [
       Expanded(
         child: Padding(
           padding: const EdgeInsets.only(left: 10, right: 10),
           child: SizedBox(
             width: 80,
             child: TextField(
               controller: _controller,
               maxLength: 50,
               style: GoogleFonts.nunito(
                 color: const Color(0xffF2F2F2),
                 fontSize: 20.0,
                 fontWeight: FontWeight.w500,
               ),
               decoration: const InputDecoration(
                 border: InputBorder.none,
                 hintText: DEFAULT_HINT_TEXT,
                 hintStyle: TextStyle(
                   color: Color(0xffF2F2F2),
                 ),
                 counterStyle: TextStyle(
                   color: Color(0xffF2F2F2),
                 ),
               ),
               enabled: widget.todo.isEditable,
               onChanged: (text) async {
                 widget.todo.title = text;
                 
                 if (user != null) {
                   ref.read(taskCardTitleProvider.notifier).updateTitle(text);
                  ref.read(localStorageRepositoryProvider).setTaskCardTitle(text);
                  
                   try {
                     await ref.read(authRepositoryProvider).updateCardTodoTask(
                       ref.read(toDoHappySadToggleProvider),
                       ref.read(taskDeletionsProvider),
                       text,
                     );
                   } catch (e) {
                     print('Error updating task in server: $e');
                   }
                 }


                  final focusedTaskNotifier =
                      ref.read(focusedTaskTitleProvider.notifier);
                  if (widget.todo.isFocused) {
                    focusedTaskNotifier.state = text;
                  }

              // Actualizar el título en la base de datos
                  final authRepository = ref.read(authRepositoryProvider);
                  final toDoHappySadToggle = ref.read(toDoHappySadToggleProvider);
                  final taskDeletionByTrashIcon = ref.read(taskDeletionsProvider);
                  // final taskCardTitle = ref.read(taskCardTitleProvider);
                  
                  await authRepository.updateCardTodoTask(
                    toDoHappySadToggle,
                    taskDeletionByTrashIcon,
                    text, // Enviar el nuevo título
                    // taskCardTitle,
                  );

                 if (widget.todo.isFocused) {
                   ref.read(focusedTaskTitleProvider.notifier).state = text;
                 }
               },
               maxLines: null,
               minLines: 1,
               scrollPhysics: const BouncingScrollPhysics(),
               keyboardType: TextInputType.multiline,
               inputFormatters: [
                 FilteringTextInputFormatter.deny(RegExp(r'\n'))
               ],
             ),
           ),
         ),
       ),
     ],
   );
 }
}