import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pelanggaran/kelas/kelas.dart';
import 'package:pelanggaran/pelanggaran/Pelanggaran.dart';
import 'package:pelanggaran/prestasi/Listprestasi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TambahPelanggaran extends StatefulWidget {
  final String id;
  final String nis;
  final String nama;
  final String kelas;

  const TambahPelanggaran({
    Key? key,
    required this.id,
    required this.nis,
    required this.nama,
    required this.kelas,
  });

  @override
  State<TambahPelanggaran> createState() => _TambahPelanggaranState();
}

class _TambahPelanggaranState extends State<TambahPelanggaran> {
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController nisController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kelasController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  bool isLoadingg = true;

  List<Map<String, dynamic>> dropdownItems = [];
  Map<String, dynamic>? selectedDropdownitem;
  List<Map<String, dynamic>> dropdownItems2 = [];
  Map<String, dynamic>? selectedDropdownitem2;

  @override
  void initState() {
    super.initState();

    // fetchKelas().then((data) {
    //   if (mounted) {
    //     setState(() {
    //       dropdownItems = data;
    //     });
    //   }
    // });
    fetchjenis().then((data2) {
      if (mounted) {
        setState(() {
          dropdownItems2 = data2;
          isLoading.value = true;
        });
      }
    });
    nisController.text = widget.nis;
    namaController.text = widget.nama;
    kelasController.text = widget.kelas;
  }

  Map<String, dynamic>? getDefaultDropdownitem(String jenis) {
    for (Map<String, dynamic> item in dropdownItems) {
      if (item['jenis'] == jenis) {
        isLoading.value = true;
        return item;
      }
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        tanggalController.text = DateFormat('yyyy-MM-dd ').format(picked);
      });
    }
  }

  //  Future<List<Map<String, dynamic>>> fetchKelas() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString('tokenJwt') ?? '';

  //   final response = await http.post(
  //     Uri.parse('http://34.101.47.131/kelasapi'),
  //     headers: {
  //       'Cookie': token,
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonResponse = json.decode(response.body);
  //     List<Map<String, dynamic>> data =
  //         jsonResponse.cast<Map<String, dynamic>>();
  //     return data;
  //   } else {
  //     Get.snackbar(
  //       'Gagal mengambil data ',
  //       "Error ${response.reasonPhrase}",
  //       colorText: Colors.white,
  //       backgroundColor: Colors.red,
  //       icon: const Icon(Icons.add_alert),
  //     );
  //     throw Exception("Gagal mengambil data ");
  //   }
  // }

  Future<void> siswaAdd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    final response = await http.post(
      Uri.parse('http://34.101.47.131/pelanggaranapi/add'),
      body: {
        'nis': nisController.text,
        'nama': namaController.text,
        'kelas': kelasController.text,
        'tanggal': selectedDate.toString(),
        'jenis_id': selectedDropdownitem2?['id'].toString(),
        'detail': detailController.text == null ? "" : detailController.text,
      },
      headers: {
        'Cookie': token,
      },
    );

    if (response.statusCode == 200) {
      isLoading.value = false;
      Get.snackbar(
        'Sukses',
        "Data berhasil ditambahkan",
        colorText: Colors.white,
        backgroundColor: Colors.green[400],
        icon: const Icon(Icons.add_alert),
      );
      Navigator.pop(context);
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

  Future<List<Map<String, dynamic>>> fetchjenis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    final response = await http.post(
      Uri.parse('http://34.101.47.131/jenispelanggaranapi'),
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

  DateTime selectedDate = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

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
          "Tambah Pelanggaran",
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Row(
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
                              "Nama Siswa",
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
                                // disabledBorder: InputBorder.none,
                                // focusedBorder: InputBorder.none,
                                // enabledBorder: InputBorder.none,
                                filled: true,
                                fillColor: Color(0xffedf2f8),
                                isDense: false,
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 8, 12, 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      4), // Mengatur border radius menjadi 4
                                  borderSide: BorderSide
                                      .none, // Menghilangkan border side
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Row(
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
                            TextField(
                              controller: nisController,
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
                                // disabledBorder: InputBorder.none,
                                // focusedBorder: InputBorder.none,
                                // enabledBorder: InputBorder.none,
                                filled: true,
                                fillColor: Color(0xffedf2f8),
                                isDense: false,
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 8, 12, 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      4), // Mengatur border radius menjadi 4
                                  borderSide: BorderSide
                                      .none, // Menghilangkan border side
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tanggal",
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                            TextFormField(
                              initialValue: formattedDate,
                              enabled: false,
                              obscureText: false,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: const BorderSide(
                                      color: Color(0x00000000), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: const BorderSide(
                                      color: Color(0x00000000), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: const BorderSide(
                                      color: Color(0x00000000), width: 1),
                                ),
                                hintText: "Tanggal",
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                                filled: true,
                                fillColor: const Color(0xfff1f4f8),
                                isDense: false,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      4), // Mengatur border radius menjadi 4
                                  borderSide: BorderSide
                                      .none, // Menghilangkan border side
                                ),
                                suffixIcon: const Icon(Icons.calendar_today,
                                    color: Color(0xff212435), size: 24),
                              ),
                              onTap: () {
                                _selectDate(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Row(
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
                            TextField(
                              controller: kelasController,
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
                                // disabledBorder: InputBorder.none,
                                // focusedBorder: InputBorder.none,
                                // enabledBorder: InputBorder.none,
                                filled: true,
                                fillColor: Color(0xffedf2f8),
                                isDense: false,
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 8, 12, 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      4), // Mengatur border radius menjadi 4
                                  borderSide: BorderSide
                                      .none, // Menghilangkan border side
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Row(
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
                                "Pelanggaran",
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
                                    child: isLoading.value
                                        ? DropdownButtonHideUnderline(
                                            child: DropdownButtonFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "tidak boleh kosong";
                                                }
                                                return null;
                                              },
                                              value: selectedDropdownitem2,
                                              items: dropdownItems2.map<
                                                  DropdownMenuItem<
                                                      Map<String,
                                                          dynamic>>>((item) {
                                                return DropdownMenuItem<
                                                    Map<String, dynamic>>(
                                                  value: item,
                                                  child: Text(item['jenis']),
                                                );
                                              }).toList(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                              ),
                                              onChanged: (Map<String, dynamic>?
                                                  newValue) {
                                                setState(() {
                                                  selectedDropdownitem2 =
                                                      newValue;
                                                });
                                              },
                                              elevation: 8,
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          )
                                        : const Center(
                                            child: SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 4.0,
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
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
                              "Catatan",
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
                              controller: detailController,
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
                                // disabledBorder: InputBorder.none,
                                // focusedBorder: InputBorder.none,
                                // enabledBorder: InputBorder.none,
                                filled: true,
                                fillColor: Color(0xffedf2f8),
                                isDense: false,
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 8, 12, 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      4), // Mengatur border radius menjadi 4
                                  borderSide: BorderSide
                                      .none, // Menghilangkan border side
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
        ),
      ),
    );
  }
}
