///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pelanggaran/jurusan/Jurusan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditJurusan extends StatefulWidget {
  final String id;

  final String nama;

  const EditJurusan({
    Key? key,
    required this.id,
    required this.nama,
  });

  @override
  State<EditJurusan> createState() => _EditJurusanState();
}

class _EditJurusanState extends State<EditJurusan> {
  final TextEditingController namaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      setState(() {
        namaController.text = widget.nama;
      });
    }
  }

  Future<void> submitData() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    final id = widget.id;
    try {
      final response = await http.post(
        Uri.parse("http://34.101.47.131/jurusanapi/edit/$id"),
        body: {
          'nama': namaController.text,
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
        Get.to(jurusan());
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
          "Edit Jurusan",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        leading: Icon(
          Icons.arrow_back,
          color: Color(0xffffffff),
          size: 24,
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
                            hintText: "Kota",
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
    );
  }
}
