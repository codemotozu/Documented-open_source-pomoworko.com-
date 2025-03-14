import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/persistent_container_notifier.dart';
import '../notifiers/project_state_notifier.dart';

final currentProjectProvider = StateProvider<String?>((ref) => null);

class BarChartProject extends ConsumerStatefulWidget {
  final Color color;
  final Icon? icon;
  final int index;
  final bool isEditable;
  final bool isEditIconVisible;
  final bool isPremiumLocked; // Nuevo parámetro


  final Function(PointerEnterEvent)? onEnterContainerHover;
  final Function(PointerExitEvent)? onExitContainerHover;

  const BarChartProject(this.color,
      {required this.index,
      this.icon,
      this.isEditable = false,
      super.key,
      this.isEditIconVisible = false,
      this.onEnterContainerHover,
      this.onExitContainerHover,
        required this.isPremiumLocked, // Nuevo parámetro requerido

       });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BarChartProjectState();
}

class _BarChartProjectState extends ConsumerState<BarChartProject> {
  final bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final selectedContainerIndex =
        ref.watch(persistentContainerIndexProvider) ?? 0;

    final projectNames = ref.watch(projectStateNotifierProvider);

    bool hasProjectName = widget.index < projectNames.length &&
        projectNames[widget.index] != 'Add a project';

    // String tooltipMessage = projectNames.isNotEmpty &&
    //         widget.index < projectNames.length &&
    //         projectNames[widget.index] != 'Add a project'
    //     ? ''
    //     : 'Add Project';

       String tooltipMessage;
    if (widget.isPremiumLocked) {
      tooltipMessage = 'Premium Feature';
    } else if (projectNames.isNotEmpty &&
        widget.index < projectNames.length &&
        projectNames[widget.index] != 'Add a project') {
      tooltipMessage = projectNames[widget.index];
    } else {
      tooltipMessage = 'Add a project';
    }

    return MouseRegion(
      onEnter: widget.onEnterContainerHover,
      onExit: widget.onExitContainerHover,
      cursor: SystemMouseCursors.click,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    ref.read(persistentContainerIndexProvider.notifier).state =
                        widget.index;

                    final projectNames =
                        ref.watch(projectStateNotifierProvider);
                    ref
                        .read(persistentContainerIndexProvider.notifier)
                        .updateIndex(widget.index);

                    ref.read(selectedProjectIndexProvider.notifier).state =
                        widget.index;
                    ref
                        .read(projectStateNotifierProvider.notifier)
                        .selectProject(widget.index);
                    ref.read(currentProjectProvider.notifier).state =
                        ref.read(projectStateNotifierProvider)[widget.index];

                    if (widget.index >= projectNames.length ||
                        projectNames[widget.index] == 'Add a project') {
                    } else {
                      // CartesianPremiumChart(
                      //   title: '',
                      // );
                      // _showEditDialog(context, 'Edit Project', 'Please edit the project name');
           
           
                    // _showPremiumDialog(context);

           
                    }
                    if (widget.index < projectNames.length) {
                      ref.read(currentProjectProvider.notifier).state =
                          projectNames[widget.index];
                    }
                  },
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
                                width: 2.0)
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
