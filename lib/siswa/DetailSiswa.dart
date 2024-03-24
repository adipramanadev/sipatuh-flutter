///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Detail extends StatefulWidget {
  final String nis;
  final String nama;
  final String jenis_kelamin;
  final String kelas;
  final String alamat;
  const Detail({
    Key? key,
    required this.nis,
    required this.nama,
    required this.jenis_kelamin,
    required this.kelas,
    required this.alamat,
  });

  @override
  State<Detail> createState() => _DetailState();
}

class PrestasiData {
  final String jenis;
  final String tingkat;

  PrestasiData({
    required this.jenis,
    required this.tingkat,
  });

  factory PrestasiData.fromJson(Map<String, dynamic> json) {
    return PrestasiData(
      jenis: json['jenis'],
      tingkat: json['tingkat'],
    );
  }
}

class SiswaData {
  final String id;
  final String nis;
  final String nama;
  final String jenis_kelamin;
  final String kelas;
  final String alamat;
  final String tanggal;
  final String jenis;
  final String tingkat;

  SiswaData({
    required this.id,
    required this.nis,
    required this.nama,
    required this.jenis_kelamin,
    required this.kelas,
    required this.alamat,
    required this.tanggal,
    required this.jenis,
    required this.tingkat,
  });

  factory SiswaData.fromJson(Map<String, dynamic> json) {
    return SiswaData(
      id: json['id'] == null ? "" : json['id'],
      nis: json['nis'] == null ? "" : json['nis'],
      nama: json['nama'] == null ? "" : json['nama'],
      jenis_kelamin: json['jenis_kelamin'] == null ? "" : json['jenis_kelamin'],
      kelas: json['kelas'] == null ? "" : json['kelas'],
      alamat: json['alamat'] == null ? "" : json['alamat'],
      tanggal: json['tanggal'] == null ? "" : json['tanggal'],
      jenis: json['jenis'] == null ? "" : json['jenis'],
      tingkat: json['tingkat'] == null ? "" : json['tingkat'],
    );
  }
}

class _DetailState extends State<Detail> {
  String nis = "";
  String nama = "";
  String jenis_kelamin = "";
  String kelas = "";
  String alamat = "";
  int Pelanggaran = 0;
  int Prestasi = 0;

  List<SiswaData> searchData = [];
  List<PrestasiData> searchData2 = [];
  Widget LoadingListView = const Center(
    child: CircularProgressIndicator(),
  );
  Widget LoadingListView2 = const Center(
    child: CircularProgressIndicator(),
  );
  @override
  void initState() {
    super.initState();
    fetchDataPelanggaran("");
    fetchDataPrestasi("");
    fetchtotal();
    if (mounted) {
      nis = widget.nis;
      nama = widget.nama;
      jenis_kelamin = widget.jenis_kelamin;
      kelas = widget.kelas;
      alamat = widget.alamat;
    }
  }

  Future<void> fetchtotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    String siswanis = widget.nis;
    try {
      final response = await http.get(
        Uri.parse(
          'http://34.101.47.131/siswaapi/detail/$siswanis',
        ),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('API Response: $jsonData');

        if (jsonData.containsKey('total_pelanggaran') &&
            jsonData.containsKey('total_prestasi')) {
          setState(() {
            Pelanggaran = jsonData['total_pelanggaran'];
            Prestasi = jsonData['total_prestasi'];
          });
        } else {
          print('Error: Response does not contain data');
        }
      } else {
        print('Error: ${response.statusCode}');
        showSnackBar('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      showSnackBar('Error fetching data: $e');
    }
  }

  void fetchDataPelanggaran(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    setState(() {
      LoadingListView = const Center(
        child: CircularProgressIndicator(),
      );
    });
    String siswnis = widget.nis;
    try {
      final response = await http.get(
        Uri.parse("http://34.101.47.131/pelanggaranapi?search=${siswnis}"),
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
                Container(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      "Tidak ada Pelanggaran",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xff3a57e8),
                      ),
                    ),
                  ),
                );
              } else {
                LoadingListView = ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    searchData.sort((a, b) => a.nama.compareTo(b.nama));

                    return Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            searchData[index].jenis,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color(0xff000000),
                            ),
                          ),
                          Text(
                            searchData[index].tanggal,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
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

  void fetchDataPrestasi(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    String siswanis = widget.nis;
    setState(() {
      LoadingListView2 = const Center(
        child: CircularProgressIndicator(),
      );
    });

    try {
      final response = await http.get(
        Uri.parse("http://34.101.47.131/prestasiapi?search=$siswanis"),
        headers: {
          'Cookie': token,
        },
      );
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);

        if (decodeData is List) {
          List<PrestasiData> newDataList =
              decodeData.map((item) => PrestasiData.fromJson(item)).toList();
          print(newDataList);
          if (mounted) {
            setState(() {
              searchData2 = newDataList;
              if (newDataList.length == 0) {
                LoadingListView2 = Container(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      "Tidak ada Prestasi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xff3a57e8),
                      ),
                    ),
                  ),
                );
              } else {
                LoadingListView2 = ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    searchData2.sort((a, b) => a.jenis.compareTo(b.jenis));
                    return Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            searchData2[index].jenis,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xff000000),
                            ),
                          ),
                          Text(
                            searchData2[index].tingkat,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: searchData2.length,
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

  void showSnackBar(String message) {
    Get.snackbar(
      'Failed to fetch data',
      message,
      colorText: Colors.white,
      backgroundColor: Colors.red,
      icon: const Icon(Icons.add_alert),
    );
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
          "Detail Siswa",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 16,
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
            child: Icon(Icons.edit, color: Color(0xffffffff), size: 24),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color(0xff000000),
                          ),
                        ),
                        Text(
                          kelas,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xff3a57e8),
                          ),
                        ),
                        Text(
                          widget.nis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Color(0xff000000),
                          ),
                        ),
                        Text(
                          alamat,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                            color: Color(0xff000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    jenis_kelamin == "L" ? Icons.male : Icons.female,
                    color: jenis_kelamin == "L"
                        ? Color.fromARGB(255, 0, 47, 255)
                        : Color.fromARGB(255, 255, 0, 85),
                    size: 50,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pelanggaran",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xff646d62),
                    ),
                  ),
                  SizedBox(height: 6),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  LoadingListView
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Prestasi",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xff646d62),
                    ),
                  ),
                  SizedBox(height: 6),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  LoadingListView2
                  // Text(
                  //   "Juara 1 LKS Web Technologies",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w400,
                  //     fontSize: 14,
                  //     color: Color(0xff000000),
                  //   ),
                  // ),
                  // Text(
                  //   "Kabupaten",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w300,
                  //     fontSize: 11,
                  //     color: Color(0xff000000),
                  //   ),
                  // ),
                ],
              ),
            ),
            GridView.count(
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              physics: ScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.2,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xff3a57e8),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Pelanggaran.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 45,
                          color: Color(0xfff6f0f0),
                        ),
                      ),
                      Text(
                        "Pelanggaran",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xff3a57e8),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Prestasi.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 45,
                          color: Color(0xffffffff),
                        ),
                      ),
                      Text(
                        "Prestasi",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
