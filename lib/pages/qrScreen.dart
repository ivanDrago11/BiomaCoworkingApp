import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'login.dart';

class QRScreen extends StatelessWidget {
  const QRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(67, 23, 195, 178),
        title:  Text('QR', style: GoogleFonts.roboto(shadows: customShadow),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: QrImage(data: 'Hola', size: 250,),
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