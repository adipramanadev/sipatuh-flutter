///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pelanggaran/wali/EditWali.dart';
import 'package:pelanggaran/wali/TambahWali.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Walimurid extends StatefulWidget {
  const Walimurid({super.key});

  @override
  State<Walimurid> createState() => _WalimuridState();
}

class SiswaData {
  final String id;
  final String nama;
  final String siswa;
  final String kelas;
  final String status;
  final String nomor_hp;

  SiswaData(
      {required this.id,
      required this.nama,
      required this.siswa,
      required this.kelas,
      required this.status,
      required this.nomor_hp});

  factory SiswaData.fromJson(Map<String, dynamic> json) {
    return SiswaData(
      id: json['id'] == null ? "" : json['id'],
      nama: json['nama'] == null ? "" : json['nama'],
      siswa: json['siswa'] == null ? "" : json['siswa'],
      kelas: json['kelas'] == null ? "" : json['kelas'],
      status: json['status'] == null ? "" : json['status'],
      nomor_hp: json['nomor_hp'] == null ? "" : json['nomor_hp'],
    );
  }
}

class _WalimuridState extends State<Walimurid> {
  final TextEditingController searchController = TextEditingController();
  List<SiswaData> searchData = [];
  Widget LoadingListView = const Center(
    child: CircularProgressIndicator(),
  );

  void fetchDataKota(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    setState(() {
      LoadingListView = const Center(
        child: CircularProgressIndicator(),
      );
    });

    try {
      final response = await http.get(
        Uri.parse("http://34.101.47.131/walimuridapi"),
        headers: {
          'Cookie': token,
        },
      );
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);

        if (decodeData is List) {
          List<SiswaData> newDataList =
              decodeData.map((item) => SiswaData.fromJson(item)).toList();
          if (mounted) {
            setState(() {
              searchData = newDataList;
              if (newDataList.length == 0) {
                Get.snackbar(
                  'Kosong',
                  "Data tersebut tidak ada",
                  colorText: Colors.white,
                  backgroundColor: Colors.orange,
                  icon: const Icon(Icons.add_alert),
                );
                LoadingListView = ListView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  children: [
                    Card(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      color: const Color(0xff3c59ee),
                      shadowColor: const Color(0x4d939393),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                            color: Color(0x4d9e9e9e), width: 1),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Guru Tidak Ditemukan",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                                color: Color(0xffffffff),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xffffffff),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                LoadingListView = ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    searchData.sort((a, b) => a.nama.compareTo(b.nama));

                    return GestureDetector(
                      onTap: () {
                        // Get.to(EditGuru(
                        // id : searchData[index].id,
                        // nip : searchData[index].nip,
                        // nama : searchData[index].nama,
                        // jabatan : searchData[index].jabatan,
                        // kelas_id : searchData[index].kelas_id,
                        // nomor_hp : searchData[index].nomor_hp,

                        // ));
                      },
                      child: Card(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        color: Color(0xff3a57e8),
                        shadowColor: Color(0x4d939393),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        searchData[index].nama,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 15,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                      Text(
                                        "Ayah dari " + searchData[index].siswa,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(EditWali());
                                },
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xffffffff),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: searchData.length,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                );
              }
            });
          }
        } else {
          Get.snackbar(
            'Gagal Mencari Data',
            "Invalid Data Format",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.add_alert),
          );
        }
      } else {
        Get.snackbar(
          'Gagal Mencari',
          "Error ${response.reasonPhrase}",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.add_alert),
        );
      }
    } catch (e) {
      if (e
          .toString()
          .contains("Connection closed before full header was received")) {
        // Handle the specific error condition here
        // You can add custom handling logic for this case
        Get.snackbar(
          'Gagal meload data',
          "Error:{$e} Connection closed before full header was received",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.add_alert),
        );
      }
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataKota("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff3a57e8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Wali Murid",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            color: Color(0xffffffff),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
            size: 24,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
                onTap: () {
                  Get.to(TambahWali());
                },
                child:
                    Icon(Icons.add_circle, color: Color(0xffffffff), size: 24)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: TextField(
                  controller: TextEditingController(),
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide:
                          BorderSide(color: Color(0xffa09797), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide:
                          BorderSide(color: Color(0xffa09797), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide:
                          BorderSide(color: Color(0xffa09797), width: 1),
                    ),
                    hintText: "Pencarian",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xffacb1c6),
                    ),
                    filled: true,
                    fillColor: Color(0xfff1f4f8),
                    isDense: false,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    suffixIcon:
                        Icon(Icons.search, color: Color(0xffafb4c9), size: 24),
                  ),
                ),
              ),
              LoadingListView,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to((TambahWali()));
        },
        hoverElevation: 40,
        hoverColor: const Color(0xFFF9F871),
        backgroundColor: const Color(0xFFFFc253),
        child: const Icon(
          Icons.add,
          size: 24,
          color: Colors.black,
        ),
      ),
    );
  }
}
