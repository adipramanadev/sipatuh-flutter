///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pelanggaran/wali/WaliMurid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TambahWali extends StatefulWidget {
  const TambahWali({super.key});

  @override
  State<TambahWali> createState() => _TambahWaliState();
}

class _TambahWaliState extends State<TambahWali> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nisController = TextEditingController();
  final TextEditingController siswaCotroller = TextEditingController();
  final TextEditingController kelasCotroller = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController nomor_hpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> dropdownItems = [];
  Map<String, dynamic>? selectedDropdownitem;

  List<Map<String, dynamic>> dropdownItems2 = [];
  Map<String, dynamic>? selectedDropdownitem2;
  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    fetchKota().then((data) {
      if (mounted) {
        setState(() {
          dropdownItems = data;
        });
      }
    });
    fetchnis().then((data2) {
      if (mounted) {
        setState(() {
          dropdownItems2 = data2;
        });
      }
    });
  }

  Future<List<Map<String, dynamic>>> fetchKota() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    final response = await http.post(
      Uri.parse('http://34.101.47.131/kelasapi'),
      headers: {
        'Cookie': token,
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> data =
          jsonResponse.cast<Map<String, dynamic>>();
      return data;
    } else {
      Get.snackbar(
        'Gagal mengambil data ',
        "Error ${response.reasonPhrase}",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.add_alert),
      );
      throw Exception("Gagal mengambil data ");
    }
  }

  Future<void> siswaAdd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    final response = await http.post(
      Uri.parse('http://34.101.47.131/walimuridapi/add'),
      body: {
        'nama': namaController.text,
        'siswa_nis': siswaCotroller.text,
        'status': statusController.text,
        'nomor_hp': nomor_hpController.text,
        'siswa_kelas': kelasCotroller.text,
      },
      headers: {
        'Cookie': token,
      },
    );

    if (response.statusCode == 200) {
      isLoading.value = false;
      Get.snackbar(
        'Sukses',
        "Nama ${namaController.text} Ditambahkan",
        colorText: Colors.white,
        backgroundColor: Colors.green[400],
        icon: const Icon(Icons.add_alert),
      );
      Get.to(const Walimurid());
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Gagal mengirim data',
        "Error ${response.reasonPhrase}",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.add_alert),
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchnis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    final response = await http.post(
      Uri.parse('http://34.101.47.131/siswaapi'),
      headers: {
        'Cookie': token,
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> data =
          jsonResponse.cast<Map<String, dynamic>>();

      return data;
    } else {
      Get.snackbar(
        'Gagal mengambil data ',
        "Error ${response.reasonPhrase}",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.add_alert),
      );
      throw Exception("Gagal mengambil data ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff3a57e8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Tambah Wali Murid",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 18,
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Nama",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                        TextField(
                          controller: namaController,
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
                              borderRadius: BorderRadius.circular(3.0),
                              borderSide: BorderSide(
                                  color: Color(0x00eff3f8), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3.0),
                              borderSide: BorderSide(
                                  color: Color(0x00eff3f8), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3.0),
                              borderSide: BorderSide(
                                  color: Color(0x00eff3f8), width: 1),
                            ),
                            hintText: "",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                            filled: true,
                            fillColor: Color(0xffeff3f8),
                            isDense: false,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Text(
                          "NIS",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: 130,
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                vertical: 1,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 239, 242, 249),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Data tidak boleh kosong";
                                    }
                                    return null;
                                  },
                                  value: selectedDropdownitem2,
                                  items: dropdownItems2.map<
                                      DropdownMenuItem<
                                          Map<String, dynamic>>>((item) {
                                    return DropdownMenuItem<
                                        Map<String, dynamic>>(
                                      value: item,
                                      child: Text(item['nis']),
                                    );
                                  }).toList(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  onChanged: (Map<String, dynamic>? newValue) {
                                    setState(() {
                                      selectedDropdownitem2 = newValue;
                                    });
                                  },
                                  elevation: 8,
                                  isExpanded: true,
                                  hint: const Text("Pilih data"),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Text(
                          "Kelas",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: 130,
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                vertical: 1,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 239, 242, 249),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Data tidak boleh kosong";
                                    }
                                    return null;
                                  },
                                  value: selectedDropdownitem,
                                  items: dropdownItems.map<
                                      DropdownMenuItem<
                                          Map<String, dynamic>>>((item) {
                                    return DropdownMenuItem<
                                        Map<String, dynamic>>(
                                      value: item,
                                      child: Text(item['kelas']),
                                    );
                                  }).toList(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  onChanged: (Map<String, dynamic>? newValue) {
                                    setState(() {
                                      selectedDropdownitem = newValue;
                                    });
                                  },
                                  elevation: 8,
                                  isExpanded: true,
                                  hint: const Text("Pilih data"),
                                  decoration: InputDecoration(
                                    border: InputBorder
                                        .none, // Menghilangkan underline
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Status",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                      ),
                      TextField(
                        controller: statusController,
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
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "Status",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                          filled: true,
                          fillColor: Color(0xffedf2f8),
                          isDense: false,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          suffixIcon: Icon(Icons.expand_more,
                              color: Color(0xff212435), size: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Kontak",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                      ),
                      TextField(
                        controller: nomor_hpController,
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
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "081111111111",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                          filled: true,
                          fillColor: Color(0xffedf2f8),
                          isDense: false,
                          contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: MaterialButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    siswaAdd();
                  }
                },
                color: Color(0xff3a57e8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  "Simpan",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                textColor: Color(0xffffffff),
                height: 40,
                minWidth: 140,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
