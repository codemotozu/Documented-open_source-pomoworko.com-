import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../../router.dart';
import '../../../../repository/auth_repository.dart';

class DeleteAccountNoPremium extends ConsumerStatefulWidget {
  const DeleteAccountNoPremium({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeleteAccountNoPremiumState();
}

//? apple design

class _DeleteAccountNoPremiumState
    extends ConsumerState<DeleteAccountNoPremium> {
  @override
  Widget build(BuildContext context) {
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
                "Delete Account",
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
                  Text(
                    'Are you sure you want to delete your account?',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'San Francisco',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),

                  Center(
                    child: Text(
                      'Data Loss',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'San Francisco',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.exclamationmark_triangle,
                            color: Colors.yellow,
                            size: 24,
                          ),
                          SizedBox(
                            width: 7.5,
                          ),
                          Expanded(
                            child: Wrap(children: [
                              Text(
                                "Any data or content associated with your account will be permanently deleted and cannot be recovered after account deletion.",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'San Francisco',
                                  color: Colors.grey,
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 5),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  // const SizedBox(height: 5),
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
                      backgroundColor: const Color(0xFF222225), //#222225
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
                              color: Colors.white),
                        ),
                      )),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 22, 0),
                  child: FloatingActionButton.extended(
                      backgroundColor: const Color(0xFFFF4433),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        final errorModel = await ref
                            .read(authRepositoryProvider)
                            .deletePremiumOrNotPremiumUser(ref);

                        if (errorModel.error == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Account deleted successfully',
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          );

                          //* for delete  users
                          ref
                              .read(userProvider.notifier)
                              .update((state) => null);
                          Routemaster.of(context).replace(HOME_ROUTE);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorModel.error!),
                            ),
                          );
                        }
                      },
                      label: const SizedBox(
                        child: Text(
                          'Delete',
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
