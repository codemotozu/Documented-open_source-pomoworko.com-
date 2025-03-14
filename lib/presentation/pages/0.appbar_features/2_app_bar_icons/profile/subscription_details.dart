import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../repository/auth_repository.dart';

class SubscriptionDetails extends ConsumerStatefulWidget {
  const SubscriptionDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SubscriptionDetailsState();
}

class _SubscriptionDetailsState extends ConsumerState<SubscriptionDetails> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    fetchAndUpdateNextBillingDate();
    fetchAndUpdateStartTimeSubscriptionPayPal();
    fetchSubscriptionStatusConfirmed();
    fetchSubscriptionStatusCancelled();
    fetchpaypalSubscriptionCancelledAt();
  }

  Future<void> fetchAndUpdateStartTimeSubscriptionPayPal() async {
    final startTimeSubscriptionPayPal = await ref
        .read(authRepositoryProvider)
        .getUserData()
        .then((value) => value.data?.startTimeSubscriptionPayPal);
    if (startTimeSubscriptionPayPal != null) {
      setState(() {
        ref.read(userProvider.notifier).state = ref
            .read(userProvider.notifier)
            .state
            ?.copyWith(
                startTimeSubscriptionPayPal: startTimeSubscriptionPayPal);
      });
    }
  }

  //? NO TIMEZONES FEATURES


  Future<void> fetchpaypalSubscriptionCancelledAt() async {
    final paypalSubscriptionCancelledAt = await ref
        .read(authRepositoryProvider)
        .getUserData()
        .then((value) => value.data?.paypalSubscriptionCancelledAt);
    if (paypalSubscriptionCancelledAt != null) {
      setState(() {
        ref.read(userProvider.notifier).state = ref
            .read(userProvider.notifier)
            .state
            ?.copyWith(
                paypalSubscriptionCancelledAt: paypalSubscriptionCancelledAt);
      });
    }
  }

  Future<bool> fetchSubscriptionStatusConfirmed() async {
    final subscriptionStatusConfirmedBool = await ref
        .read(authRepositoryProvider)
        .getUserData()
        .then((value) => value.data?.subscriptionStatusConfirmed);
    if (subscriptionStatusConfirmedBool != null) {
      setState(() {
        ref.read(userProvider.notifier).state = ref
            .read(userProvider.notifier)
            .state
            ?.copyWith(
                subscriptionStatusConfirmed: subscriptionStatusConfirmedBool);
      });
    }
    return subscriptionStatusConfirmedBool ?? false;
  }

  Future<bool> fetchSubscriptionStatusCancelled() async {
    final suscriptionStatusCancelledBool = await ref
        .read(authRepositoryProvider)
        .getUserData()
        .then((value) => value.data?.suscriptionStatusCancelled);
    if (suscriptionStatusCancelledBool != null) {
      setState(() {
        ref.read(userProvider.notifier).state =
            ref.read(userProvider.notifier).state?.copyWith(
                  suscriptionStatusCancelled: suscriptionStatusCancelledBool,
                );
      });
    }
    return suscriptionStatusCancelledBool ?? false;
  }


Future<void> fetchAndUpdateNextBillingDate() async {
  final nextBillingDate = await ref
      .read(authRepositoryProvider)
      .getUserData()
      .then((value) => value.data?.nextBillingTime);
  if (nextBillingDate != null) {
    // Convert UTC time to the user's local time zone
    final userLocalTimeZone = await ref
        .read(authRepositoryProvider)
        .getUserData()
        .then((value) => value.data?.userLocalTimeZone);

    final localNextBillingDate = nextBillingDate.toUtc().add(Duration(hours: getUserTimeZoneOffset(userLocalTimeZone)));
    setState(() {
      ref.read(userProvider.notifier).state = ref
          .read(userProvider.notifier)
          .state
          ?.copyWith(nextBillingTime: localNextBillingDate);
    });
  }
}

