//import json
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../../repository/local_storage_repository.dart';
import 'build_dialog.dart';

class GoPremium extends ConsumerStatefulWidget {
  const GoPremium({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoPremiumState();
}

class _GoPremiumState extends ConsumerState<GoPremium> {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 26.0, right: 26.0),
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'Upgrade to Premium',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  fontFamily: 'San Francisco',
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const BuildDialogItem(
                "Why pomoworko.com?",
                "We help you focus, manage time, and prioritize goals.",
              ),
              const SizedBox(height: 10),
              const BuildDialogItem(
                "How can we assist?",
                "Our user-friendly site lets you track time, manage tasks, boost productivity, and focus on key activities.",
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7.0),
                    topRight: Radius.circular(7.0),
                  ),
                ),
                child: CupertinoButton(
                  color: const Color(0xffF43F5E),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(7.0),
                    topRight: Radius.circular(7.0),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Your current plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'San Francisco',
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(7.0),
                    bottomRight: Radius.circular(7.0),
                  ),
                ),
                child: const Material(
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Icon(
                      CupertinoIcons.checkmark_alt,
                      size: 24,
                      color: Color(0xff3B3B3B),
                    ),
                    title: Text(
                      "Gather time weekly",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'San Francisco',
                        color: Color(0xff3B3B3B),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const Text(
                    "Pomoworko premium ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        fontFamily: 'San Francisco'),
                  ),
                  const Text(
                    "\$10.00 USD/month",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'San Francisco',
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7.0),
                        topRight: Radius.circular(7.0),
                      ),
                    ),
                    child: CupertinoButton(
                      color: const Color(0xff1BBF72),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(7.0),
                        topRight: Radius.circular(7.0),
                      ),
                      onPressed: () async {
                        final token = await LocalStorageRepository()
                            .getToken(); // Retrieve the token
                        if (token == null) {
                          print('Token not found, user not authenticated.');
                          return;
                        }
                        final response = await http.post(
                          Uri.parse(
                              'http://localhost:3001/paypal/create-subscription'),
                          headers: {
                            'Content-Type': 'application/json; charset=UTF-8',
                            'x-auth-token': token,
                          },
                        );
                        if (response.statusCode == 200) {
                          final data = jsonDecode(response.body);

                          final String href = data['links'][0]['href'];
                          html.window.location.href = href;

                          print('Full response: ${response.body}');
                        } else {
                          // If the response is not 200, log the error
                          print('Error: ${response.statusCode}');
                        }
                      },
                      child: const Text(
                        'Upgrade to premium with PayPal',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'San Francisco',
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow[100],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(7.0),
                        bottomRight: Radius.circular(7.0),
                      ),
                    ),
                    child: Material(
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
                                  color: Color(0xff3B3B3B),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "7-day free trial period",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'San Francisco',
                                      color: Color(0xff3B3B3B),
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
                                  color: Color(0xff3B3B3B),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Gather time weekly, monthly, and yearly",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'San Francisco',
                                      color: Color(0xff3B3B3B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Row(
                              children: [
                                Icon(
                                  CupertinoIcons.chart_bar,
                                  size: 24,
                                  color: Color(0xff3B3B3B),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Monthly chart:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'San Francisco',
                                      color: Color(0xff3B3B3B),
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
                                  size: 24,
                                  color: Color(0xff3B3B3B),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Yearly chart:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'San Francisco',
                                      color: Color(0xff3B3B3B),
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
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
