///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:pelanggaran/kelas/kelas.dart';
import 'package:pelanggaran/drawer/drawer.dart';
import 'package:pelanggaran/pelanggaran/Pelanggaran.dart';
// import 'package:pelanggaran/prestasi/Listprestasi.dart';

import 'package:pelanggaran/QRpage.dart/scan.dart';
import 'package:pelanggaran/siswa/Siswa.dart';
// import 'package:pelanggaran/nobox/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
// import 'package:unicons/unicons.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class data {
  // final int total;
  final String data1;
  final String data2;
  final String data3;
  final String data4;
  final String data5;

  data(
      {required this.data1,
      required this.data2,
      required this.data3,
      required this.data4,
      required this.data5});
  factory data.fromJson(Map<String, dynamic> json) {
    return data(
      // total: json['total_siswa'],
      data1: json['data'],
      data2: json['data'],
      data3: json['data'],
      data4: json['data'],
      data5: json['total'],
    );
  }
}

class TahunData {
  final int total;
  final String tahun;

  TahunData({required this.total, required this.tahun});

  factory TahunData.fromJson(Map<String, dynamic> json) {
    return TahunData(
      total: json['total'],
      tahun: json['nama'].toString(),
    );
  }
}

class PrestasiData {
  final int total;
  final String nama;
  // final String kelas;

  PrestasiData({
    required this.total,
    required this.nama,
    // required this.kelas,
  });

  factory PrestasiData.fromJson(Map<String, dynamic> json) {
    return PrestasiData(
      total: json['total'],
      nama: json['nama'],
      // kelas: json['kelas'],
    );
  }
}

class Hariini {
  final int total;

  final String kelas;

  Hariini({
    required this.total,
    required this.kelas,
  });

