import 'package:auto_search/OTP_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // Get the screen size and use it for responsive design
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    TextEditingController phoneController = TextEditingController();
    String completePhoneNumber = '';

    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffFFF4C9),
                Color(0xffFFFFE0).withOpacity(0.6),
              ],
              begin: FractionalOffset(0.5, 0.0),
              end: FractionalOffset(0.5, 1.0),
              stops: [0.4, 1.0],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(height: screenHeight*0.035,),

                Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: screenHeight*0.018,
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          color: CupertinoColors.systemYellow,
                          height: 7,
                        ),
                      ),
                    ),
                    Container(
                      //color: Colors.red,
                      height: screenHeight * 0.20, // Adjusted height to be responsive
                      width: screenWidth,
                      child: Image.asset('assets/images/auto.png'),
                    ),
                  ],
                ), // Auto Image

                //SizedBox(height: screenHeight * 0.02), // Adjusted margin

                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                      child: Text(
                        "Let's get started",
                        style: TextStyle(fontSize: screenHeight*0.0363, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ), // Let's get started

                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                      child: Text(
                        "Get there with a rickshaw flair!",
                        style: TextStyle(fontSize: screenHeight*0.017,),
                      ),
                    ),
                  ],
                ), // Get there with rickshaw flair

                SizedBox(height: screenHeight * 0.05), // Adjusted margin

                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                      child: Text(
                        "Continue with Phone Number",
                        style: TextStyle(fontSize: screenHeight*0.0195, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ), // Continue with phone no.

                SizedBox(height: screenHeight * 0.01), // Adjusted margin

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: IntlPhoneField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(),
                      ),
                    ),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      print(phone.completeNumber);
                      completePhoneNumber = phone.completeNumber;
                    },
                  ),
                ), // Phone textfield - Intl

                SizedBox(height: screenHeight * 0.01), // Adjusted margin

                Container(
                  width: screenWidth * 0.6, // Responsive width
                  height: screenHeight * 0.07, // Responsive height
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CupertinoColors.systemYellow,
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return OTPpage();
                      }));
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: screenHeight*0.018, color: Colors.black),
                    ),
                  ),
                ), // Continue Elevated Button

                SizedBox(height: screenHeight * 0.02), // Adjusted margin

                Container(
                  width: screenWidth * 0.75, // Responsive width
                  height: screenHeight * 0.05, // Responsive height
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: screenHeight*0.001,
                        width: screenWidth * 0.25, // Responsive width
                        color: Colors.grey,
                      ),
                      Text(
                        '   Or   ',
                        style: TextStyle(color: Colors.grey, fontSize: screenHeight*0.018),
                      ),
                      Container(
                        height: 1,
                        width: screenWidth * 0.25, // Responsive width
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ), // Or with lines

                SizedBox(height: screenHeight * 0.02), // Adjusted margin

                Container(
                  width: screenWidth * 0.82, // Responsive width
                  height: screenHeight * 0.07, // Responsive height
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        width: 0.6,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                          child: Image.asset('assets/images/google_logo.png'),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Text(
                          'Continue with Google',
                          style: TextStyle(fontSize: screenHeight*0.018),
                        ),
                      ],
                    ),
                  ),
                ), // Continue with Google

                SizedBox(height: screenHeight * 0.02), // Adjusted margin

                Container(
                  width: screenWidth * 0.82, // Responsive width
                  height: screenHeight * 0.07, // Responsive height
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      side: BorderSide(
                        width: 0.6,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                          child: Container(
                            height: screenWidth * 0.1,
                            width: screenWidth * 0.1,
                            child: Image.asset('assets/images/apple-emblem 1.png'),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Text(
                          'Continue with Apple',
                          style: TextStyle(fontSize: screenHeight*0.018, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ), // Continue with Apple

                SizedBox(height: screenHeight * 0.05), // Adjusted margin

                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'By verifying, you agree to our Terms of Service \n'
                          '                         and Privacy Policy',
                      style: TextStyle(color: Colors.grey,fontSize: screenHeight*0.014, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
                // Terms and conditions
              ],
            ),
          ),
        ),
      ),
    );
  }
}