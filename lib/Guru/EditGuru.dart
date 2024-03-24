///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pelanggaran/Dashboard.dart';
import 'package:pelanggaran/Guru/Guru.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditGuru extends StatefulWidget {
  final String id;
  final String nip;
  final String nama;
  final String jabatan;
  final String kelas_id;
  final String nomor_hp;

  const EditGuru({
    Key? key,
    required this.id,
    required this.nip,
    required this.nama,
    required this.jabatan,
    required this.kelas_id,
    required this.nomor_hp,
  });

  @override
  State<EditGuru> createState() => _EditGuruState();
}

class _EditGuruState extends State<EditGuru> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nipController = TextEditingController();
  final TextEditingController jabatanController = TextEditingController();
  final TextEditingController wali_kelasController = TextEditingController();
  final TextEditingController nomor_hpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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

    if (mounted) {
      setState(() {
        namaController.text = widget.nama;
        nipController.text = widget.nip;
        jabatanController.text = widget.jabatan;
        wali_kelasController.text = widget.kelas_id;
        nomor_hpController.text = widget.nomor_hp;
      });
    }
  }

  List<Map<String, dynamic>> dropdownItems = [];
  Map<String, dynamic>? selectedDropdownitem;

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

  Future<void> submitData() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    final nip = widget.nip;
    try {
      final response = await http.post(
        Uri.parse("http://34.101.47.131/guruapi/edit/$nip"),
        body: {
          'nip': nipController.text,
          'nama': namaController.text,
          'jabatan': jabatanController.text,
          'kelas_id': selectedDropdownitem?['id'].toString() == null
              ? ""
              : wali_kelasController.text,
          'nomor_hp': nomor_hpController.text,
        },
        headers: {
          'Cookie': token,
        },
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.snackbar(
          'Sukses',
          "Nama ${namaController.text} berhasil diedit",
          colorText: Colors.white,
          backgroundColor: Colors.green[400],
          icon: const Icon(Icons.add_alert),
        );
        Get.to(Guru());
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
          "Edit Guru",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 18,
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
      body: SingleChildScrollView(
        child: Padding(
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
                            "NIP",
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
                            controller: nipController,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            "Nama Guru",
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
                                    color: Color(0x00000000), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                                borderSide: BorderSide(
                                    color: Color(0x00000000), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                                borderSide: BorderSide(
                                    color: Color(0x00000000), width: 1),
                              ),
                              filled: true,
                              fillColor: Color(0xffeef1f6),
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
                                    color: const Color.fromARGB(
                                        255, 239, 242, 249),
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
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                                borderSide: BorderSide(
                                    color: Color(0x03000000), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                                borderSide: BorderSide(
                                    color: Color(0x03000000), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                                borderSide: BorderSide(
                                    color: Color(0x03000000), width: 1),
                              ),
                              filled: true,
                              fillColor: Color(0xfff1f5fb),
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
                          Text(
                            "Jabatan",
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
                            controller: jabatanController,
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
                                    color: Color(0x00000000), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                                borderSide: BorderSide(
                                    color: Color(0x00000000), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                                borderSide: BorderSide(
                                    color: Color(0x00000000), width: 1),
                              ),
                              filled: true,
                              fillColor: Color(0xffedf2f8),
                              isDense: false,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              suffixIcon: Icon(Icons.expand_more,
                                  color: Color(0xff212435), size: 24),
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
                      submitData();
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
      ),
    );
  }
}
