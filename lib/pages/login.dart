

import 'package:flutter/material.dart';
import 'package:flutter_bioma_application/pages/areasScreen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth_providers.dart';
import '../providers/login_provider.dart';
import '../utils/notifications_service.dart';

class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // backgroundColor: Color(0xFFFc74848),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/second-wallpaper.png'), fit: BoxFit.fill)
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
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        const SizedBox(height: 10,),
        Text('BiomaCowork',style: GoogleFonts.openSans(fontSize: 40, color: Colors.white, shadows: customShadow)),
        const SizedBox(height: 10,),
        Text('Ingresa tu cuenta',style: GoogleFonts.openSans(fontSize: 20, color: Colors.white, shadows: customShadow)
    ),
        const SizedBox(height: 30,),

        ChangeNotifierProvider(create: (context) => LoginFormProvider(),
        child: const _LoginFields(),),

        TextButton(onPressed: () {}, child:Text('¿Olvidaste tu contraseña?',style: GoogleFonts.openSans(fontSize: 15, color: Color(0xfff388080), fontWeight: FontWeight.bold))),
        const SizedBox(height: 20,),
     
      ],
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
          color: const Color(0xfff388080),
              ),
              width: double.infinity,
              child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, ),
            child: TextFormField(
              style: const TextStyle(color: Colors.white70),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: InputBorder.none,
                errorStyle: TextStyle(color: Colors.white70, wordSpacing: 0),
                hintText: 'example@mail.com',
                hintStyle: TextStyle(color: Colors.white70)
                  
              ),
              validator: ((value) {
                 String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExp  = RegExp(pattern);
    
                    return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El correo no es valido';
                              
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
          color: const Color(0xfff388080),
              ),
              width: double.infinity,
              child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: TextFormField(
              obscureText: true,
              style: const TextStyle(color: Colors.white70),
              decoration: const InputDecoration(
                border: InputBorder.none,
                errorStyle: TextStyle(color: Colors.white70),
                errorBorder: InputBorder.none,
                hintText: '**********',
                hintStyle: TextStyle(color: Colors.white70),
              ),
              validator: (value) {
                
                return (value != null && value.length >= 6) 
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
          color: Colors.blueAccent,
          ),
      child: MaterialButton(
          onPressed: loginForm.isLoading ? null : () async {
                
                FocusScope.of(context).unfocus();
                
                final authService = Provider.of<AuthService>(context, listen: false);
                
                if( !loginForm.isValidForm() ) return NotificationsService.showSnackbar('Campos Invalidos');

                loginForm.isLoading = true;


                // TODO: validar si el login es correcto
                final String? errorMessage = await authService.login(loginForm.email, loginForm.password);

                if ( errorMessage == null ) {
                  Get.offAll(()=> const AreasScreen(), transition: Transition.fade, duration: const Duration(seconds: 1 ,));
                  // Navigator.pushReplacementNamed(context, 'mapa');
                } else {
                  // TODO: mostrar error en pantalla
                  // print( errorMessage );
                  NotificationsService.showSnackbar(errorMessage);
                  loginForm.isLoading = false;
                }
              },
          child: Text(
            loginForm.isLoading 
            ? 'Espere'
            : 'Ingresar', 
            style: GoogleFonts.openSans(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)
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
      blurRadius: 10.0,
      color: Color.fromARGB(248, 0, 0, 0),
    ),
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 10.0,
      color: Color.fromARGB(251, 0, 0, 0),
    ),
  ];
  }