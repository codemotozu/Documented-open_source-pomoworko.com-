import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ResponsiveShowDialogs extends ConsumerWidget {
  final Widget child;
  
  const ResponsiveShowDialogs({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return  Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 450,
          ),
          child: child,
        ),
      
    );
  }
}