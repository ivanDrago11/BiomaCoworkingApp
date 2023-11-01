import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bioma_application/models/areaModel.dart';
import 'package:flutter_bioma_application/pages/login.dart';
import 'package:flutter_bioma_application/pages/qrScreen.dart';
import 'package:flutter_bioma_application/pages/reservasScreen.dart';
import 'package:flutter_bioma_application/providers/area_provider.dart';
import 'package:flutter_bioma_application/providers/auth_providers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'areaDetailsScreen.dart';

class AreasScreen extends StatelessWidget {
  const AreasScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
               DrawerHeader(

              decoration: const BoxDecoration(
                 color: Colors.white,
                 image: DecorationImage(image: AssetImage('assets/LOGO.png'), fit: BoxFit.contain,)
              ),
              child: Container(),
            ),
            ListTile(
            title: const Text('Reservas'),
            onTap: () {
              Get.to(()=> const ReservasScreen(), transition: Transition.fade, duration: const Duration(seconds: 1 ,));
            }
            ),
            ListTile(
              title: const Text('Cerrar Sesión'),
              onTap: () {
                     authService.logout();
                     Get.offAll(()=> const LoginScreen(), transition: Transition.fade, duration: const Duration(seconds: 1));


                    //  Navigator.pushReplacementNamed(context, 'login');

              },
            ),
          ],
        ),
      ),
      // Drawer(
      //   child: ListView.builder(
      //     itemCount: 1,
      //     itemBuilder: ((context, index) {
      //     return ListTile(
      //       title: const Text('Reservas'),
      //       onTap: () {
      //         Get.to(()=>  ReservasScreen(), transition: Transition.fade, duration: const Duration(seconds: 1 ,));
      //       },
      //     );
      //   })),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.to(()=> const QRScreen(), transition: Transition.fade, duration: const Duration(seconds: 1 ,));
       },
        backgroundColor: Colors.green,
        child: const Icon(Icons.qr_code_rounded),),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Image(image: AssetImage('assets/LOGO.png'), fit: BoxFit.contain, width: 70,),
        iconTheme: const IconThemeData(color: Colors.green), 
        // Text('Bioma Cowork', style: GoogleFonts.roboto(shadows: customShadow),),
      ),
      body: Container(

        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.greenAccent, Colors.white], stops: [0.3, 0.8])
        // ),
        decoration: const BoxDecoration(
          // image: DecorationImage(image: AssetImage('assets/second-wallpaper.png'), fit: BoxFit.fill)
        ),
        width: double.infinity,
        child: SizedBox(
             child: FutureBuilder(
              future: getAreas(),
              builder: ((context, snapshot) {
                if( snapshot.connectionState == ConnectionState.waiting ) {
                  return const Center(child: CircularProgressIndicator());
                }else{

                  return _ListAreas(areas: snapshot.data!.areas);
                }
              })),
    //       child: ListView(
    //         physics: const BouncingScrollPhysics(),
    //         scrollDirection: Axis.vertical,
    //         children: const [
    //                CustomAreaCard(name: 'Sala de Juntas', capacidad: '10',precio: 100, available: true, image:'http://ibercenter.com/wp-content/uploads/2020/10/Sala-de-juntas.jpg' ),
    //                CustomAreaCard(name: 'Sala A5', capacidad: '5',precio: 150, available: false, image:'https://www.tdm.com.mx/wp-content/uploads/2020/08/equipo-de-videoconferencia-sala-de-juntas.jpeg' ),
    //                CustomAreaCard(name: 'Oficina A2', capacidad: '10',precio: 200, available: false, image:'https://s3-us-west-2.amazonaws.com/wp-clustar/wp-content/uploads/2022/02/15180125/Imagen-sala-de-juntas-yellow.png' ),
    //                CustomAreaCard(name: 'Oficina B5', capacidad: '8',precio: 180, available: true, image:'https://www.centrum750.com/wp-content/uploads/2020/03/salas-paris-2-min.jpg' ),
    //                CustomAreaCard(name: 'Oficina A7', capacidad: '5',precio: 120, available: false, image:'https://izabc.b-cdn.net/wp-content/uploads/2018/08/RentadeSalasdeJuntasenIZABusinessCenters.jpeg' ),
    //                CustomAreaCard(name: 'Oficina B8', capacidad: '7',precio: 170, available: true, image:'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPE1Kwh1slGm0ad8dmi64TsbpzUWB8yWaEJg&usqp=CAU' ),
    //  ] )
    )
    )
    );

  }
}

