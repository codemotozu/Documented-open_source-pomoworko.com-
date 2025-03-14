import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PremiumReadySoon extends ConsumerStatefulWidget {
  const PremiumReadySoon({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PremiumReadySoonState();
}

class _PremiumReadySoonState extends ConsumerState<PremiumReadySoon> {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(
        'The premium version is coming soon!',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: 'San Francisco',
        ),
      ),
      content: const Text(
        'We are working hard to bring you the premium version of the app. Stay tuned!',
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'San Francisco',
          color: Colors.grey,
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text(
            'OK',
            style: TextStyle(
              color: Color(0xff1BBF72),
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'San Francisco',
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
