///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pelanggaran/Guru/EditGuru.dart';
import 'package:pelanggaran/Guru/TambahGuru.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'package:http/http.dart' as http;

class Guru extends StatefulWidget {
  const Guru({super.key});

  @override
  State<Guru> createState() => _GuruState();
}

class KotaData {
  final String id;
  final String nip;
  final String nama;
  final String jabatan;
  final String kelas_id;
  final String nomor_hp;

  KotaData(
      {required this.id,
      required this.nip,
      required this.nama,
      required this.jabatan,
      required this.kelas_id,
      required this.nomor_hp});

  factory KotaData.fromJson(Map<String, dynamic> json) {
    return KotaData(
      id: json['id'],
      nip: json['nip'],
      nama: json['nama'],
      jabatan: json['jabatan'],
      kelas_id: json['wali_kelas'],
      nomor_hp: json['nomor_hp'],
    );
  }
}

class _GuruState extends State<Guru> {
  final TextEditingController searchController = TextEditingController();
  List<KotaData> searchData = [];
  Widget LoadingListView = const Center(
    child: CircularProgressIndicator(),
  );
  Widget LoadingListView2 = const Center(
    child: CircularProgressIndicator(),
  );

  void fetchDataKota(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    setState(() {
      LoadingListView = Center(
        child: Shimmer.fromColors(
          child:
              LoadingListView2, // Ganti YourChildWidget() dengan widget yang ingin Anda tampilkan saat Shimmer aktif
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          period: Duration(seconds: 1), // Atur durasi perputaran
          direction: ShimmerDirection.ltr, // Atur arah animasi
          // Atur opsi lain sesuai kebutuhan Anda
        ),
      );
    });

    try {
      final response = await http.get(
        Uri.parse("http://34.101.47.131/guruapi/$query"),
        headers: {
          'Cookie': token,
        },
      );
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);

        if (decodeData is List) {
          List<KotaData> newDataList =
              decodeData.map((item) => KotaData.fromJson(item)).toList();
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
                LoadingListView2 = ListView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  children: [
                    Card(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
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
                LoadingListView2 = ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    searchData.sort((a, b) => a.nama.compareTo(b.nama));

                    return GestureDetector(
                      onTap: () {
                        Get.to(EditGuru(
                          id: searchData[index].id,
                          nip: searchData[index].nip,
                          nama: searchData[index].nama,
                          jabatan: searchData[index].jabatan,
                          kelas_id: searchData[index].kelas_id,
                          nomor_hp: searchData[index].nomor_hp,
                        ));
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
                                        searchData[index].nip,
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
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 0),
                                        child: Text(
                                          searchData[index].nama,
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 13,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        searchData[index].jabatan,
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
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffffffff),
                                size: 24,
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
          "Guru",
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
                  Get.to(TambahGuru());
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
                  controller: searchController,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  onSubmitted: (value) {
                    var query = searchController.text;
                    fetchDataKota(query);
                  },
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
              LoadingListView2
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to((TambahGuru()));
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