int getUserTimeZoneOffset(String timeZone) {
  // This function should return the offset in hours for the provided time zone
  // For simplicity, you can use a predefined map of time zones to offsets
  Map<String, int> timeZoneOffsets = {
    'PST': -8,
    'MST': -7,
    'CST': -6,
    'EST': -5,
    'GMT': 0,
    'CET': 1,
    'EET': 2,
    // Add other time zones as necessary
  };
  return timeZoneOffsets[timeZone] ?? 0;
}


  @override
  Widget build(BuildContext contex) {
    final userModel = ref.read(userProvider.notifier).state;

    final user = ref.watch(userProvider.notifier).state;

    const int trialPeriodDays = 9;

    int remainingDays = 0;
    if (userModel?.nextBillingTime != null) {
      final today = DateTime.now().toUtc();
      final trialEnd = userModel!.nextBillingTime!.toUtc();
      final trialStart =
          trialEnd.subtract(const Duration(days: trialPeriodDays));

      remainingDays = trialPeriodDays - today.difference(trialStart).inDays;

      remainingDays = remainingDays < 0 ? 0 : remainingDays;
    }

    final currentWidth = MediaQuery.of(context).size.width;


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
                "Subscription Details",
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
          const SizedBox(height: 2.5),
          RichText(
            text: const TextSpan(children: <TextSpan>[
              TextSpan(
                text: 'Your current plan is ',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'San Francisco',
                  color: Colors.grey,
                ),
              ),
              TextSpan(
                text: 'PREMIUM',
                style: TextStyle(
                  fontSize: 18,
                     color: Colors.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]),
          ),
          const SizedBox(height: 2.5),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
          const SizedBox(height: 2.5),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
            child: RichText(
              text: TextSpan(children: <TextSpan>[
                const TextSpan(
                  text: 'You have ',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'San Francisco',
                    color:  Colors.grey,
                  ),
                ),
                TextSpan(
                  text: '$remainingDays days ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'San Francisco',
                    color: Color(0xffF43F5E),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text: 'left in your free trial.',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'San Francisco',
                    color: Colors.grey,
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 2.5),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 22, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'San Francisco',
                      color: Colors.grey,
                    ),
                  ),
                  currentWidth <= 1400
                      ? const Text(
                          '\$10.00 USD/\nmonth',
                          // '\$10.00 USD/month',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'San Francisco',
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : const Text(
                          // '\$10.00 USD/\nmonth',
                          '\$10.00 USD/month',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'San Francisco',
                            fontWeight: FontWeight.w700,
                          ),
                        )
                ],
              )),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 22, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Start date',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'San Francisco',
                    color: Colors.grey,
                  ),
                ),
                Text(
                  userModel?.startTimeSubscriptionPayPal != null
                      ? DateFormat('MMM d, yyyy').format(
                          userModel!.startTimeSubscriptionPayPal!.toUtc())
                      : 'Not available',
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'San Francisco',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 22, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    currentWidth <= 555.0
                        ? (userModel?.suscriptionStatusCancelled == true
                            ? 'Access \nexpires on'
                            : 'Next \nbilling date')
                        : currentWidth <= 711.11
                            ? (userModel?.suscriptionStatusCancelled == true
                                ? 'Access \nexpires on'
                                : 'Next \nbilling date')
                            : (userModel?.suscriptionStatusCancelled == true
                                ? 'Access expires on'
                                : 'Next billing date'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'San Francisco',
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    userModel?.nextBillingTime != null
                        ? DateFormat('MMM d, yyyy')
                            .format(userModel!.nextBillingTime!.toUtc())
                        : 'Not available',
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'San Francisco',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
          Padding(
            //  padding: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                const Icon(
                  //  CupertinoIcons.exclamationmark_circle,
                  CupertinoIcons.gift,
                  size: 24,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Note: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'San Francisco',
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        TextSpan(
                          text:
                              'Your trial period includes extra days to ensure full access regardless of timezone differences.',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'San Francisco',
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
          Material(
              color: Colors.transparent,
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          CupertinoIcons.checkmark_alt,
                          size: 24,
                             color: Colors.green,
                        ),
                        Expanded(
                          child: Text(
                            "7-day free trial period",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'San Francisco',
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Icon(
                          CupertinoIcons.checkmark_alt,
                          size: 24,
                             color: Colors.green,
                        ),
                        Expanded(
                          child: Text(
                            "Gather time weekly, monthly, and yearly",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'San Francisco',
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                    const Row(
                      children: [
                        Icon(
                          CupertinoIcons.chart_bar,
                             color: Colors.green,
                          size: 24,
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                        Expanded(
                          child: Text(
                            " Monthly chart:",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'San Francisco',
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        'assets/images/premium_monthly.jpg',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(
                          CupertinoIcons.calendar,
                             color: Colors.green,
                          size: 24,
                        ),
                        Expanded(
                          child: Text(
                            " Yearly chart:",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'San Francisco',
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        'assets/images/pomodoro_timer_yearly_chart.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              )),
          if (userModel?.subscriptionStatusConfirmed == true &&
              userModel?.subscriptionStatusConfirmed != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ExpansionPanelList(
                elevation: 0,
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isExpanded = isExpanded == true;
                  });
                },
                children: [
                  ExpansionPanel(
                    backgroundColor: const Color(0xff1E1C26),
                    canTapOnHeader: true,
                    headerBuilder: (context, isExpanded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: const Text(
                              'Do you want to cancel your subscription?',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'San Francisco',
                                color: Colors.grey,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                          ),
                        ],
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 22, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_isExpanded)
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.exclamationmark_triangle,
                                  color: Colors.yellow,
                                  size: 24,
                                ),
                                const SizedBox(
                                  width: 7.5,
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'San Francisco',
                                        color: Colors.grey,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text:
                                              "Cancel anytime and enjoy premium access until ",
                                        ),
                                        TextSpan(
                                          text: userModel?.nextBillingTime !=
                                                  null
                                              ? '${DateFormat('MMM d, yyyy').format(userModel!.nextBillingTime!.toUtc())}.'
                                              : 'Not available',
                                          style: const TextStyle(
                                            color:  Colors.white,
                                            fontSize: 18,
                                            fontFamily: 'San Francisco',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const TextSpan(
                                          text:
                                              " After that, your subscription will be cancelled, and you will no longer be billed. ",
                                        ),
                                        const TextSpan(
                                          text:
                                              "We'd love for you to stay and continue your productivity journey with us!",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 15,
                          ),
                          FloatingActionButton.extended(
                            backgroundColor: Colors.redAccent,
                            onPressed: () async {
                              final authRepository =
                                  ref.read(authRepositoryProvider);
                              final result =
                                  await authRepository.cancelSubscription();

                              if (result.error == null) {
                                // Subscription cancelled successfully
                                // You can show a success message or navigate to a different page
                                print('Subscription cancelled: ${result.data}');
                              } else {
                                // Failed to cancel subscription
                                // You can show an error message or handle the error case
                                print(
                                    'Error cancelling subscription: ${result.error}');
                              }
                            },
                            label: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: const Text(
                                'Cancel Subscription',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isExpanded: _isExpanded,
                  ),
                ],
              ),
            ),
          if (userModel?.suscriptionStatusCancelled == true &&
              userModel?.suscriptionStatusCancelled != null)
            Column(
              children: [
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'San Francisco',
                        color: Colors.grey,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Your premium subscription will end on ',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'San Francisco',
                            color:Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: userModel?.nextBillingTime != null
                              ? '${DateFormat('MMM d, yyyy').format(userModel!.nextBillingTime!.toUtc())}.'
                              : 'Not available',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'San Francisco',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ' After that, your subscription will be cancelled, and you will no longer be billed',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'San Francisco',
                            color: Colors.grey,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '. We hope you\'ve found value in our app and look forward to welcoming you back anytime.',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'San Francisco',
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
