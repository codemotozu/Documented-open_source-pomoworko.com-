import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class BuildDialogItem extends ConsumerStatefulWidget {
  final String title;
  final String description;
  const BuildDialogItem(
    this.title,
    this.description, {super.key}
  );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BuildDialogItemState();
}

class _BuildDialogItemState extends ConsumerState<BuildDialogItem> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          textAlign: TextAlign.left,
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              fontFamily: 'San Francisco'),
        ),
        const SizedBox(height: 5),
        Text(
          widget.description,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'San Francisco',
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}