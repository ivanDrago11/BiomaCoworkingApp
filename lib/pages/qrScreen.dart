import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../providers/user_provider.dart';
import 'login.dart';

class QRScreen extends StatelessWidget {
  const QRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
    final object = jsonEncode(userService.activeUser);
    final usuario = jsonDecode(object);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 2,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Image(image: AssetImage('assets/LOGO.png'), fit: BoxFit.contain, width: 70,),
        iconTheme: const IconThemeData(color: Colors.green), 
        // Text('Bioma Cowork', style: GoogleFonts.roboto(shadows: customShadow),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: QrImage(data: usuario['id'], size: 250,),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 75),
              child: Text('Utiliza este codigo QR para entrar en las instalaciones', style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w300, ),textAlign: TextAlign.justify,),
            ),
			
          ],
        ),
      ),
    );
  }
}