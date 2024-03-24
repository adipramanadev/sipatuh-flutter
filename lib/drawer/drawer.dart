import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pelanggaran/AkunLogin.dart';
import 'package:pelanggaran/AppTentang.dart';
import 'package:pelanggaran/kelas/kelas.dart';
import 'package:pelanggaran/nobox/login.dart';
import 'package:pelanggaran/pelanggaran/JenisPelanggaran.dart';
import 'package:pelanggaran/pelanggaran/Pelanggaran.dart';
import 'package:pelanggaran/setting.dart';
import 'package:pelanggaran/siswa/Siswa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashDrawer extends StatefulWidget {
  const DashDrawer({super.key});

  @override
  State<DashDrawer> createState() => _DashDrawerState();
}

class _DashDrawerState extends State<DashDrawer> {
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('tokenJwt'); //menghapus token dari preference/local storage
    Get.offAll(
      const AkunLogin(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 24,
            left: 20,
            right: 20,
            bottom: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image.asset(
                //   'assets/images/lo.jpg',
                //   width: 138,
                //   height: 63,
                // ),
                Image.asset(
                  'asset/newlogo (1).png',
                  height: 80,
                  width: 155,
                  fit: BoxFit.fitWidth,
                ),
                const Divider(
                  color: Color(0xFFC6C6C6),
                  thickness: 2,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 0,
                    bottom: 5,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     Get.to(Guru());
                //   },
                //   child: const SizedBox(
                //     height: 40,
                //     width: double.infinity,
                //     child: Row(
                //       mainAxisSize: MainAxisSize.max,
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Icon(
                //           Icons.person_3,
                //           color: Color.fromARGB(255, 74, 74, 74),
                //           size: 24,
                //         ),
                //         Padding(
                //           padding: EdgeInsets.only(
                //             left: 12,
                //           ),
                //           child: Text(
                //             'Guru',
                //             style: TextStyle(
                //               fontFamily: 'Poppins',
                //               color: Color.fromARGB(255, 74, 74, 74),
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    Get.to(Siswa());
                  },
                  child: const SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.groups,
                          color: Color.fromARGB(255, 74, 74, 74),
                          size: 24,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 12,
                          ),
                          child: Text(
                            'Siswa',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color.fromARGB(255, 74, 74, 74),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     Get.to(Walimurid());
                //   },
                //   child: const SizedBox(
                //     height: 40,
                //     width: double.infinity,
                //     child: Row(
                //       mainAxisSize: MainAxisSize.max,
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Icon(
                //           Icons.family_restroom,
                //           color: Color.fromARGB(255, 74, 74, 74),
                //           size: 24,
                //         ),
                //         Padding(
                //           padding: EdgeInsets.only(
                //             left: 12,
                //           ),
                //           child: Text(
                //             'Wali Murid',
                //             style: TextStyle(
                //               fontFamily: 'Poppins',
                //               color: Color.fromARGB(255, 74, 74, 74),
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Get.to(jurusan());
                //   },
                //   child: const SizedBox(
                //     height: 40,
                //     width: double.infinity,
                //     child: Row(
                //       mainAxisSize: MainAxisSize.max,
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Icon(
                //           Icons.type_specimen,
                //           color: Color.fromARGB(255, 74, 74, 74),
                //           size: 24,
                //         ),
                //         Padding(
                //           padding: EdgeInsets.only(
                //             left: 12,
                //           ),
                //           child: Text(
                //             'Jurusan',
                //             style: TextStyle(
                //               fontFamily: 'Poppins',
                //               color: Color.fromARGB(255, 74, 74, 74),
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                GestureDetector(
                  onTap: () {
                    Get.to(kelas());
                  },
                  child: const SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          color: Color.fromARGB(255, 74, 74, 74),
                          size: 24,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 12,
                          ),
                          child: Text(
                            'Kelas',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color.fromARGB(255, 74, 74, 74),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Color(0xFFC6C6C6),
                  thickness: 2,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 0,
                    bottom: 5,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(JenisPelanggaran());
                    },
                    child: const SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.menu_sharp,
                            color: Color.fromARGB(255, 74, 74, 74),
                            size: 24,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 12,
                            ),
                            child: Text(
                              'Jenis Pelanggaran',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color.fromARGB(255, 74, 74, 74),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Get.to(Pelanggaran());
                  },
                  child: const SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color.fromARGB(255, 74, 74, 74),
                          size: 24,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 12,
                          ),
                          child: Text(
                            'Pelanggaran',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color.fromARGB(255, 74, 74, 74),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // const Divider(
                //   color: Color(0xFFC6C6C6),
                //   thickness: 2,
                // ),
                // const Padding(
                //   padding: EdgeInsets.only(
                //     top: 0,
                //     bottom: 5,
                //   ),
                //   child: SizedBox(
                //     width: double.infinity,
                //     child: Text(
                //       'Prestasi',
                //       style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w500,
                //         fontFamily: 'Poppins',
                //       ),
                //       textAlign: TextAlign.start,
                //     ),
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Get.to(JenisPrestasi());
                //   },
                //   child: const SizedBox(
                //     height: 40,
                //     width: double.infinity,
                //     child: Row(
                //       mainAxisSize: MainAxisSize.max,
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Icon(
                //           Icons.menu,
                //           color: Color.fromARGB(255, 74, 74, 74),
                //           size: 22,
                //         ),
                //         Padding(
                //           padding: EdgeInsets.only(
                //             left: 12,
                //           ),
                //           child: Text(
                //             'Jenis Prestasi',
                //             style: TextStyle(
                //                 fontFamily: 'Poppins',
                //                 color: Color.fromARGB(255, 74, 74, 74),
                //                 fontWeight: FontWeight.w500,
                //                 fontSize: 14),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Get.to(Prestasi());
                //   },
                //   child: const SizedBox(
                //     height: 40,
                //     width: double.infinity,
                //     child: Row(
                //       mainAxisSize: MainAxisSize.max,
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Icon(
                //           UniconsLine.trophy,
                //           color: Color.fromARGB(255, 74, 74, 74),
                //           size: 22,
                //         ),
                //         Padding(
                //           padding: EdgeInsets.only(
                //             left: 12,
                //           ),
                //           child: Text(
                //             'Prestasi',
                //             style: TextStyle(
                //                 fontFamily: 'Poppins',
                //                 color: Color.fromARGB(255, 74, 74, 74),
                //                 fontWeight: FontWeight.w500,
                //                 fontSize: 14),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(AppTentang());
                    },
                    child: const SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.question_mark_outlined,
                            color: Color.fromARGB(255, 74, 74, 74),
                            size: 22,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 12,
                            ),
                            child: Text(
                              'Info Aplikasi',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color.fromARGB(255, 74, 74, 74),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(SettingA());
                  },
                  child: const SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.settings,
                          color: Color.fromARGB(255, 74, 74, 74),
                          size: 22,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 12,
                          ),
                          child: Text(
                            'Setting',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color.fromARGB(255, 74, 74, 74),
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(LoginScreen());
                  },
                  child: const SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.settings,
                          color: Color.fromARGB(255, 74, 74, 74),
                          size: 22,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 12,
                          ),
                          child: Text(
                            'Setting kirim pesan',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color.fromARGB(255, 74, 74, 74),
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(
                  color: Color(0xFFC6C6C6),
                  thickness: 2,
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Keluar'),
                              content:
                                  const Text('Yakin ingin keluar dari akun?'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Tidak'),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _logout();
                                    },
                                    child: const Text('Ya'))
                              ],
                            );
                          });
                    },
                    child: const SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Color.fromARGB(255, 74, 74, 74),
                            size: 22,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 12,
                            ),
                            child: Text(
                              'Keluar',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color.fromARGB(255, 74, 74, 74),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
