


import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bioma_application/models/reserva.dart';
import 'package:flutter_bioma_application/providers/user_provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../database/db.dart';

class AreaDetailsScreen extends StatefulWidget {
  const AreaDetailsScreen({super.key, required this.name, required this.precio, required this.capacidad, required this.image, required this.description});
  final String name;
  final num precio;
  final String capacidad; 
  final String image;
  final String description;

  @override
  State<AreaDetailsScreen> createState() => _AreaDetailsScreenState();
}

class _AreaDetailsScreenState extends State<AreaDetailsScreen> {
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
          		_areaDetails(name: widget.name, precio: widget.precio, capacidad: widget.capacidad,image: widget.image, description: widget.description,)
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
  const _areaDetails({super.key, required this.name, required this.precio, required this.capacidad, required this.image, required this.description});
  final String name;
  final num precio;
  final String capacidad;
  final String image;
  final String description;

  @override
  State<_areaDetails> createState() => _areaDetailsState();
}

class _areaDetailsState extends State<_areaDetails> {
  int _currentValue = 5;
  num costoTotal = 5;
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
    return Column(
		crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20 ),
			child: Row(
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
			child: Text(widget.description, style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w300, ),textAlign: TextAlign.justify,),),
			
        ),
		Padding(
            padding: const EdgeInsets.only(right: 40,left: 40, top: 25, bottom: 10 ),
			child: Text('Amenidades', style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500),)
			),
		Padding(
		  padding: const EdgeInsets.symmetric(horizontal: 40, ),
		  child: Row(
			mainAxisAlignment: MainAxisAlignment.spaceEvenly,
		  	children: const [
		  		Icon(Icons.air_outlined, size: 50,color: Colors.green,),
		  		Icon(Icons.coffee_outlined, size: 50,color: Colors.green,), 
		  		Icon(Icons.wifi, size: 50,color: Colors.green,),
		  		Icon(Icons.fastfood_rounded, size: 50,color: Colors.green,), 
		  		Icon(Icons.print, size: 50,color: Colors.green,), 
		  	],
		  ),
		),
		Row(
		  children: [
		    Padding(
            padding: const EdgeInsets.only(left:40, top: 30, bottom: 10 ),
		    	child: Text('Precio: ', style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500),)
		    	),
			Padding(
			  padding: const EdgeInsets.only(right: 20,left: 10, top: 30, bottom: 10 ),
			  child: Container(
         decoration:const BoxDecoration(
           borderRadius: BorderRadius.all(Radius.circular(15))
           , color: Colors.black,
         ),
         child: Padding(
           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
           child: Text(
                 '${widget.precio}/hr',
                 style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
           ),
         ),
       ),
				),
				Padding(
            padding: const EdgeInsets.only(left:0, top: 30, bottom: 10 ),
		    	child: Text('Capacidad: ', style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500),)
		    	),
				Padding(
			  padding: const EdgeInsets.only(right: 20,left: 10, top: 30, bottom: 10 ),
			  child: Container(
         decoration:const BoxDecoration(
           borderRadius: BorderRadius.all(Radius.circular(15))
           , color: Colors.black,
         ),
         child: Padding(
           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
           child: Text(
                 '${widget.capacidad}',
                 style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
           ),
         ),
       ),
				),
		  ],
		),

		Padding(
		  padding: const EdgeInsets.symmetric(vertical: 20),
		  child: Center(
		  		  child: Container(
		  			width: 200,
		  			decoration: BoxDecoration(
		  				borderRadius: const BorderRadius.all(Radius.circular(15)),
		  				gradient: const LinearGradient(colors: [Color.fromARGB(255, 76, 175, 79), Color.fromARGB(142, 76, 175, 79), Colors.green], begin: Alignment.centerLeft, end: Alignment.centerRight, stops: [0.01, 0.6, 0.9]),
						boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 4,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                )
              ]
		  			),
		  			child: TextButton( 
						child: Text(
							'Agendar', 
							style: GoogleFonts.roboto(
								fontSize: 20, 
								fontWeight: FontWeight.w600, 
								color: Colors.white),
								),
						onPressed: () async{

							DateTime? newDate = await getDatePickerWidget(context);

              if (newDate != null) {
              String dateFormated = DateFormat('yyyy-MM-dd').format(newDate!);
              TimeOfDay? newTime = await getPickerTime(context);
              

              if(newTime != null){
                final localizations = MaterialLocalizations.of(context);
                final timeFormated = localizations.formatTimeOfDay(newTime!);
               var hours = await showDialog(context: context, builder: (context) {

                  return AlertDialog(
                    title: const Text('¿Cuantas horas quieres reservar la oficina?'),
                    actions: [

                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () { Navigator.pop(context); },
                      ),
                      TextButton(
                        child: Text('OK'),
                        onPressed: () { 
                          Navigator.pop(context, [costoTotal, _currentValue]); 
                          },

                      ),
                      ],

                    content: StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) setState) {  
                       return NumberPicker(
                        minValue: 1, 
                        maxValue: 8, 
                        value: _currentValue,
                        axis: Axis.horizontal,
                         
                        onChanged: (value) => {
                          setState(() => {
                            _currentValue = value,
                            print(value),
                            print(widget.precio),
                            costoTotal = value * widget.precio
                            }),
                           
                        }
                        );
                      },
                    ),
                   );
                  },
                );
              if (hours != null) {
                final object = jsonEncode(userService.activeUser);
                final Map<String, dynamic> usuario = jsonDecode(object);
                print(usuario['name']);
                
                   var result = await http.post(Uri.parse('http://10.0.2.2:4000/api/reservas'),body: {'area': widget.name, 'usuario': usuario['name'], 'start' : dateFormated.toString(), 'end': dateFormated.toString(), 'price': costoTotal.toString(), 'codigoQR': widget.name + newDate.toString() + newTime.toString()});
                   print(result.body);
                Get.snackbar('Bioma Cowork', 'Agendado con Exito', duration: const Duration(seconds: 3), backgroundColor: Color(0xfff73B59E));
                // var result = DB.insert(Reserva(usuario: 'Cliente', oficina: widget.name, costo: costoTotal, fecha: dateFormated.toString() ,hora: timeFormated.toString() , codigoQR: widget.name + newDate.toString() + newTime.toString(), image: widget.image));
                // print(result);
              }
                
              }
              }
              
						},
						  )
					),
		  		),
		)
			
		
		
      ],




      
    );






  }
}

Future<DateTime?> getDatePickerWidget(BuildContext context) {
  return showDatePicker(
   	context: context, 
		initialDate: DateTime.now(), 
		firstDate: DateTime.now(), 
		lastDate: DateTime.now().add(const Duration(days: 30)),
    

    
  );
}

Future<TimeOfDay?> getPickerTime(BuildContext context) {
  return showTimePicker(
   	context: context, 
    initialTime: TimeOfDay.now(),
    
  );
}