  factory Hariini.fromJson(Map<String, dynamic> json) {
    return Hariini(
      total: json['total'],
      kelas: json['kelas'],
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
  String data1 = "";
  String data2 = "";
  String data3 = "";
  String data4 = "";
  String data5 = "";
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
    fecthTahunKel();
    fetchdata1();
    fetchdata2();
    fetchdata3();
    fetchdata4();
    fetchdata5();

    fetchProfile(
      (List<ProfileData> profileDataList) {
        ProfileData profileData = profileDataList[0];
        if (mounted) {
          setState(() {
            // ignore: unnecessary_cast
            namaUser = profileData.nama as String;
            emailUser = profileData.email;
          });
        }
      },
      (String error) {
        // Menangani masalah
        print(error);
      },
    );
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
      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> data = json.decode(response.body);
          final profileData = ProfileData.fromJson(data);
          onSuccess([profileData]);
        } catch (e) {
          onError('Gagal mendecode data: ${e.toString()}');
        }
      } else {
        onError('Gagal mengambil data: ${response.statusCode}');
        // isError = false;
      }
    } catch (e) {
      if (e
          .toString()
          .contains("Connection closed before full header was received")) {}
      throw e;
    }
  }

  Future<List<Hariini>> fecthPrestasi() async {
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
        final List<Hariini> genderData =
            jsonData.map((jsonItem) => Hariini.fromJson(jsonItem)).toList();
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

  Future<List<PrestasiData>> fetchPelanggaran() async {
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
        final List<dynamic> jsonData = json.decode(response.body);
        final List<PrestasiData> genderData = jsonData
            .map((jsonItem) => PrestasiData.fromJson(jsonItem))
            .toList();
        isError = true;
        return genderData;
      } else {
        isError;
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      if (e
          .toString()
          .contains("Connection closed before full header was received")) {
        //handle the specific error condition here
        //you can add custom headling logic for this case
        // Get.snackbar(
        //   'Gagal meload data',
        //   "Error:{$e} Connection closed before full header was received",
        //   colorText: Colors.white,
        //   backgroundColor: Colors.red,
        //   icon: const Icon(Icons.add_alert),
        // );
      }
      throw e;
    }
  }

  Future<List<TahunData>> fecthTahunKel() async {
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
        final tahunData = data.map((item) => TahunData.fromJson(item)).toList();
        isError = true;
        return tahunData;
      } else {
        isError = false;
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      if (e
          .toString()
          .contains("Connection closed before full header was received")) {
        //handle the specific error condition here
        //you can add custom headling logic for this case
        // Get.snackbar(
        //   'Gagal meload data',
        //   "Error:{$e} Connection closed before full header was received",
        //   colorText: Colors.white,
        //   backgroundColor: Colors.red,
        //   icon: const Icon(Icons.add_alert),
        // );
      }
      throw e;
    }
  }

  Future<void> fetchdata1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    isError = false;
    try {
      final response = await http.get(
        Uri.parse(
          'http://34.101.47.131/indexapi/countkelas/10',
        ),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('API Response: $jsonData');
        isError = true;
        if (jsonData.containsKey('data')) {
          setState(() {
            data1 = jsonData['data'];
          });
        } else {
          print('Error: Response does not contain data');
          isError = false;
        }
      } else {
        print('Error: ${response.statusCode}');
        isError = false;
        // showSnackBar('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      isError = false;
      // showSnackBar('Error fetching data: $e');
    }
  }

  Future<void> fetchdata2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    isError = true;
    try {
      final response = await http.get(
        Uri.parse(
          'http://34.101.47.131/indexapi/countkelas/11',
        ),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('API Response: $jsonData');

        if (jsonData.containsKey('data')) {
          setState(() {
            data2 = jsonData['data'];
          });
        } else {
          print('Error: Response does not contain data');
          isError = false;
        }
      } else {
        print('Error: ${response.statusCode}');
        isError = false;
        // showSnackBar('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      isError = false;
      // showSnackBar('Error fetching data: $e');
    }
  }

  Future<void> fetchdata3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    isError = false;
    try {
      final response = await http.get(
        Uri.parse(
          'http://34.101.47.131/indexapi/countkelas/12',
        ),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('API Response: $jsonData');
        isError = true;
        if (jsonData.containsKey('data')) {
          setState(() {
            data3 = jsonData['data'];
          });
        } else {
          print('Error: Response does not contain data');
          isError = false;
        }
      } else {
        print('Error: ${response.statusCode}');
        isError = false;
        // showSnackBar('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      isError = false;
      // showSnackBar('Error fetching data: $e');
    }
  }

  Future<void> fetchdata4() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    isError = false;
    try {
      final response = await http.get(
        Uri.parse(
          'http://34.101.47.131/indexapi/countpelanggaran',
        ),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('API Response: $jsonData');
        isError = true;
        if (jsonData.containsKey('data')) {
          setState(() {
            data4 = jsonData['data'];
          });
        } else {
          print('Error: Response does not contain data');
          isError = false;
        }
      } else {
        print('Error: ${response.statusCode}');
        isError = false;
        // showSnackBar('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      isError = false;
      // showSnackBar('Error fetching data: $e');
    }
  }

  Future<void> fetchdata5() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    isError = false;

    try {
      final response = await http.get(
        Uri.parse(
          'http://34.101.47.131/indexapi/countpelanggaranbyday',
        ),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('API Response: $jsonData');
        isError = true;
        if (jsonData.containsKey('total')) {
          setState(() {
            data5 = jsonData['total'];
          });
        } else {
          print('Error: Response does not contain data');
          isError = false;
        }
      } else {
        print('Error: ${response.statusCode}');
        isError = false;
        // showSnackBar('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      isError = false;
      // showSnackBar('Error fetching data: $e');
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
          fecthTahunKel();
          fetchdata1();
          fetchdata2();
          fetchdata3();
          fetchdata4();
          fetchdata5();
          fetchPelanggaran();
          fecthPrestasi();
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
                              Text(
                                data1,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 30,
                                  color: Color(0xffa6def1),
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
                                data4,
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
                                data5,
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
                                  child: Expanded(
                                    child: FutureBuilder<List<PrestasiData>>(
                                        future: fetchPelanggaran(),
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
                                            List<PrestasiData> jenkel =
                                                snapshot.data!;

                                            return SfCircularChart(
                                              palette: const <Color>[
                                                Color.fromARGB(
                                                    255, 209, 58, 12),
                                                Color.fromARGB(
                                                    255, 230, 255, 43),
                                                Color.fromARGB(
                                                    255, 255, 89, 43),
                                                Color.fromARGB(255, 242, 1, 97),
                                                Color.fromARGB(255, 5, 253, 96),
                                                Color.fromARGB(
                                                    255, 43, 255, 241),
                                              ],
                                              tooltipBehavior:
                                                  _tooltipBehaviorPrestasi,
                                              series: <CircularSeries>[
                                                PieSeries<PrestasiData, String>(
                                                  dataSource: jenkel,
                                                  xValueMapper:
                                                      (PrestasiData data, _) =>
                                                          data.nama,
                                                  yValueMapper:
                                                      (PrestasiData data, _) =>
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
                                  // clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: FutureBuilder<List<Hariini>>(
                                    future: fecthPrestasi(),
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
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        );
                                      } else {
                                        List<Hariini> jenkel = snapshot.data!;
                                        return SfCircularChart(
                                          palette: const <Color>[
                                            Colors.amber,
                                            Color.fromARGB(255, 44, 150, 20),
                                            Color.fromARGB(255, 16, 229, 252),
                                            Color.fromARGB(255, 252, 16, 252),
                                            Color.fromARGB(255, 48, 246, 4),
                                            Color.fromARGB(255, 255, 255, 255),
                                          ],
                                          tooltipBehavior:
                                              _tooltipBehaviorPrestasi,
                                          series: <CircularSeries>[
                                            DoughnutSeries<Hariini, String>(
                                              dataSource: jenkel,
                                              xValueMapper: (Hariini data, _) =>
                                                  data.kelas,
                                              yValueMapper: (Hariini data, _) =>
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
                                    },
                                  ),
                                ),
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
                                  future: fecthTahunKel(),
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
                                      List<TahunData> tahun = snapshot.data!;
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
                                          ColumnSeries<TahunData, String>(
                                            // name: "Kelas",
                                            dataSource: tahun,
                                            color: Colors.amber,
                                            xValueMapper: (TahunData data, _) =>
                                                data.tahun,
                                            yValueMapper: (TahunData data, _) =>
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
          height: 55.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // IconButton(
              //   icon: Icon(
              //     Icons.home_outlined,
              //     color: Colors.white,
              //     size: 28,
              //   ),
              //   onPressed: () => Get.to(Dashboard()),
              // ),
              IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 35,
                ),
                onPressed: () => Get.to(Pelanggaran()),
              ),
              // SizedBox(width: 48.0),
              // IconButton(
              //   icon: Icon(
              //     UniconsLine.trophy,
              //     color: Colors.white,
              //     size: 35,
              //   ),
              //   onPressed: () => Get.to(Prestasi()),
              // ),
              IconButton(
                icon: Icon(
                  Icons.groups_outlined,
                  color: Colors.white,
                  size: 35,
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
