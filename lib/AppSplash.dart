///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class AppSplash extends StatefulWidget {
  const AppSplash({super.key});

  @override
  State<AppSplash> createState() => _AppSplashState();
}

class _AppSplashState extends State<AppSplash> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
         backgroundColor: const Color(0xffffffff),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Color.fromARGB(108, 222, 222, 222),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(color: Color(0x4d9e9e9e), width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ///***If you have exported images you must have to copy those images in assets/images directory.
                      Image(
                        image: AssetImage("asset/logoapp (1).png"),
                        height: 140,
                        width: 140,
                        fit: BoxFit.fitHeight,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "SiPatuh ",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontSize: 25,
                              color: Color(0xff3a57e8),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "App",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 25,
                            color: Color(0xff3a57e8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
