import 'package:auto_search/data_handler/app_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {


  @override



  TextEditingController pickUpTextController = TextEditingController();
  TextEditingController DropOffTextController = TextEditingController();




  Widget build(BuildContext context) {



    //add the provider , ro retrive address
    String placeAddress = Provider.of<AppData>(context).pickUpLocation?.placeName ?? "";
    pickUpTextController.text = placeAddress;






    return Scaffold(

      appBar: AppBar(

        backgroundColor: Color(0xffFFF4C9),
        title: Text("Search Drop Off" , style: TextStyle(fontWeight: FontWeight.w400),),
        centerTitle: true,

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
        
        
        child: Column(
          children: [

            SizedBox(height: 35,),

         Container(
           width: 350,
           child: Row(
             children: [
               Icon(Icons.drive_eta_rounded),

               SizedBox(width: 20,),

               Expanded(
                 child: SizedBox(
                   //width: 250,
                     child: TextField(

                       controller: pickUpTextController,

                       decoration: InputDecoration(
                         hintText: "Pick Up Location",

                         fillColor: CupertinoColors.systemYellow.withOpacity(0.65),
                         filled: true,


                         border: OutlineInputBorder(

                           borderSide: BorderSide(
                             color: CupertinoColors.systemYellow,
                           ),
                           borderRadius: BorderRadius.circular(11),
                         )
                       ),
                     )
                 
                 
                 ),
               ),

             ],
           ),
         ),




            SizedBox(height: 20,),




            Container(
              width: 350,
              child: Row(
                children: [
                  Icon(Icons.drive_eta_rounded),

                  SizedBox(width: 20,),

                  Expanded(
                    child: SizedBox(
                      //width: 250,
                        child: TextField(

                          controller: DropOffTextController,



                          decoration: InputDecoration(

                              hintText: "Drop Off Location",

                              fillColor: CupertinoColors.systemYellow.withOpacity(0.65),
                              filled: true,

                              disabledBorder: OutlineInputBorder(


                                borderSide: BorderSide(
                                  color: CupertinoColors.systemYellow,
                                ),
                                borderRadius: BorderRadius.circular(30),

                              ),


                              // border: OutlineInputBorder(
                              //
                              //   borderSide: BorderSide(
                              //     color: CupertinoColors.systemYellow,
                              //   ),
                              //   borderRadius: BorderRadius.circular(11),
                              // )
                          ),
                        )


                    ),
                  ),

                ],
              ),
            )


          ],
        ),

      ),


    );
  }
}
