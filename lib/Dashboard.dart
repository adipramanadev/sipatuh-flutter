import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pelanggaran/drawer/drawer.dart';
import 'package:pelanggaran/pelanggaran/Pelanggaran.dart';
import 'package:pelanggaran/QRpage.dart/scan.dart';
import 'package:pelanggaran/siswa/Siswa.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
// import 'package:unicons/unicons.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class DashboardData {
  final int totalSiswa;
  final int totalPelanggaran;
  final int hariIni;

  DashboardData({
    required this.totalSiswa,
    required this.totalPelanggaran,
    required this.hariIni,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalSiswa: json['total_siswa'] ?? 0, // Default value if null
      totalPelanggaran: json['total_pelanggaran'] ?? 0,
      hariIni: json['hari_ini'] ?? 0,
    );
  }
}

// class dataDash {
//   // final int total;
//   final String total_siswa;
//   final String total_pelanggaran;
//   final String hari_ini;
//   final String nama;
//   final String jenis;
//   final String kelas;
//   final String kelas2;
//   final int total;
//   final int total2;
//   final int total3;

//   dataDash({
//     required this.total_siswa,
//     required this.total_pelanggaran,
//     required this.hari_ini,
//     required this.nama,
//     required this.jenis,
//     required this.kelas,
//     required this.kelas2,
//     required this.total,
//     required this.total2,
//     required this.total3,
//   });
//   factory dataDash.fromJson(Map<String, dynamic> json) {
//     return dataDash(
//       total_siswa: json['total_siswa'],
//       total_pelanggaran: json['total_pelanggaran'],
//       hari_ini: json['hari_ini'],
//       nama: json['nama'],
//       jenis: json['jenis'],
//       kelas: json['kelas'],
//       kelas2: json['kelas2'],
//       total: json['total'],
//       total2: json['total2'],
//       total3: json['total3'],
//     );
//   }
// }

class perkategori {
  // final int total;

  final String jenis;

  final int total;

  perkategori({
    required this.jenis,
    required this.total,
  });
  factory perkategori.fromJson(Map<String, dynamic> json) {
    return perkategori(
      jenis: json['jenis'] as String? ?? '', // Provide a default empty String
      total: json['total'] as int? ?? 0,
    );
  }
}

class perkelas {
  // final int total;

  final String nama;

  final int total;

  perkelas({
    required this.nama,
    required this.total,
  });
  factory perkelas.fromJson(Map<String, dynamic> json) {
    return perkelas(
      nama: json['nama'] as String? ?? '',
      total: json['total'] as int? ?? 0,
    );
  }
}

class perhari {
  final String kelas;

  final int total;

  perhari({
    required this.kelas,
    required this.total,
  });
  factory perhari.fromJson(Map<String, dynamic> json) {
    return perhari(
      kelas: json['kelas'] as String? ?? '',
      total: json['total'] as int? ?? 0,
    );
  }
}

class ProfileData {
  final String nama;
  final String email;

  ProfileData({required this.nama, required this.email});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      nama: json['nama'] == null ? "" : json['nama'],
      email: json['email'] == null ? "" : json['email'],
    );
  }
}

class _DashboardState extends State<Dashboard> {
  DashboardData? dashboardData;
  perkategori? perKategori;
  String total_siswa = "";
  String total_pelanggaran = "";
  String hari_ini = "";
  String nama = "";
  String kelas = "";
  int total1 = 0;
  int total2 = 0;
  int total3 = 0;
  String namaUser = 'Loading...';
  String emailUser = 'Loading...';
  late TooltipBehavior _tooltipBehaviorTahun;
  late TooltipBehavior _tooltipBehaviorPrestasi;
  bool isError = false;
  @override
  void initState() {
    super.initState();
    _tooltipBehaviorTahun = TooltipBehavior(enable: true);
    _tooltipBehaviorPrestasi = TooltipBehavior(enable: true);
    fetchkategori();
    fetchHarini();
    fetchPelanggaran();
    fetchProfile(
      (List<ProfileData> profileDataList) {
        ProfileData profileData = profileDataList[0];
        if (mounted) {
          setState(() {
            namaUser = profileData.nama;
            emailUser = profileData.email;
          });
        }
      },
      (String error) {
        // Menangani masalah
        print(error);
      },
    );
    fetchPelanggaran().then((data) {
      setState(() {
        dashboardData = data;
        total_siswa = data.totalSiswa.toString();
        total_pelanggaran = data.totalPelanggaran.toString();
        hari_ini = data.hariIni.toString();
      });
    }).catchError((error) {
      // Handle error...
      print("Failed to load dashboard data: $error");
    });
  }

