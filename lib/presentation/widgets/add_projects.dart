import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/persistent_container_notifier.dart';
import '../notifiers/project_state_notifier.dart';
import '../notifiers/project_time_notifier.dart';
import '../notifiers/providers.dart';


class AddProyectName extends ConsumerStatefulWidget {
  final Color color;
  final Icon? icon;
  final int index;
  final bool isEditable;
  final bool isEditIconVisible;

  final Function(PointerEnterEvent)? onEnterContainerHover;
  final Function(PointerExitEvent)? onExitContainerHover;

  const AddProyectName(this.color,
      {required this.index,
      this.icon,
      this.isEditable = false,
      super.key,
      this.isEditIconVisible = false,
      this.onEnterContainerHover,
      this.onExitContainerHover});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddProyectNameState();
}

class _AddProyectNameState extends ConsumerState<AddProyectName> {
  bool _isHovered = false;



@override
Widget build(BuildContext context) {
  final projectNames = ref.watch(projectStateNotifierProvider);
  final selectedContainerIndex = ref.watch(persistentContainerIndexProvider);
  bool hasProjectName = widget.index < projectNames.length &&
      projectNames[widget.index] != 'Add a project';

  String tooltipMessage = projectNames.isNotEmpty &&
          widget.index < projectNames.length &&
          projectNames[widget.index] != 'Add a project'
      ? ''
      : widget.isEditable ? 'Add a Project' : 'Premium Feature';

  return MouseRegion(
    onEnter: widget.onEnterContainerHover,
    onExit: widget.onExitContainerHover,
    cursor: SystemMouseCursors.click,
    child: Container(
      height: 66,
      width: 27,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.transparent,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: widget.isEditable
                      ? () {
                          ref.read(persistentContainerIndexProvider.notifier).updateIndex(widget.index);

                          if (widget.index >= projectNames.length ||
                              projectNames[widget.index] == 'Add a project') {
                            _showAddDialog(context, 'Add a Project',
                                'Please, add a name for the project');
                          }
                        }
                      : null,
                  child: Tooltip(
                    message: tooltipMessage,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: selectedContainerIndex == widget.index
                            ? Border.all(
                                color: const Color.fromARGB(255, 228, 228, 228),
                                width: 2.5)
                            : null,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.color,
                          shape: BoxShape.circle,
                          border: selectedContainerIndex == widget.index
                              ? Border.all(color: Colors.black, width: 1.0)
                              : null,
                        ),
                        child: widget.icon != null
                            ? Center(child: widget.icon)
                            : null,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: hasProjectName &&
                      selectedContainerIndex == widget.index &&
                      widget.isEditIconVisible,
                  replacement: const SizedBox(
                    height: 40,
                    width: 25,
                  ),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => _isHovered = true),
                    onExit: (_) => setState(() => _isHovered = false),
                    cursor: SystemMouseCursors.click,
                    child: Tooltip(
                      message: "Edit Project",
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isHovered
                              ? Colors.white30
                              : Colors.transparent,
                        ),
                        height: 40,
                        width: 25,
                        child: GestureDetector(
                          onTap: () {
                            _showEditDialog(context, 'Edit Project',
                                'Please edit the project name', widget.index);
                          },
                          child: const Icon(Icons.edit,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void _showAddDialog(BuildContext context, String title, String placeholder) {
  String projectTitle = '';
  final selectedContainerIndex = ref.watch(persistentContainerIndexProvider);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(placeholder),
            const SizedBox(height: 16),
            CupertinoTextField(
              placeholder: 'Project name',
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                projectTitle = value;
              },
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              if (projectTitle.isNotEmpty) {
                ref.read(projectStateNotifierProvider.notifier)
                    .addProject(projectTitle, selectedContainerIndex, ref);
                ref.read(projectTimesProvider.notifier).addTime(
                    selectedContainerIndex, DateTime.now(), Duration.zero);
              }
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

void _showEditDialog(BuildContext context, String title, String placeholder, int index) {
  String projectTitle = '';
  final selectedContainerIndex = ref.watch(persistentContainerIndexProvider);
  final projectNames = ref.watch(projectStateNotifierProvider);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(placeholder),
            const SizedBox(height: 16),
            CupertinoTextField(
              placeholder: 'Project name',
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                projectTitle = value;
              },
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              // if (projectTitle.isNotEmpty &&
              //     selectedContainerIndex < projectNames.length) {
              //   ref
              //       .read(projectStateNotifierProvider.notifier)
              //       .updateProject(selectedContainerIndex, projectTitle);
              // }
                    if (projectTitle.isNotEmpty) {
                  ref.read(persistentContainerIndexProvider.notifier).updateIndex(index);
                  ref.read(projectStateNotifierProvider.notifier)
                      .addProject(projectTitle, index, ref);
                  ref.read(projectTimesProvider.notifier).addTime(
                      index, DateTime.now(), Duration.zero);
                }
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
}
