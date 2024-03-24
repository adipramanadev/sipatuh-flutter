///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pelanggaran/Dashboard.dart';
import 'package:pelanggaran/pelanggaran/Editpelanggaran.dart';
import 'package:pelanggaran/pelanggaran/TambahPelanggaran.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Pelanggaran extends StatefulWidget {
  const Pelanggaran({super.key});

  @override
  State<Pelanggaran> createState() => _PelanggaranState();
}

class SiswaData {
  final String id;
  final String nama;
  final String nis;
  final String kelas;
  final String tanggal;
  final String jenis;
  final String detail;
  final String nomor_wali;

  SiswaData(
      {required this.id,
      required this.nama,
      required this.nis,
      required this.kelas,
      required this.tanggal,
      required this.jenis,
      required this.detail,
      required this.nomor_wali});

  factory SiswaData.fromJson(Map<String, dynamic> json) {
    return SiswaData(
      id: json['id'],
      nama: json['nama'] == null ? "" : json['nama'],
      nis: json['nis'] == null ? "" : json['nis'],
      kelas: json['kelas'] == null ? "" : json['kelas'],
      tanggal: json['tanggal'],
      jenis: json['jenis'],
      detail: json['detail'],
      nomor_wali: json['nomor_hp'] == null ? "" : json['nomor_hp'],
    );
  }
}

class _PelanggaranState extends State<Pelanggaran> {
  final TextEditingController searchController = TextEditingController();
  List<SiswaData> searchData = [];
  bool isConnected = false;
  Widget LoadingListView = const Center(
    child: CircularProgressIndicator(),
  );
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevices;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  void connectToDevice() async {
    if (selectedDevices != null) {
      await printer.connect(selectedDevices!);
      saveConnectionStatus(true);
      setState(() {
        isConnected = true;
      });
    }
  }

