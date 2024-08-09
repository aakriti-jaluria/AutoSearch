import 'package:auto_search/maps_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'dart:developer' as developer;

class OTPpage extends StatefulWidget {

  String otpfromloginpage="";
  OTPpage(this.otpfromloginpage);

  @override
  State<OTPpage> createState() => _OTPpageState();
}

class _OTPpageState extends State<OTPpage> {
  var otp = '';


  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFFF4C9), Color(0xffFFFFE0).withOpacity(0.6)],
            begin: FractionalOffset(0.5, 0.0),
            end: FractionalOffset(0.5, 1.0),
            stops: [0.4, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.2), // 20% of screen height
              Stack(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/auto.png',
                      width: width * 0.6, // 60% of screen width
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 14,
                    child: Center(
                      child: Container(
                        width: width * 0.6, // 60% of screen width
                        height: 3,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.02), // 2% of screen height

              Center(
                child: Text(
                  'Enter OTP',
                  style: TextStyle(fontSize: height*0.035, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: height * 0.01), // 1% of screen height

              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.1), // 10% of screen width
                child: Text(
                  'We have sent an OTP on your registered phone number',
                  style: TextStyle(fontSize: height*0.016),
                  textAlign: TextAlign.center,
                ),
              ),


              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: width * 0.1), // 10% of screen width
              //   child: Text(
              //     'phone number',
              //     style: TextStyle(fontSize: height*0.017),
              //     textAlign: TextAlign.center,
              //   ),
              // ),


              SizedBox(height: height * 0.02), // 2% of screen height

              Center(
                child: Pinput(
                  length: 6,
                  keyboardType: TextInputType.number,
                  defaultPinTheme: PinTheme(
                    width: width * 0.12, // 12% of screen width
                    height: height * 0.06, // 6% of screen height
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      otp = value;
                      print(otp);
                    });
                  },
                ),              ),

              SizedBox(height: height * 0.01), // 1% of screen height

              Padding(
                padding: EdgeInsets.only(left: width * 0.62), // 65% of screen width
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Resend OTP?',
                    style: TextStyle(fontSize: height*0.016, color: Colors.blue),
                  ),
                ),
              ),

              SizedBox(height: height * 0.02), // 2% of screen height

              Center(
                child: Container(
                  height: height * 0.06, // 6% of screen height
                  width: width * 0.65, // 65% of screen width
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CupertinoColors.systemYellow,
                    ),
                    onPressed: () async{
                      try{
                        PhoneAuthCredential credential = await PhoneAuthProvider.credential(
                            verificationId: widget.otpfromloginpage,
                            smsCode: otp);
                        FirebaseAuth.instance.signInWithCredential(credential).then((value){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return MapScreen();
                          }));
                        });
                      }catch(ex){
                        developer.log(ex.toString());
                      }
                    },
                    child: Text(
                      'Verify Phone Number',
                      style: TextStyle(color: Colors.black, fontSize: height*0.017),
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.10),
              // 15% of screen height
              Center(child: TextButton(
                  onPressed: (){},
                  child: Text('By verifying, you agree to our Terms of Service \n'
                      '                         and Privacy Policy',
                    style: TextStyle(color: Colors.grey,fontSize: height*0.014,fontWeight: FontWeight.w400),)),
              ),

            ],
          ),
        ),


      ),
    );
  }
}