class _ListAreas extends StatelessWidget {
  const _ListAreas({super.key, required this.areas});
  final List<Area> areas;


  @override
  Widget build(BuildContext context) {
    final areaService = Provider.of<AreaService>(context);
          areaService.areas = areas;

    return ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: areas.length,
            itemBuilder: (context, index) {

              final area = areas[index];

              return CustomAreaCard(available: false, capacidad: area.capacity, name: area.name, image: area.image, precio: area.pricePerHour, description: area.description,);
            });
  }
}




Future<AreaModel> getAreas() async{
  final resp = await http.get(Uri.parse(dotenv.get('API_URL_EMU') + '/api/areas'));
  return areaModelFromJson(resp.body);

}



class CustomAreaCard extends StatelessWidget {
  const CustomAreaCard({
    Key? key, required this.available, required this.capacidad, required this.name, required this.image, required this.precio, required this.description,
  }) : super(key: key);
  final String image;
  final num precio;
  final bool available;
  final String capacidad;
  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(5),
             ),
      child: Column(
             children: [
                ImageCard(image: image, precio: precio,capacidad: capacidad, name: name, description: description,),
                CustomCardFooter(available: available, capacidad: capacidad, name: name,),

              ]),
      );
  }
}



class CustomCardFooter extends StatelessWidget {
  const CustomCardFooter({
    Key? key, required this.available, required this.capacidad, required this.name,
  }) : super(key: key);
  final bool available;
  final String capacidad;
  final String name;

  @override
  Widget build(BuildContext context) {
    var list = ["one", "two", "three", "four", "five"];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 140,
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      // available
                      // ? const Text('Disponible', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.green ))
                      // : const Text('No Disponible', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.red )),

                    // const SizedBox(height: 10,),
                    Text(
                      'Capacidad: $capacidad',
                      style: const TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 2,),
                    Row(
              mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
               for(var item in list ) Icon(Icons.star, color: Colors.amber,)
               ],
        ), 
                  ],
                ),
              ),
                SizedBox(
                width: 140,
                height: 40,
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black ,)
                ),
              ),
               
            ],
          ),
        ),

      ],
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({
    Key? key, required this.image, required this.precio, required this.capacidad, required this.name, required this.description,
  }) : super(key: key);
  final String image;
  final num precio;
  final String capacidad;
  final String name;
  final String description;


  @override
  Widget build(BuildContext context) {
    Uint8List _bytes = base64.decode( image.split(',').last);
    return Stack(
    children: [
     Ink.image(
       image: MemoryImage(_bytes),
       height: 150,
       width: 370,
       fit: BoxFit.cover,
       child: InkWell(
         onTap: (() {
           Get.to(()=>  AreaDetailsScreen(name: name, capacidad: capacidad, precio: precio, image: image, description: description,), transition: Transition.fade, duration: const Duration(seconds: 1 ,));
         }
       ),
     ),
     ),



     Positioned(
       bottom: 12,
       right: 10,

       child: Container(
         decoration:const BoxDecoration(
           borderRadius: BorderRadius.all(Radius.circular(15))
           , color: Colors.white,
         ),
         child: Padding(
           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
           child: Text(
                 '\$$precio/hr',
                 style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
           ),
         ),
       ),
     ),
              ],
            );
  }
}