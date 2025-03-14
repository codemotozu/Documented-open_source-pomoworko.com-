import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../../router.dart';
import '../../../../notifiers/providers.dart';
import '../../../../repository/auth_repository.dart';

class DeleteAccountPremium extends ConsumerStatefulWidget {
  const DeleteAccountPremium({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeleteAccountPremiumState();
}

class _DeleteAccountPremiumState extends ConsumerState<DeleteAccountPremium> {
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
                      'Subscription Canceled',
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
                                "Your monthly subscription for premium features will be immediately canceled and no further charges will be made.",
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
                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  Center(
                    child: Text(
                      'Premium Access Revoked',
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
                                "You will lose access to all premium content and features upon account deletion.",
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
                      backgroundColor: const Color(0xFF222225),
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
              if (userModel?.subscriptionStatusConfirmed == true)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 22, 0),
                    child: FloatingActionButton.extended(
                      backgroundColor: Colors.grey,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: const Text(
                                'Before deleting your account',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    fontFamily: 'San Francisco'),
                              ),
                              content: const Text(
                                "Please remember to cancel your active subscription first in the \"Subscription Details\" section. This will ensure that you don't encounter any billing issues. Once you have canceled your subscription, you can proceed to delete your account",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'San Francisco',
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.left,
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
                          },
                        );
                      },
                      label: const SizedBox(
                        child: Text(
                          'Delete',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              if (userModel?.suscriptionStatusCancelled == true)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 22, 0),
                    child: FloatingActionButton.extended(
                        backgroundColor: Colors.redAccent,
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
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        )),
                  ),
                ),
              //?the following code delete and cancel the subscription at the same time but it triggers an error

              /*
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 22, 0),
                  child: FloatingActionButton.extended(
                      backgroundColor: Colors.redAccent,
                      onPressed: () {
                         
                      },
                      
                      //?the following code delete and cancel the subscription at the same time but it triggers an error
                      /*
                      onPressed: () async {
                        Navigator.of(context).pop();
                        final authRepository = ref.read(authRepositoryProvider);

                        final cancelResult =
                            await authRepository.cancelSubscription();
                        if (cancelResult.error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to cancel subscription: ${cancelResult.error}',
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          );

                          return;
                        }

                        final deleteResult = await authRepository
                            .deletePremiumOrNotPremiumUser();
                        if (deleteResult.error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to delete account: ${deleteResult.error}',
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Account deleted successfully and subscription cancelled',
                              style: GoogleFonts.nunito(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        );
                        ref.read(userProvider.notifier).update((state) => null);
                        Routemaster.of(context).replace(HOME_ROUTE);
                      },
                      */

                      label: const SizedBox(
                        child: Text(
                          'Delete',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      )),
                ),
              ),
           */
            ],
          )
        ],
      ),
    );
  }
}
