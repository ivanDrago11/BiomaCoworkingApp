

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bioma_application/models/reserva.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../database/db.dart';

class ReservaDetailsScreen extends StatefulWidget {
  const ReservaDetailsScreen({super.key, required this.name, required this.image, required this.fecha, required this.hora, required this.costo, required this.codigoQR});
  final String name;
  final String image;
  final String fecha;
  final String hora;
  final String codigoQR;
  final num costo;

  @override
  State<ReservaDetailsScreen> createState() => _ReservaDetailsScreenState();
}

class _ReservaDetailsScreenState extends State<ReservaDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(0, 23, 195, 178),
        
      ),
      body: Column(
        children: [
          	  _headerImage(image: widget.image),
          		_areaDetails(name: widget.name, image: widget.image, fecha: widget.fecha, hora: widget.hora, costo: widget.costo, codigoQR: widget.codigoQR,)
        ],
      ),
    );
  }
}
// ignore: camel_case_types
class _headerImage extends StatelessWidget {
  const _headerImage({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
  Uint8List _bytes = base64.decode( image.split(',').last);
    return  SizedBox(
      height: 350,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
        child: Image(image: MemoryImage(_bytes),fit: BoxFit.cover,)),
    );
  }
}

// ignore: camel_case_types
class _areaDetails extends StatefulWidget {
  const _areaDetails({super.key, required this.name,  required this.image, required this.fecha, required this.hora, required this.costo, required this.codigoQR});
  final String name;
  final String image;
  final String fecha;
  final String hora;
  final String codigoQR;
  final num costo;

  @override
  State<_areaDetails> createState() => _areaDetailsState();
}

class _areaDetailsState extends State<_areaDetails> {
  int _currentValue = 5;
  num costoTotal = 5;
  @override
  Widget build(BuildContext context) {
    return Column(
		crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20 ),
			child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
			  children: [
				const Icon(Icons.business_center_outlined, size: 35),
				const SizedBox(width: 10,),
			    Text(widget.name, style: GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.w500),),
			  ],
			),),
			
        ),
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0 ),
			child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
			  children: [
			    Text(widget.fecha.replaceRange(10, 24, ''), style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w300, ),textAlign: TextAlign.justify,),
			    // Text(widget.hora.replaceRange(0, 10, ''), style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w300, ),textAlign: TextAlign.justify,),
			  ],
			),),
			
        ),
		
		Row(
      mainAxisAlignment: MainAxisAlignment.center,
		  children: [
		    Padding(
            padding: const EdgeInsets.only(left:40, top: 30, bottom: 10 ),
		    	child: Text('A pagar: ', style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w500),)
		    	),
			Padding(
			  padding: const EdgeInsets.only(right: 20,left: 10, top: 30, bottom: 10 ),
			  child: Container(
         decoration:const BoxDecoration(
           borderRadius: BorderRadius.all(Radius.circular(15))
           , color: Colors.black,
         ),
         child: Padding(
           padding: const  EdgeInsets.symmetric(vertical: 5, horizontal: 8),
           child: Text(
                 '\$${widget.costo}',
                 style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
           ),
         ),
       ),
				),
			 
				
		  ],
		),
			SizedBox(height: 10,),
    QrImage(data: widget.codigoQR, size: 190,)
      ],




      
    );






  }
}

