import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pelanggaran/siswa/Siswa.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditSiswa extends StatefulWidget {
  final String id;
  final String nis;
  final String nama;
  final String jenis_kelamin;
  final String kelas;
  final String alamat;
  final String nomor_wali;

  const EditSiswa(
      {Key? key,
      required this.id,
      required this.nis,
      required this.nama,
      required this.jenis_kelamin,
      required this.kelas,
      required this.alamat,
      required this.nomor_wali});

  @override
  State<EditSiswa> createState() => _EditSiswaState();
}

class _EditSiswaState extends State<EditSiswa> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nisController = TextEditingController();
  final TextEditingController alamatCotroller = TextEditingController();
  final TextEditingController kelasCotroller = TextEditingController();
  final TextEditingController nomor_waliController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  String gender = "L";

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
    fetchortu().then((data2) {
      if (mounted) {
        setState(() {
          dropdownItems2 = data2;
        });
      }
    });
    if (mounted) {
      setState(() {
        namaController.text = widget.nama;
        nisController.text = widget.nis;
        _selectedGender = widget.jenis_kelamin;
        kelasCotroller.text = widget.kelas;
        nomor_waliController.text = widget.nomor_wali;
        alamatCotroller.text = widget.alamat;
      });
    }
  }

  Future<void> siswaDelete() async {
    isLoadingDelete.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    var nis = widget.nis;

    final url = Uri.parse('http://34.101.47.131/siswaapi/delete/$nis');

    final response = await http.post(
      url,
      headers: {
        'Cookie': token,
      },
    );

    if (response.statusCode == 200) {
      isLoading.value = false;
      Get.snackbar(
        'Sukses',
        "Siswa ${widget.nama} Berhasil Dihapus",
        colorText: Colors.white,
        backgroundColor: Colors.green[400],
        icon: const Icon(Icons.add_alert),
      );
      Get.to(const Siswa());
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Gagal menghapus data',
        "Error ${response.reasonPhrase}",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.add_alert),
      );
    }
  }

  var isLoadingDelete = false.obs;

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      onPressed: () {
        Get.back();
      },
      child: const Text("Batal"),
    );
    Widget continueButton = Obx(
      () => TextButton(
        onPressed: () {
          isLoadingDelete.value = true;
          siswaDelete();
        },
        child: Stack(
          children: [
            isLoadingDelete.value
                ? const SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 4.0,
                    ),
                  )
                : const Text(
                    "Hapus",
                  )
          ],
        ),
      ),
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Konfirmasi"),
      content: const Text("Apakah anda yakin ingin menghapus data ini?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    //show  the Dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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

  Future<List<Map<String, dynamic>>> fetchortu() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    final response = await http.post(
      Uri.parse('http://34.101.47.131/walimuridapi'),
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
    final nis = widget.nis;

    final response = await http.post(
      Uri.parse('http://34.101.47.131/siswaapi/edit/$nis'),
      body: {
        'nis': nisController.text,
        'nama': namaController.text,
        'alamat': alamatCotroller.text,
        'wali_id': selectedDropdownitem2?['id'].toString(),
        'jenis_kelamin': _selectedGender,
        'kelas_id': selectedDropdownitem?['id'].toString(),
      },
      headers: {
        'Cookie': token,
      },
    );

    if (response.statusCode == 200) {
      isLoading.value = false;
      Get.snackbar(
        'Sukses',
        "Nama ${namaController.text} Berhasil di edit",
        colorText: Colors.white,
        backgroundColor: Colors.green[400],
        icon: const Icon(Icons.add_alert),
      );
      Get.to(const Siswa());
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

  String _selectedGender = 'P';

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
          "Edit Siswa",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.to(Siswa());
          },
          child: Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
            size: 24,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () {
                showAlertDialog(context);
              },
              color: Color(0xffffffff),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                              hintText: "NIS",
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
                              hintText: "Nama Siswa",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
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
                              "Jenis kelamin",
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
                                    child: DropdownButton(
                                      value: _selectedGender,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedGender = newValue.toString();
                                        });
                                      },
                                      items: [
                                        DropdownMenuItem(
                                          value: 'P',
                                          child: Text(
                                            'Perempuan',
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontWeight: FontWeight
                                                    .w400), // Mengubah warna teks menjadi abu-abu
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 'L',
                                          child: Text(
                                            'Laki-Laki',
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontWeight: FontWeight
                                                    .w400), // Mengubah warna teks menjadi abu-abu
                                          ),
                                        ),
                                      ],
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
                                    color: const Color.fromARGB(
                                        255, 239, 242, 249),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField(
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
                            "Alamat",
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
                            controller: alamatCotroller,
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
                              hintText: "Alamat",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                              filled: true,
                              fillColor: Color(0xffedf2f8),
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
                              "Nomor Wali",
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
                                      value: selectedDropdownitem2,
                                      items: dropdownItems2.map<
                                          DropdownMenuItem<
                                              Map<String, dynamic>>>((item) {
                                        return DropdownMenuItem<
                                            Map<String, dynamic>>(
                                          value: item,
                                          child: Text(item['nomor_hp']),
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
