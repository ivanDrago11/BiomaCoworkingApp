import 'package:flutter/material.dart';
import 'package:flutter_bioma_application/pages/login.dart';
import 'package:flutter_bioma_application/pages/qrScreen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'areaDetailsScreen.dart';

class AreasScreen extends StatelessWidget {
  const AreasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(()=>  const QRScreen(), transition: Transition.fade, duration: const Duration(seconds: 1 ,));
       },
        backgroundColor: Colors.green,
        child: const Icon(Icons.qr_code_rounded),),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
        child: SizedBox(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: const [
                   CustomAreaCard(name: 'Sala de Juntas', capacidad: '10',precio: '500', available: true, image:'http://ibercenter.com/wp-content/uploads/2020/10/Sala-de-juntas.jpg' ),
                   CustomAreaCard(name: 'Sala A5', capacidad: '5',precio: '250', available: false, image:'https://www.tdm.com.mx/wp-content/uploads/2020/08/equipo-de-videoconferencia-sala-de-juntas.jpeg' ),
                   CustomAreaCard(name: 'Oficina A2', capacidad: '10',precio: '300', available: false, image:'https://s3-us-west-2.amazonaws.com/wp-clustar/wp-content/uploads/2022/02/15180125/Imagen-sala-de-juntas-yellow.png' ),
                   CustomAreaCard(name: 'Oficina B5', capacidad: '8',precio: '400', available: true, image:'https://www.centrum750.com/wp-content/uploads/2020/03/salas-paris-2-min.jpg' ),
                   CustomAreaCard(name: 'Oficina A7', capacidad: '5',precio: '370', available: false, image:'https://izabc.b-cdn.net/wp-content/uploads/2018/08/RentadeSalasdeJuntasenIZABusinessCenters.jpeg' ),
                   CustomAreaCard(name: 'Oficina B8', capacidad: '7',precio: '410', available: true, image:'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPE1Kwh1slGm0ad8dmi64TsbpzUWB8yWaEJg&usqp=CAU' ),
                   
     ] )
    )
    )
    );
    
  }
}

class CustomAreaCard extends StatelessWidget {
  const CustomAreaCard({
    Key? key, required this.available, required this.capacidad, required this.name, required this.image, required this.precio,
  }) : super(key: key);
  final String image;
  final String precio;
  final bool available;
  final String capacidad;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(24),
             ),
      child: Column(
             children: [
                ImageCard(image: image, precio: precio,capacidad: capacidad, name: name),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 140,
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                      available 
                      ? const Text('Disponible', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.green ))
                      : const Text('No Disponible', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.red )),
                    
                    const SizedBox(height: 10,),
                    Text(
                      'Capacidad: $capacidad',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
                SizedBox(
                width: 120,
                height: 70,
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
    Key? key, required this.image, required this.precio, required this.capacidad, required this.name,
  }) : super(key: key);
  final String image;
  final String precio;
  final String capacidad;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Stack(
    children: [
     Ink.image(
       image: NetworkImage(
       image,
       ),
       height: 150,
       width: 330,
       fit: BoxFit.cover,
       child: InkWell(
         onTap: (() {
           Get.to(()=>  AreaDetailsScreen(name: name, capacidad: capacidad, precio: precio, image: image,), transition: Transition.fade, duration: const Duration(seconds: 1 ,));
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