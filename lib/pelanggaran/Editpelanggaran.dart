// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:pelanggaran/QRpage.dart/qr.dart';
// import 'package:pelanggaran/pelanggaran/Pelanggaran.dart';
// import 'package:pelanggaran/prestasi/Listprestasi.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class EditPelanggaran extends StatefulWidget {
//     final String id;
//   final String nama;
//   final String jenis;
//   final String tanggal;
//   final String detail;

//   const EditPelanggaran({Key? key,
//    required this.id,
//       required this.nama,
//       required this.jenis,
//       required this.tanggal,
//       required this.detail,
//    });


//   @override
//   State<EditPelanggaran> createState() => _EditPelanggaranState();
// }

// class _EditPelanggaranState extends State<EditPelanggaran> {
//   final TextEditingController namaController = TextEditingController();
//   final TextEditingController tanggalController = TextEditingController();
//   final TextEditingController jenisController = TextEditingController();
//   final TextEditingController detailController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();
//   var isLoading = false.obs;

//   List<Map<String, dynamic>> dropdownItems = [];
//   Map<String, dynamic>? selectedDropdownitem;
//   List<Map<String, dynamic>> dropdownItems2 = [];
//   Map<String, dynamic>? selectedDropdownitem2;

//   @override
//   void initState() {
//     super.initState();

//     fetchortu().then((data) {
//       if (mounted) {
//         setState(() {
//           dropdownItems = data;
//         });
//       }
//     });
//     fetchnis().then((data2) {
//       if (mounted) {
//         setState(() {
//           dropdownItems2 = data2;
//         });
//       }
//     });
//     if (mounted) {
//       setState(() {
//         namaController.text = widget.nama;
//         tanggalController.text = widget.tanggal;
//         jenisController.text = widget.jenis;
//         detailController.text = widget.detail;
   

//       });
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         tanggalController.text = DateFormat('yyyy-MM-dd').format(picked);
//       });
//     }
//   }

//   Future<void> siswaAdd() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var token = prefs.getString('tokenJwt') ?? '';
//       final id = widget.id;
//     final response = await http.post(
//       Uri.parse(
//           'http://34.101.47.131/pelanggaranapi/edit/$id'),
//       body: {
//         // 'siswa_nis': selectedDropdownitem2?['nis'].toString(),
//         // 'tanggal': tanggalController.text,
//         'jenis_id': selectedDropdownitem?['id'].toString(),
//         'detail': detailController.text,
//       },
//       headers: {
//         'Cookie': token,
//       },
//     );

//     if (response.statusCode == 200) {
//       isLoading.value = false;
//       Get.snackbar(
//         'Sukses',
//         "Data berhasil ditambahkan",
//         colorText: Colors.white,
//         backgroundColor: Colors.green[400],
//         icon: const Icon(Icons.add_alert),
//       );
//       Get.to(const Pelanggaran());
//     } else {
//       isLoading.value = false;
//       Get.snackbar(
//         'Gagal mengirim data',
//         "Error ${response.reasonPhrase}",
//         colorText: Colors.white,
//         backgroundColor: Colors.red,
//         icon: const Icon(Icons.add_alert),
//       );
//     }
//   }

//   Future<List<Map<String, dynamic>>> fetchortu() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var token = prefs.getString('tokenJwt') ?? '';

//     final response = await http.post(
//       Uri.parse(
//           'http://34.101.47.131/jenispelanggaranapi'),
//       headers: {
//         'Cookie': token,
//       },
//     );
//     if (response.statusCode == 200) {
//       List<dynamic> jsonResponse = json.decode(response.body);
//       List<Map<String, dynamic>> data =
//           jsonResponse.cast<Map<String, dynamic>>();
//       return data;
//     } else {
//       Get.snackbar(
//         'Gagal mengambil data ',
//         "Error ${response.reasonPhrase}",
//         colorText: Colors.white,
//         backgroundColor: Colors.red,
//         icon: const Icon(Icons.add_alert),
//       );
//       throw Exception("Gagal mengambil data ");
//     }
//   }

//   Future<List<Map<String, dynamic>>> fetchnis() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var token = prefs.getString('tokenJwt') ?? '';

//     final response = await http.post(
//       Uri.parse('http://34.101.47.131/siswaapi'),
//       headers: {
//         'Cookie': token,
//       },
//     );
//     if (response.statusCode == 200) {
//       List<dynamic> jsonResponse = json.decode(response.body);
//       List<Map<String, dynamic>> data =
//           jsonResponse.cast<Map<String, dynamic>>();

//       return data;
//     } else {
//       Get.snackbar(
//         'Gagal mengambil data ',
//         "Error ${response.reasonPhrase}",
//         colorText: Colors.white,
//         backgroundColor: Colors.red,
//         icon: const Icon(Icons.add_alert),
//       );
//       throw Exception("Gagal mengambil data ");
//     }
//   }

