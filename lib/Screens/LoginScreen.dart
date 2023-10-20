// ignore_for_file: file_names, avoid_print, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_task/Controllers/google_sign_in_controller.dart';
import 'package:todo_task/Screens/HomeScreen.dart';
import 'package:todo_task/constants/Clrs.dart';
import 'package:todo_task/constants/Txt.dart';

import '../constants/TxtStyles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GoogleSigninController googleSignInController = Get.put(GoogleSigninController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
           
          //  Obx(() {
            // return 
            GestureDetector(
              onTap: (() {
                User? user;
                googleSignInController.signInWithGoogle().then((User? user) {
                  print(user);
                   if(user != null){
                  
                   Get.to(() => const HomeScreen());
  
                } else {
                 return const Center(child:  CircularProgressIndicator(color: Colors.blueAccent,));
                }
                  
                });
               
                // debugPrint('hiii');
                
              }),
              child: Padding(
               padding: const EdgeInsets.only(left: 50,right: 50),
               child: Container(
                padding: const EdgeInsets.all(10),
                width: size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Clrs.greyClr),
                  borderRadius: BorderRadius.circular(16),
                ),
                child:  Center(child: Row(
                  children: [
                    
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Image.asset("assets/google_logo.png",fit: BoxFit.contain,)),
                      const SizedBox(width: 10,),
                    const Text(Txt.googleSignin,style: TxtStyles.signInStyle,),
                  ],
                )))),
            ),
             
          //  },)
        ],
      ),

    ),);
    
  }

}