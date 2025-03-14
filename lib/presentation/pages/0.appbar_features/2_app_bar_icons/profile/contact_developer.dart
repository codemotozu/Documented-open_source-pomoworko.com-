import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../notifiers/providers.dart';
import '../../../../repository/auth_repository.dart';

class ContactDeveloper extends ConsumerStatefulWidget {
  const ContactDeveloper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContactDeveloperState();
}

class _ContactDeveloperState extends ConsumerState<ContactDeveloper> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final userModel = ref.watch(userProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Contact with the developer",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 24,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 35,
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
          const Material(
            color: Colors.transparent,
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Email:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 5),
                  SelectableText(
                    'contact.pomoworko@gmail.com\n (for general inquiries, support, and bugs)',
                    showCursor: true,
                    scrollPhysics: ClampingScrollPhysics(),
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'San Francisco',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 22, 0),
                  child: FloatingActionButton.extended(
                      backgroundColor: const Color(0xFFFF4433),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      label: const SizedBox(
                        // width: MediaQuery.of(context).size.width ,
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'San Francisco',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
