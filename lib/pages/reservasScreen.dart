


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bioma_application/providers/area_provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../database/db.dart';
import '../models/reservaModel.dart';
import '../providers/user_provider.dart';
import 'login.dart';
import 'qrScreen.dart';
import 'reservaDetailScreen.dart';
import 'package:http/http.dart' as http;

class ReservasScreen extends StatefulWidget {
  const ReservasScreen({super.key});

  @override
  State<ReservasScreen> createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(67, 23, 195, 178),
        title:  Text('Bioma Cowork', style: GoogleFonts.roboto(shadows: customShadow),),
      ),
      body: Container(
        
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.greenAccent, Colors.white], stops: [0.3, 0.8])
        // ),
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/second-wallpaper.png'), fit: BoxFit.fill)
        ),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: SizedBox(
            height: 500,
            child: FutureBuilder(
              future: getReservas(),
              builder: ((context, snapshot) {
                
              if (snapshot.connectionState == ConnectionState.none) {
                print(snapshot.connectionState);
                return CircularProgressIndicator();
        
              } else if(snapshot.connectionState == ConnectionState.done) {
                print('cargando reservas');

                // print(snapshot.data!.reservas);
                List<Reserva> misReservas = [];
                final object = jsonEncode(userService.activeUser);
                final usuario = jsonDecode(object);
                // print(usuario['name']);
                print(snapshot.data!.reservas.map((e) => {
                  if(usuario['name'] == e.usuario ){
                    misReservas.add(e)
                    // print('Aqui VA'),
                    // print(e.area)
                  },
                }));
                // print(misReservas);
                 return _ListReservas(reservas: misReservas);
                // print(snapshot.connectionState);
                // final List<Reserva> reservaslist = snapshot.data!;
            
            
                
             }
             return Container();
            }))
            ),
        )
    )
    );
    
  }
}

