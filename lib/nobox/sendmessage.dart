import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pelanggaran/nobox/cache.dart';
import 'package:pelanggaran/nobox/nobox.dart';

// import '../cache.dart';
// import '../nobox.dart';
import 'loading.dart';

class Sendmessage extends StatefulWidget {
  
  @override
  _SendmessageState createState() => _SendmessageState();
}

class _SendmessageState extends State<Sendmessage> {
  String? token;
  int selectedOption = 1;
  bool visibleLink = true;
  bool visibleExtId = false;
  String? files = "";
  String? selectedTo;
  int? selectedChannel;
  String? idExtTo;
  String? ExtId = "6281249245271";
  int? selectedAccount;
  String? recipientNumber = "405270673163205";
  int? selectedMessageType;
  String? message;
  File? attachment;
  List<Link> links = [];
  var selectedAccountId;
var selectedLinkId;

  List<Account> accounts = [];
  List<Type> messageTypes = [];

  String setMessage() {
    var now = DateTime.now();
    var formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return "Test Flutter $formattedDate";
  }

  init() async {
    token = await CacheManagerService().getVariable("token");

    setState(() {
      message = setMessage();
    });
    if (token != null) {
      final nobox = Nobox(token);
      // var reqChannel = await nobox.getChannelList();
      var reqAccount = await nobox.getAccountList();
      var reqType = await nobox.getTypeList();
      // if (!reqChannel.isError) {
      //   setState(() {
      //     channels = reqChannel.data;
      //     selectedChannel = channels.isNotEmpty ? channels.first.Id : null;
      //   });
      // }
      if (!reqAccount.isError) {
        setState(() {
          accounts = reqAccount.data;
          selectedAccount = accounts.isNotEmpty ? accounts.first.Id : null;
        });
      }
      if (!reqType.isError) {
        setState(() {
          messageTypes = reqType.data;
          selectedMessageType =
              messageTypes.isNotEmpty ? messageTypes.first.value : null;
        });
      }
    }
  }


  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    void showLoading() {
      Get.dialog(LoadingDialog(), barrierDismissible: false);
    }

    void hideLoading() {
      Get.back();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Message to NoBox'),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: selectedAccount,
                decoration: const InputDecoration(
                  labelText: 'Account',
                  border: OutlineInputBorder(),
                ),
                items: accounts.map((Account account) {
                  return DropdownMenuItem<int>(
                    value: account.Id,
                    child: Text(account.Name),
                  );
                }).toList(),
                onChanged: (int? value) async {
                  var sel = accounts.where((element) => element.Id == value);
                  if (sel.isNotEmpty) {
                    var reqLinks = await Nobox(token)
                        .getLinkList(channelId: sel.first.Channel);
                    setState(() {
                      links = reqLinks.data;
                      selectedAccount = value;
                      selectedChannel = sel.first.Channel;
                    });
                  }
                },
              ),
              // const SizedBox(height: 16.0),
              ListTile(
                title: const Text('Link'),
                leading: Radio<int>(
                  value: 1,
                  groupValue: selectedOption,
                  activeColor:
                      Colors.red, // Change the active radio button color here
                  fillColor: MaterialStateProperty.all(
                      Colors.red), // Change the fill color when selected
                  splashRadius: 20, // Change the splash radius when clicked
                  onChanged: (int? value) {
                    setState(() {
                      selectedOption = value!;
                      visibleLink = true;
                      visibleExtId = false;
                    });
                  },
                ),
              ),
            
              const SizedBox(height: 16.0),
              Visibility(
                  visible: visibleLink,
                  child: DropdownButtonFormField<String>(
                    value: selectedTo,
                    decoration: const InputDecoration(
                        labelText: 'Link', border: OutlineInputBorder()),
                    items: links.map((Link links) {
                      return DropdownMenuItem<String>(
                        value: links.Id,
                        child:
                            Text(links.Name == null ? "kosong" : links.Name!),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                        var select =
          links.firstWhereOrNull((el) => el.Id == value);
      if (select != null) {
        setState(() {
          selectedTo = value;
          idExtTo = select.IdExt;

          // Save selected link id
          selectedLinkId = value;
        });
                      }
                    },
                  )),
              const SizedBox(height: 16.0),
              Visibility(
                  visible: visibleExtId,
                  child: TextFormField(
                    controller: TextEditingController(text: "6281249245271"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                        labelText: 'Ext Id', border: OutlineInputBorder()),
                    onChanged: (String? value) {
                      setState(() {
                        ExtId = value;
                      });
                    },
                  )),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                value: selectedMessageType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: messageTypes.map((Type type) {
                  return DropdownMenuItem<int>(
                    value: type.value,
                    child: Text(type.text),
                  );
                }).toList(),
                 onChanged: (int? value) async {
    var sel = accounts.where((element) => element.Id == value);
    if (sel.isNotEmpty) {
      var reqLinks = await Nobox(token)
          .getLinkList(channelId: sel.first.Channel);
      setState(() {
        links = reqLinks.data;
        selectedAccount = value;
        selectedChannel = sel.first.Channel;

        // Save selected account id
        selectedAccountId = value;
      });
    }
  },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: setMessage()),
                maxLines: 5,
                onChanged: (String value) {
                  setState(() {
                    message = value;
                  });
                },
              ),

              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () async {
                  if (selectedOption == 1) {
                    if (selectedTo != null &&
                        selectedChannel != null &&
                        selectedMessageType != null &&
                        message != null) {
                      final nobox = Nobox(token);
        showLoading();
        var reqSend = await nobox.sendInboxMessage(
            selectedTo!,
            selectedChannel!,
            "$selectedAccountId", // Use selected account id
            selectedMessageType!,
            message!,
            files!);

                      hideLoading();
                      if (!reqSend.isError) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Success'),
                              content: Text(reqSend.data),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Success'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: Text(reqSend.error.toString()),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text("Please fill all field"),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    if (ExtId != null &&
                        selectedChannel != null &&
                        selectedMessageType != null &&
                        message != null) {
                      final nobox = Nobox(token);
                      showLoading();
                      var reqSend = await nobox.sendInboxMessageExt(
                          ExtId!,
                          selectedChannel!,
                          "${selectedAccount}",
                          selectedMessageType!,
                          message!,
                          files!);

                      hideLoading();
                      if (!reqSend.isError) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Success'),
                              content: Text(reqSend.data),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Success'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: Text(reqSend.error.toString()),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text("Please fill all field"),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}