//   DateTime selectedDate = DateTime.now();
//   String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffffffff),
//       appBar: AppBar(
//         elevation: 4,
//         centerTitle: false,
//         automaticallyImplyLeading: false,
//         backgroundColor: Color(0xff3a57e8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.zero,
//         ),
//         title: Text(
//           "Edit Pelanggaran",
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             fontStyle: FontStyle.normal,
//             fontSize: 18,
//             color: Color(0xffffffff),
//           ),
//         ),
//         leading: GestureDetector(
//           onTap: () {
//             Get.to(Pelanggaran());
//           },
//           child: Icon(
//             Icons.arrow_back,
//             color: Color(0xffffffff),
//             size: 24,
//           ),
//         ),
//          actions: [
//           Padding(
//             padding: const EdgeInsets.only(
//               right: 10,
//             ),
//             child: IconButton(
//               icon: Icon(
//                 Icons.print,
//               ),
//               onPressed: () {
//                 // QRScanPage();
//               },
//               color: Color(0xffffffff),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Text(
//                           "NIS",
//                           textAlign: TextAlign.start,
//                           overflow: TextOverflow.clip,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 14,
//                             color: Color(0xff000000),
//                           ),
//                         ),
//                         TextField(
//                           controller: namaController,
//                           enabled: false,
//                           obscureText: false,
//                           textAlign: TextAlign.start,
//                           maxLines: 1,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 14,
//                             color: Color(0xff000000),
//                           ),
//                           decoration: InputDecoration(
//                             disabledBorder: InputBorder.none,
//                             focusedBorder: InputBorder.none,
//                             enabledBorder: InputBorder.none,
//                             filled: true,
//                             fillColor: Color(0xffedf2f8),
//                             isDense: false,
//                             contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 8),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "Tanggal",
//                             textAlign: TextAlign.left,
//                             overflow: TextOverflow.clip,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontStyle: FontStyle.normal,
//                               fontSize: 14,
//                               color: Color(0xff000000),
//                             ),
//                           ),
//                         ),
//                         TextFormField(
//                           controller: tanggalController,
//                           enabled: false,
//                           // initialValue: formattedDate,
//                           obscureText: false,
//                           textAlign: TextAlign.start,
//                           maxLines: 1,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 14,
//                             color: Color(0xff000000),
//                           ),
//                           decoration: InputDecoration(
//                             disabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(4.0),
//                               borderSide: const BorderSide(
//                                   color: Color(0x00000000), width: 1),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(4.0),
//                               borderSide: const BorderSide(
//                                   color: Color(0x00000000), width: 1),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(4.0),
//                               borderSide: const BorderSide(
//                                   color: Color(0x00000000), width: 1),
//                             ),
//                             hintText: tanggalController.text,
//                             hintStyle: const TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontStyle: FontStyle.normal,
//                               fontSize: 14,
//                               color: Color(0xff000000),
//                             ),
//                             filled: true,
//                             fillColor: const Color(0xfff1f4f8),
//                             isDense: false,
//                             contentPadding: const EdgeInsets.symmetric(
//                                 vertical: 8, horizontal: 12),
//                             suffixIcon: const Icon(Icons.calendar_today,
//                                 color: Color(0xff212435), size: 24),
//                           ),
//                           onTap: () {
//                             _selectDate(context);
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                           child: Text(
//                             "Jenis",
//                             textAlign: TextAlign.start,
//                             overflow: TextOverflow.clip,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontStyle: FontStyle.normal,
//                               fontSize: 14,
//                               color: Color(0xff000000),
//                             ),
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Expanded(
//                               flex: 1,
//                               child: Container(
//                                 width: 130,
//                                 height: 50,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 1,
//                                   horizontal: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: const Color.fromARGB(
//                                       255, 239, 242, 249),
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                                 child: DropdownButtonHideUnderline(
//                                   child: DropdownButtonFormField(
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return widget.jenis;
//                                       }
//                                       return null;
//                                     },
                                    
//                                     value: selectedDropdownitem,
//                                     items: dropdownItems.map<
//                                         DropdownMenuItem<
//                                             Map<String, dynamic>>>((item) {
//                                       return DropdownMenuItem<
//                                           Map<String, dynamic>>(
//                                         value: item,
//                                         child: Text(item['jenis']),
//                                       );
//                                     }).toList(),
//                                     style: const TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400,
//                                       fontStyle: FontStyle.normal,
//                                     ),
//                                     onChanged:
//                                         (Map<String, dynamic>? newValue) {
//                                       setState(() {
//                                         selectedDropdownitem = newValue;
//                                       });
//                                     },
//                                     elevation: 8,
//                                     isExpanded: true,
//                                     hint: const Text("Pilih data"),
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Text(
//                           "Detail",
//                           textAlign: TextAlign.start,
//                           overflow: TextOverflow.clip,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 14,
//                             color: Color(0xff000000),
//                           ),
//                         ),
//                         TextField(
//                           controller: detailController,
//                           obscureText: false,
//                           textAlign: TextAlign.start,
//                           maxLines: 2,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 14,
//                             color: Color(0xff000000),
//                           ),
//                           decoration: InputDecoration(
//                             disabledBorder: InputBorder.none,
//                             focusedBorder: InputBorder.none,
//                             enabledBorder: InputBorder.none,
//                             filled: true,
//                             fillColor: Color(0xffedf2f8),
//                             isDense: false,
//                             contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 8),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
//                 child: MaterialButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       siswaAdd();
//                     }
//                   },
//                   color: Color(0xff3a57e8),
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   padding: EdgeInsets.all(16),
//                   child: Text(
//                     "Simpan",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       fontStyle: FontStyle.normal,
//                     ),
//                   ),
//                   textColor: Color(0xffffffff),
//                   height: 40,
//                   minWidth: 140,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
