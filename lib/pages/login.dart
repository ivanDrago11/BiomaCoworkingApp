

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bioma_application/pages/areasScreen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth_providers.dart';
import '../providers/login_provider.dart';
import '../providers/user_provider.dart';
import '../utils/notifications_service.dart';

class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // backgroundColor: Color(0xFFFc74848),
      body: Container(
        decoration: const BoxDecoration(
          // image: DecorationImage(image: AssetImage('assets/second-wallpaper.png'), fit: BoxFit.cover)
        ),
        width: double.infinity,
        child: const SafeArea(
          child: _LoginForm()),
      ),
    );
  }
}




class _LoginForm extends StatelessWidget {
  const _LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50,),

          const Image(image: AssetImage('assets/LOGO.png'), fit: BoxFit.contain, width: 200,),
       
          // Text('BiomaCowork',style: GoogleFonts.inconsolata(fontSize: 40, color: Colors.white,fontWeight: FontWeight.bold, shadows: customShadow)),
          const SizedBox(height: 40,),
          
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 90,vertical: 10 ),
            height: 25,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            // color: Colors.white,
            // border: Border.all(
            //   color: Colors.white,
            //    width: 2)
                ),
            child: Text('Ingresa tu cuenta', style: GoogleFonts.inconsolata(fontSize: 18, color: Colors.green,fontWeight: FontWeight.bold,)),
          ),
          const SizedBox(height: 2,),
    
          ChangeNotifierProvider(create: (context) => LoginFormProvider(),
          child: const _LoginFields(),),
    
          TextButton(onPressed: () {}, child:Text('¿Olvidaste tu contraseña?',style: GoogleFonts.openSans(fontSize: 15, color: Colors.green, fontWeight: FontWeight.bold))),
          const SizedBox(height: 20,),
       
        ],
      ),
    );
  }

}


class _LoginFields extends StatelessWidget {
  const _LoginFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
    
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              height: 60,
              decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.green,
              ),
              width: double.infinity,
              child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, ),
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: InputBorder.none,
                errorStyle: TextStyle(color: Colors.white, wordSpacing: 0),
                hintText: 'example@mail.com',
                hintStyle: TextStyle(color: Colors.white)
                  
              ),
              validator: ((value) {
                //  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                //     RegExp regExp  = RegExp(pattern);
    
                //     return regExp.hasMatch(value ?? '')
                //     ? null
                //     : 'El correo no es valido';
                              
              }
            ),
            onChanged: (value) => loginForm.email = value,
            ),
          ),
              )
              ),
        const SizedBox(height: 30,),
    
    
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              height: 60,
              decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.green,
              ),
              width: double.infinity,
              child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: TextFormField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                errorStyle: TextStyle(color: Colors.white),
                errorBorder: InputBorder.none,
                hintText: '**********',
                hintStyle: TextStyle(color: Colors.white),
              ),
              validator: (value) {
                
                return (value != null && value.length >= 1) 
                ? null
                : 'La contraseña debe ser mayor a 6 caracteres';
                
              },
              onChanged: (value) => loginForm.password = value,
            ),
          ),
              )
              ),
    
             const SizedBox(height: 30,),
    
      Container(
      margin: const EdgeInsets.symmetric(horizontal: 30,),
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
          border: Border.all(color: Colors.green, width: 5)
          ),
      child: MaterialButton(
          onPressed: loginForm.isLoading ? null : () async {
                
                FocusScope.of(context).unfocus();
                
                final authService = Provider.of<AuthService>(context, listen: false);
                final userService = Provider.of<UserService>(context, listen: false);
                
                if( !loginForm.isValidForm() ) return NotificationsService.showSnackbar('Campos Invalidos');

                loginForm.isLoading = true;


                // TODO: validar si el login es correcto
                final String response = await authService.login(loginForm.email, loginForm.password);
                final resp = jsonDecode(response); 
                // print(resp['user']['name']);
                // print(userService.activeUser);

                if ( resp['user'] != null ) {
                  Get.offAll(()=> const AreasScreen(), transition: Transition.fade, duration: const Duration(seconds: 1 ,));
                  userService.activeUser = resp['user'];
                  print('Active User');
                  print(userService.activeUser);
                  // Navigator.pushReplacementNamed(context, 'mapa');
                } else {
                  // TODO: mostrar error en pantalla
                  // print( errorMessage );
                  NotificationsService.showSnackbar(resp['msg']);
                  loginForm.isLoading = false;
                }
              },
          child: Text(
            loginForm.isLoading 
            ? 'Espere'
            : 'Ingresar', 
            style: GoogleFonts.openSans(fontSize: 15, color: Colors.green, fontWeight: FontWeight.bold)
            ),
            ),
        )
    
        ],
      ),
    );
  }
}



 List<Shadow> get customShadow {
    return const <Shadow>[
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 1.0,
      color: Color.fromARGB(248, 0, 0, 0),
    ),
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 10.0,
      color: Color.fromARGB(251, 0, 0, 0),
    ),
  ];
  }