  void fetchProfile(void Function(List<ProfileData>) onSuccess,
      void Function(String) onError) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    isError = false;
    try {
      final response = await http.get(
        Uri.parse('http://34.101.47.131/indexapi/getprofile'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': token,
        },
      );
      // Check if the response is JSON
      var contentType = response.headers['content-type'];
      if (response.statusCode == 200 &&
          contentType != null &&
          contentType.contains('application/json')) {
        final Map<String, dynamic> data = json.decode(response.body);
        final profileData = ProfileData.fromJson(data);
        onSuccess([profileData]);
        isError = true;
      } else {
        // If response is not JSON, print the response for debugging
        print('Response body: ${response.body}');
        onError(
            'Expected JSON response, got ${contentType}. Body: ${response.body}');
        isError = false;
      }
    } catch (e) {
      print('Error fetching profile: $e');
      onError('Exception caught: $e');
    }
  }

  Future<DashboardData> fetchPelanggaran() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    isError = false;
    try {
      final response = await http.get(
        Uri.parse('http://34.101.47.131/indexapi/dashboard'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': token,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        DashboardData dashboardData = DashboardData.fromJson(jsonData);
        isError = true;
        return dashboardData; // Return a single DashboardData instance
      } else {
        isError = false;
        throw Exception('Failed to load data');
      }
    } catch (e) {
      isError = false;
      throw Exception('Failed to load data: $e');
    }
  }

  Future<List<perhari>> fetchHarini() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    isError = false;
    try {
      final response = await http.get(
        Uri.parse('http://34.101.47.131/indexapi/pelanggaranbyday'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<perhari> genderData =
            jsonData.map((jsonItem) => perhari.fromJson(jsonItem)).toList();
        isError = true;
        return genderData;
      } else {
        isError;
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      if (e
          .toString()
          .contains("Connection closed before full header was received")) {}
      throw e;
    }
  }

  Future<List<perkategori>> fetchkategori() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    isError = false;
    try {
      final response = await http.get(
        Uri.parse('http://34.101.47.131/indexapi/kategoripelanggaran'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final kategori =
            data.map((item) => perkategori.fromJson(item)).toList();
        isError = true;
        return kategori;
      } else {
        isError;
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      if (e
          .toString()
          .contains("Connection closed before full header was received")) {}
      throw e;
    }
  }

  Future<List<perkelas>> fetchperkelas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    isError = false;
    try {
      final response = await http.get(
        Uri.parse('http://34.101.47.131/indexapi/pelanggaranperkelas'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final Perkelas = data.map((item) => perkelas.fromJson(item)).toList();
        isError = true;
        return Perkelas;
      } else {
        isError;
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      if (e
          .toString()
          .contains("Connection closed before full header was received")) {}
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    void openDialogProfile() {
      Get.dialog(
        AlertDialog(
          title: const Text('Pengguna'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text(""),
                  Expanded(
                    child: Text(
                      namaUser,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(""),
                  Expanded(
                    child: Text(
                      emailUser,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          ),
          actions: [
            TextButton(
              child: const Text("close"),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: const Color(0xff3a57e8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(),
        ),
        title: Row(
          children: [
            SizedBox(width: 10), // Jarak antara kotak dan teks
            Text(
              "SiPatuh",
              style: TextStyle(
                fontFamily: 'poppins',
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 22,
                color: Color(0xffffffff),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Container(
              width: 10, // Lebar kotak kecil
              height: 10, // Tinggi kotak kecil
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isError == false
                    ? Colors.red
                    : Colors.green, // Warna kotak sesuai status
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: GestureDetector(
              onTap: () {
                openDialogProfile();
              },
              child: const CircleAvatar(
                child: Icon(
                  Icons.account_circle,
                  size: 40,
                ),
                radius: 20,
              ),
            ),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const Drawer(
        width: 278,
        backgroundColor: Colors.white,
        child: DashDrawer(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          fetchPelanggaran();
          fetchHarini();
          fetchkategori();
          fetchperkelas();
          await Future.delayed(Duration(milliseconds: 4000));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GridView(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      children: [
                        Container(
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.all(0),
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(0xff3a57e8),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16.0),
                            border:
                                Border.all(color: Color(0x4d9e9e9e), width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Center(
                                child: Text(
                                  total_siswa,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 30,
                                    color: Color(0xffa6def1),
                                  ),
                                ),
                              ),
                              Text(
                                "Siswa",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.all(0),
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(0xff3a57e8),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16.0),
                            border:
                                Border.all(color: Color(0x4d9e9e9e), width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                total_pelanggaran,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 30,
                                  color: Color(0xffa7e0f3),
                                ),
                              ),
                              Text(
                                "Pelanggaran",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.all(0),
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(0xff3a57e8),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16.0),
                            border:
                                Border.all(color: Color(0x4d9e9e9e), width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                hari_ini,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 30,
                                  color: Color(0xffa3dcf0),
                                ),
                              ),
                              Text(
                                "Hari ini",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    GridView(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.1,
                      ),
                      children: [
                        Container(
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.all(0),
                          width: 130,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(0xff3956e8),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16.0),
                            border:
                                Border.all(color: Color(0x4d9e9e9e), width: 1),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Text(
                                    "Kategori Pelanggaran",
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 120,
                                  width: 140,
                                  // clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),

                                  child: FutureBuilder<List<perkategori>>(
                                      future: fetchkategori(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'),
                                          );
                                        } else {
                                          List<perkategori> kategori =
                                              snapshot.data!;

                                          return SfCircularChart(
                                            palette: const <Color>[
                                              Color.fromARGB(255, 209, 58, 12),
                                              Color.fromARGB(255, 230, 255, 43),
                                              Color.fromARGB(255, 255, 89, 43),
                                              Color.fromARGB(255, 242, 1, 97),
                                              Color.fromARGB(255, 5, 253, 96),
                                              Color.fromARGB(255, 43, 255, 241),
                                            ],
                                            tooltipBehavior:
                                                _tooltipBehaviorPrestasi,
                                            series: <CircularSeries>[
                                              PieSeries<perkategori, String>(
                                                dataSource: kategori,
                                                xValueMapper:
                                                    (perkategori data, _) =>
                                                        data.jenis,
                                                yValueMapper:
                                                    (perkategori data, _) =>
                                                        data.total,
                                                dataLabelSettings:
                                                    const DataLabelSettings(
                                                        isVisible: true),
                                                enableTooltip: true,
                                                sortingOrder:
                                                    SortingOrder.descending,
                                              )
                                            ],
                                          );
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.all(0),
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(0xff3956e8),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16.0),
                            border:
                                Border.all(color: Color(0x4d9e9e9e), width: 1),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Text(
                                    "Pelanggaran Hari ini",
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 120,
                                  width: 140,
                                  child: FutureBuilder<List<perhari>>(
                                    future: fetchHarini(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        );
                                      } else {
                                        List<perhari>? pelanggaranPerHari =
                                            snapshot.data;
                                        if (pelanggaranPerHari == null ||
                                            pelanggaranPerHari.isEmpty) {
                                          // Tampilkan konten jika tidak ada data
                                          return Center(
                                            child: Text('0'),
                                          );
                                        } else {
                                          return SfCircularChart(
                                            palette: const <Color>[
                                              Colors.amber,
                                              Color.fromARGB(255, 44, 150, 20),
                                              Color.fromARGB(255, 16, 229, 252),
                                              Color.fromARGB(255, 252, 16, 252),
                                              Color.fromARGB(255, 48, 246, 4),
                                              Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ],
                                            tooltipBehavior:
                                                _tooltipBehaviorPrestasi,
                                            series: <CircularSeries>[
                                              DoughnutSeries<perhari, String>(
                                                dataSource: pelanggaranPerHari,
                                                xValueMapper:
                                                    (perhari data, _) =>
                                                        data.kelas,
                                                yValueMapper:
                                                    (perhari data, _) =>
                                                        data.total,
                                                dataLabelSettings:
                                                    const DataLabelSettings(
                                                  isVisible: true,
                                                ),
                                                enableTooltip: true,
                                                sortingOrder:
                                                    SortingOrder.descending,
                                              )
                                            ],
                                          );
                                        }
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    GridView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.6,
                      ),
                      children: [
                        Container(
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(0),
                          width: 200,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Color(0xff3956e8),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                                color: const Color(0x4d9e9e9e), width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: const Text(
                                  "Pelanggaran Per kelas",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                              Container(
                                height: 170,
                                width: 280,
                                child: FutureBuilder(
                                  future: fetchperkelas(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Error: ${snapshot.error}'),
                                      );
                                    } else {
                                      List<perkelas> Perkelas = snapshot.data!;
                                      return SfCartesianChart(
                                        primaryXAxis: const CategoryAxis(
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 6,
                                          ),
                                        ),
                                        primaryYAxis: const NumericAxis(
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        // legend: const Legend(
                                        //   isVisible: true,
                                        //   position: LegendPosition.bottom,
                                        //   textStyle: TextStyle(
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        tooltipBehavior: _tooltipBehaviorTahun,
                                        series: <CartesianSeries>[
                                          ColumnSeries<perkelas, String>(
                                            // name: "Kelas",
                                            dataSource: Perkelas,
                                            color: Colors.amber,
                                            xValueMapper: (perkelas data, _) =>
                                                data.nama,
                                            yValueMapper: (perkelas data, _) =>
                                                data.total,
                                            dataLabelSettings:
                                                const DataLabelSettings(
                                              color: Colors.white,
                                              isVisible: true,
                                            ),
                                            enableTooltip: true,
                                          )
                                        ],
                                      );
                                    }
                                  },
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(Scan1());
        },
        backgroundColor: Color(0xFF3A57E8),
        child: Icon(Icons.qr_code_scanner_sharp, color: Colors.white),
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Color(0xFF3A57E8),
        child: Container(
          height: 30.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.info_sharp,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () => Get.to(Pelanggaran()),
              ),
              IconButton(
                icon: Icon(
                  Icons.groups_outlined,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () => Get.to(Siswa()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