class _ListReservas extends StatelessWidget {
  const _ListReservas({super.key, required this.reservas});
  final List<Reserva> reservas;
  @override
  Widget build(BuildContext context) {
  final areaService = Provider.of<AreaService>(context, listen: false);
  final userService = Provider.of<UserService>(context, listen: false);

   int _currentValue = 5;
   num costoTotal = 5;
    return ListView.builder(
          itemCount: reservas.length,
          itemBuilder: ((context, index) {
            final reserva  = reservas[index];
            return SizedBox(
              height: 400,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                // shrinkWrap: true,
                children: reservas.map(
                (item) => 
                Column(
                  children: [
                      Card(
                      color: const Color.fromARGB(115, 76, 175, 79),
                      child: Dismissible(
                        background: Container(
                          color: Colors.red,
                          child: const ListTile(leading: Icon(Icons.delete_forever, size: 50,))
                          ),
                        secondaryBackground: Container(
                          color: Colors.green,
                          child: const ListTile(trailing: Icon(Icons.edit_calendar_outlined, size: 50,))
                          ),
                        key: Key('key'),
                        onDismissed: (direction) async{
            
                        if (direction == DismissDirection.startToEnd){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) { 
                              return AlertDialog(
                              title: const Text('¿Estas seguro de eliminarlo?'),
                              actions: [
                              TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  // setState(() {}); 
                                  }, 
                                child: const Text('Cancelar')),
                        
                              TextButton(
                                onPressed: () async {
                                  
                                  var result = await http.delete(Uri.parse('http://10.0.2.2:4000/api/reservas'),body: {'area': item.area, 'usuario': item.usuario, 'start' : item.start.toString(), 'end': item.end.toString(), 'price': item.price.toString(), 'codigoQR': item.codigoQr, 'id' : item.id});
                                  print(result.body);
                                  // var delete = await  await http.delete(Uri.parse('http://10.0.2.2:4000/api/reservas'));
                                  reservas.remove(item);
                                  Navigator.pop(context);
                                  // setState(() {});
                                }, 
                                child: const Text('Confirmar')),
                            ],
                                );
                               }, 
                              );
                             }
            
                            if(direction == DismissDirection.endToStart){
                              DateTime? newDate = await getDatePickerWidget(context);
            
                              if (newDate != null) {
                              String dateFormated = DateFormat('yyyy-MM-dd').format(newDate);
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
                                  onPressed: () { Navigator.pop(context); 
                                  },
                                ),
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () { 
                                    Navigator.pop(context, costoTotal); 
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
                                      //  print(value),
                                      //  print(widget.precio),
                                        costoTotal = value * item.price
                                        }),
                             
                          }
                          );
                        },
                      ),
                    );
                    },
                  );
                if (hours != null) {
                  // var result = await DB.insert(Reserva(usuario: 'Cliente', oficina: item.oficina, costo: costoTotal, fecha: dateFormated.toString() ,hora: timeFormated.toString() , codigoQR: item.oficina + newDate.toString() + newTime.toString(), image: item.image));
                  final usuario = {
                    'area': item.area,
                    'usuario': item.usuario,
                    'start': dateFormated.toString(),
                    'end': dateFormated.toString(),
                    'price': costoTotal.toString(),
                    'codigoQR': item.area + newDate.toString() + newTime.toString()
                  };
                  final resp = await http.put(Uri.parse('http://10.0.2.2:4000/api/reservas'), body: usuario);
                  // var deleteObsolete = await DB.delete(item);
                  print(resp.toString());
                  print('Actualizado');
                  Get.snackbar('Bioma Cowork', 'Modificado con Exito', duration: const Duration(seconds: 3), backgroundColor:Colors.blue);
                  // setState(() {});
                }
                  // final resp = await http.get(Uri.parse('http://10.0.2.2:4000/api/areas'));
                }else{
                  // setState(() {});
                }
                }else{
                  // setState(() {});
                }
                  
              }    
            
                      },
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.area),
                            
                            Text(item.usuario),
                          ],
                        ),
                        leading: const Icon(Icons.book_outlined),
                        trailing: const Icon(Icons.arrow_forward_ios_outlined),
                        
                        onTap: () {
                          final object = jsonEncode(areaService.areas);
                          final List<dynamic> areas = jsonDecode(object);
                          final area = areas.firstWhere((element) => element['name'] == item.area, orElse: () => print('No matching element.'));
                          print(area['image']);
                          Get.to(()=>  ReservaDetailsScreen(fecha: item.start.toString(), hora: item.start.toString(), image: area['image'], name: item.area, costo: item.price, codigoQR: item.codigoQr.toString(),), transition: Transition.fade, duration: const Duration(seconds: 1 ,));
                        },
                        
                      ),
                    ),
                  ),
              SizedBox(height: 10)             
                      ],
                    ),
                      
                   //Mostrar el titulo principal aqui
              
                )
                .toList(),
                  ),
            ); 
            }));
  }
}


// ignore: camel_case_types
class _headerImage extends StatelessWidget {
  const _headerImage({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 350,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
        child: Image(image: NetworkImage(image),fit: BoxFit.cover,)),
    );
  }
}

// ignore: camel_case_types
class _areaDetails extends StatelessWidget {
  const _areaDetails({super.key, required this.name, required this.precio, required this.capacidad});
  final String name;
  final String precio;
  final String capacidad;
  @override
  Widget build(BuildContext context) {
 var reserva = DB.reservas();
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
			    Text(name, style: GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.w500),),
			  ],
			),),
			
        ),
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0 ),
			child: Text('Comoda sala de juntas que esta acondicionada con las mas utiles necesidades de la actualidad.', style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w300, ),textAlign: TextAlign.justify,),),
			
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
                 '$precio/hr',
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
                 '$capacidad',
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
              print(reserva);
              
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
		initialDate: DateTime.now() , 
		firstDate: DateTime(2010), 
		lastDate: DateTime(2025),
    

    
  );
}

Future<TimeOfDay?> getPickerTime(BuildContext context) {
  return showTimePicker(
   	context: context, 
    initialTime: TimeOfDay.now(),
		
  );
}

// Future<List<Reserva>>getReservasList () async{

//   final consulta = await DB.reservas();
//     return consulta;
// }

Future<ReservaModel> getReservas() async{
  final resp = await http.get(Uri.parse('http://10.0.2.2:4000/api/reservas'));
  // print(resp.body);
  return reservaModelFromJson(resp.body);

}