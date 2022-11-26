

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AreaDetailsScreen extends StatelessWidget {
  const AreaDetailsScreen({super.key, required this.name, required this.precio, required this.capacidad, required this.image});
  final String name;
  final String precio;
  final String capacidad; 
  final String image;

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
          	    _headerImage(image: image),
          		_areaDetails(name: name, precio: precio, capacidad: capacidad,)
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
							DateTime? newDate = await showDatePicker(
								context: context, 
								initialDate: DateTime.now(), 
								firstDate: DateTime(2022), 
								lastDate: DateTime(2023)
								);
						},
						  )
					),
		  		),
		)
			
		
		
      ],
    );
  }
}