import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/screens/pembayaran_screen.dart';
import 'package:frontend/screens/validasi_pembayaran.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../models/login_model.dart';

import '../../services/keluhan_service.dart';

import '../../providers/auth_provider.dart';

import '../../screens/kesehatan_screen.dart';
import '../../screens/keluhan_screen.dart';
import '../landing_page.dart';
import '../../screens/ketahfidzan_screen.dart';
import 'saku_keluar.dart';
import 'saku_masuk.dart';
import 'riwayat_bayar_screen.dart';

class ProfileDashboard extends StatefulWidget {
  @override
  _ProfileDashboardState createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  LoginResponse? _loginData;

  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  
  Widget _buildTextRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16), 
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> menuItems = [
    {'icon': FontAwesome.hospital_o, 'label': 'Kesehatan'},
    {'icon': FontAwesome.book, 'label': 'Tahfidz'},
    {'icon': FontAwesome.comments, 'label': 'Saran'},
  ];

  @override
  void initState() {
    super.initState();
    _loadLoginData();
  }

  Future<void> _loadLoginData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      setState(() {
        _loginData = authProvider.loginResponse;
      });
    } catch (e) {
      print('Error loading login data: $e');
    }
  }

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.teal,
      elevation: 1,
      toolbarHeight: 48,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          'Profile',
          style: GoogleFonts.poppins( 
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    ),
    body: _loginData == null
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                // Bagian profil
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(1),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  (_loginData?.photo.isNotEmpty ?? false)
                                      ? NetworkImage(
                                          'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${_loginData?.photo}')
                                      : null,
                              child: (_loginData?.photo.isEmpty ?? true)
                                  ? Icon(Icons.person,
                                      size: 35, color: Colors.grey[400])
                                  : null,
                            ),
                            SizedBox(height: 12),
                            Text(_loginData?.nama ?? 'Nama Tidak Tersedia',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                            SizedBox(height: 8),
                            Text(
                              'Kelas: ${_loginData?.kelas ?? 'Kelas Tidak Tersedia'} | No.Induk: ${_loginData?.noInduk ?? 'No. Induk Tidak Tersedia'}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      // Navigate to history
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ValidasiPembayaranScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 27),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.teal.shade400,
                            Colors.teal.shade600,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.receipt_long_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Lapor Bayar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 13),
                Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: () {
                          // Navigate to history
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RiwayatPembayaranScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                color: Colors.black,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Riwayat Pembayaran Pondok',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 8),

                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5, // Setengah layar
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.teal.shade300,
                              Colors.teal.shade600,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.3),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.account_balance_wallet,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Saldo Uang Saku',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.8),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        currencyFormat.format(_loginData?.keuangan.saldo ?? 0),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
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



                    SizedBox(height: 8),

                    // Action Buttons for Uang Masuk and Uang Keluar
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          // Uang Masuk
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SakuMasukScreen()),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.green.shade100,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.trending_up,
                                        color: Colors.green.shade700,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Uang Masuk',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.green.shade800,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 8),

                          // Uang Keluar
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SakuKeluarScreen()),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.red.shade100,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade100,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.trending_down,
                                        color: Colors.red.shade700,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Uang Keluar',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.red.shade800,
                                        fontWeight: FontWeight.w600,
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
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.teal,  
                        width: 2.0,          
                      ),
                    ),
                  ),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0), 
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      return _buildMenuCard(
                        menuItems[index]['icon'],
                        menuItems[index]['label'],
                        () {
                          String label = menuItems[index]['label'];
                          switch (label) {
                            case 'Kesehatan':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => KesehatanScreen()),
                              );
                              break;
                            case 'Tahfidz':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => KetahfidzanScreen()),
                              );
                              break;
                            case 'Saran':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => KeluhanScreen(keluhanService: KeluhanService()),
                                ),
                              );

                              break;
                            default:
                              print('Navigasi ke: $label');
                          }
                        },
                      );
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(15), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 5.0),
                          child: Text(
                            'Informasi Santri',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildInfoItem(
                          Icons.person,
                          'Murroby',
                          '${_loginData?.namaMurroby ?? 'Tidak Tersedia'} - Kamar: ${_loginData?.kamar ?? 'Tidak Tersedia'}'),
                      _buildInfoItem(
                          Icons.person,
                          'Ustadz',
                          '${_loginData?.namaUstadTahfidz ?? 'Tidak Tersedia'} - ${_loginData?.kelasTahfidz ?? 'Tidak Tersedia'}'),
                      _buildInfoItem(Icons.home, 'Alamat',
                          _loginData?.alamat ?? 'Tidak Tersedia'),
                      _buildInfoItem(Icons.calendar_month, 'Tgl-Lahir',
                          _loginData?.tanggalLahir ?? 'Tidak Tersedia'),
                    ],
                  ),
                ),
                SizedBox(height: 5), 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                    child: ExpansionTile(
                      title: Text(
                        'Data Ortu',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5), 
                      children: [
                        _buildTextRow('Nama Ayah', _loginData?.namaAyah ?? 'Tidak Tersedia'),
                        _buildTextRow('Pendidikan', _loginData?.pendidikanAyah ?? 'Tidak Tersedia'),
                        _buildTextRow('Pekerjaan', _loginData?.pekerjaanAyah ?? 'Tidak Tersedia'),
                        _buildTextRow('Nama Ibu', _loginData?.namaIbu ?? 'Tidak Tersedia'),
                        _buildTextRow('Pendidikan', _loginData?.pendidikanIbu ?? 'Tidak Tersedia'), 
                        _buildTextRow('Pekerjaan', _loginData?.pekerjaanIbu ?? 'Tidak Tersedia'), 
                        _buildTextRow('No Ortu', _loginData?.noHp ?? 'Tidak Tersedia'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: GestureDetector(
                    onTap: () async {
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      await authProvider.logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LandingPage()), 
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 212, 97, 97), 
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
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
        );
      }

      Widget _buildInfoItem(IconData icon, String label, String value) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: Colors.teal),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

  Widget _buildMenuCard(IconData icon, String label, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.teal),
              SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}