///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pelanggaran/jurusan/Jurusan.dart';
import 'package:pelanggaran/kelas/kelas.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KelasEdit extends StatefulWidget {
  const KelasEdit({super.key});

  @override
  State<KelasEdit> createState() => _KelasEditState();
}

class _KelasEditState extends State<KelasEdit> {
  final TextEditingController namaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  List<Map<String, dynamic>> dropdownItems = [];
  Map<String, dynamic>? selectedDropdownitem;
  List<Map<String, dynamic>> dropdownItems2 = [];
  Map<String, dynamic>? selectedDropdownitem2;

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
    fetchjurusan().then((data) {
      if (mounted) {
        setState(() {
          dropdownItems2 = data;
        });
      }
    });
  }

  Future<List<Map<String, dynamic>>> fetchjurusan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    final response = await http.post(
      Uri.parse('http://34.101.47.131/jurusanapi'),
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

  Future<List<Map<String, dynamic>>> fetchKota() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    final response = await http.post(
      Uri.parse('http://34.101.47.131/tingkatapi'),
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

  Future<void> submitData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    try {
      final response = await http.post(
        Uri.parse("http://34.101.47.131/kelasapi/add"),
        body: {
          'nama': namaController.text,
          'tingkat_id': selectedDropdownitem?['id'].toString(),
          'jurusan_id': selectedDropdownitem2?['id'].toString(),
        },
        headers: {
          'Cookie': token,
        },
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        print("Data berhasil disimpan");
        Get.to(kelas());
      } else {
        // Handle error if needed
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      // Handle error if needed
      print("Error: $e");
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
          "Tambah Kelas",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.to(kelas());
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
        child: Form(
          key: _formKey,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Nama kelas",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
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
                            hintText: "XI RPL 1",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color.fromARGB(255, 103, 103, 103),
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
                            "Tingkat",
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
                                  color:
                                      const Color.fromARGB(255, 239, 242, 249),
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
                                        child: Text(item['tingkat']),
                                      );
                                    }).toList(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    onChanged:
                                        (Map<String, dynamic>? newValue) {
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
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Text(
                            "Jurusan",
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
                                  color:
                                      const Color.fromARGB(255, 239, 242, 249),
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
                                        child: Text(item['nama']),
                                      );
                                    }).toList(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    onChanged:
                                        (Map<String, dynamic>? newValue) {
                                      setState(() {
                                        selectedDropdownitem2 = newValue;
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
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      submitData();
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
      ),
    );
  }
}