  void saveConnectionStatus(bool isConnected) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPrinterConnected', isConnected);
  }

  void _printData(int index) async {
    try {
      BlueThermalPrinter bluetoothPrinter = BlueThermalPrinter.instance;
      List<BluetoothDevice> devices = await bluetoothPrinter.getBondedDevices();

      if (devices.isNotEmpty) {
        BluetoothDevice printer = devices.first;

        bool? isConnected = await bluetoothPrinter.isConnected;

        if (!isConnected!) {
          await bluetoothPrinter.connect(printer);
        }

        String printData = buildPrintData(index);
        await bluetoothPrinter.write(printData);
        await bluetoothPrinter.disconnect();
      } else {
        print("Tidak ditemukan perangkat Bluetooth terikat");
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
    }
  }

  String buildPrintData(int index) {
    String printData = """
    SIPATUH - PELANGGARAN SISWA
NIS: ${searchData[index].nis}
Nama: ${searchData[index].nama}
Kelas: ${searchData[index].kelas}
Pelanggaran: ${searchData[index].jenis}
Tgl: ${searchData[index].tanggal}
Catatan: ${searchData[index].detail}

""";

    print("Data yang akan dicetak: $printData");

    return printData;
  }

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
        Uri.parse("http://34.101.47.131/pelanggaranapi"),
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
                // Get.snackbar(
                //   'Kosong',
                //   "Data tersebut tidak ada",
                //   colorText: Colors.white,
                //   backgroundColor: Colors.orange,
                //   icon: const Icon(Icons.add_alert),
                // );
                LoadingListView = ListView(
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
                              "Data Tidak Ditemukan",
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
                      // onTap: () {
                      //   Get.to(EditPelanggaran(
                      //     id: searchData[index].id,
                      //     nama: searchData[index].nama,
                      //     jenis: searchData[index].jenis,
                      //     tanggal: searchData[index].tanggal,
                      //     detail: searchData[index].detail,
                      //   ));
                      // },
                      child: Card(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
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
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 13,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 0),
                                        child: Text(
                                          searchData[index].kelas,
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  padding: EdgeInsets.all(0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height: 13,
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.zero,
                                    border: Border.all(
                                        color: Color(0x4d9e9e9e), width: 1),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        searchData[index].jenis.length > 18
                                            ? searchData[index]
                                                    .jenis
                                                    .substring(0, 5) +
                                                "..."
                                            : searchData[index].jenis,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 8,
                                          color: Color(0xffff0000),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: Text(
                                    searchData[index].tanggal,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 8,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              ]),
                              PopupMenuButton<String>(
                                onSelected: (String value) {
                                  if (value == 'Option 1') {
                                    _printData(index);
                                    buildPrintData(index); // }
                                  } else if (value == 'Option 2') {
                                    if (searchData[index].nomor_wali != "") {
                                      launch(
                                        "https://wa.me/+${searchData[index].nomor_wali}?text=Pemberitahuan Pelanggaran Siswa\n\nTanggal:${searchData[index].tanggal}\n\nKepada Orang Tua/Wali ${searchData[index].nama}:\n${searchData[index].nama} terlibat dalam pelanggaran pada tanggal ${searchData[index].tanggal}:\nJenis Pelanggaran: ${searchData[index].jenis}\nDeskripsi Pelanggaran: ${searchData[index].detail}\nKami akan memberikan pembinaan agar ${searchData[index].nama} memahami aturan sekolah yang berlaku.\n\nTerima kasih atas perhatian dan kerjasamanya.\n\n\nHormat kami,\n[Penanda Tangan/Pejabat Sekolah]",
                                      );
                                    } else {
                                      // Tampilkan notifikasi bahwa nomor wali kosong
                                      // Misalnya:
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Nomor wali kosong.'),
                                        ),
                                      );
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'Option 1',
                                    child: Row(
                                      children: [
                                        Icon(Icons.print, color: Colors.black),
                                        SizedBox(width: 8),
                                        Text('Print'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Option 2',
                                    child: Row(
                                      children: [
                                        Icon(Icons.chat,
                                            color: Colors
                                                .black), // Icon untuk Option 2
                                        SizedBox(
                                            width:
                                                8), // Jarak antara icon dan teks
                                        Text(
                                            'Kirim pesan'), // Teks untuk Option 2
                                      ],
                                    ),
                                  ),
                                ],
                                child: Icon(
                                  Icons.menu_open,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              )
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
          // Get.snackbar(
          //   'Gagal Mencari Data',
          //   "Invalid Data Format",
          //   colorText: Colors.white,
          //   backgroundColor: Colors.red,
          //   icon: const Icon(Icons.add_alert),
          // );
        }
      } else {
        // Get.snackbar(
        //   'Gagal Mencari',
        //   "Error ${response.reasonPhrase}",
        //   colorText: Colors.white,
        //   backgroundColor: Colors.red,
        //   icon: const Icon(Icons.add_alert),
        // );
      }
    } catch (e) {
      if (e
          .toString()
          .contains("Connection closed before full header was received")) {
        // Handle the specific error condition here
        // You can add custom handling logic for this case
        // Get.snackbar(
        //   'Gagal meload data',
        //   "Error:{$e} Connection closed before full header was received",
        //   colorText: Colors.white,
        //   backgroundColor: Colors.red,
        //   icon: const Icon(Icons.add_alert),
        // );
      }
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataKota("");
    getDevices();
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  bool isContainerVisible = false;

  void toggleContainerVisibility() {
    setState(() {
      isContainerVisible = !isContainerVisible;
    });
  }

  void showPopupMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final Offset target = Offset(overlay.size.width, kToolbarHeight);
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(target.dx, target.dy, 0, 0),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'Option 1',
          child: Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200],
              ),
              child: DropdownButton<BluetoothDevice>(
                isExpanded: true, // Menambahkan ini
                value: selectedDevices,
                hint: Text('Pilih Printer',
                    style: TextStyle(color: Colors.black)),
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                underline: SizedBox(),
                onChanged: (device) {
                  setState(() {
                    selectedDevices = device;
                    connectToDevice();
                  });
                },
                items: devices
                    .map((e) => DropdownMenuItem(
                          child: Text(
                            e.name!,
                            style: TextStyle(color: Colors.black),
                          ),
                          value: e,
                        ))
                    .toList(),
              ),
            ),
          ),
          //  SizedBox(width: 10),
          // ElevatedButton(
          //   onPressed: () {
          //     getDevices();
          //   },
          //   style: ElevatedButton.styleFrom(
          //     primary: Color(0xff3f5198),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8.0),
          //     ),
          //   ),
          //   child: const Icon(Icons.refresh, color: Colors.white),
          // ),
        ),
      ],
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
          "Pelanggaran",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            color: Color(0xffffffff),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.to(Dashboard());
          },
          child: Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
            size: 24,
          ),
        ),
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
              LoadingListView
            ],
          ),
        ),
      ),

      // ),
    );
  }
}
