import 'package:flutter/material.dart';
import 'package:schoolapp_x/screens/mainscreen/home.dart';
import 'package:schoolapp_x/screens/mainscreen/results.dart';
import 'package:schoolapp_x/screens/mainscreen/timetabling.dart';
import 'package:schoolapp_x/screens/upload_screen/upload_screen.dart';

import '../updates.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key,@required this.all_details,@required this.roaster}) : super(key: key);
  final Map all_details;
  final Map roaster;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _curr_index=1;
  bool add_reminder=false;
  openr(){
  
    setState(() {
      add_reminder=true;
    });
  }
 List <Widget> screens;
  void initState(){
    Updates check=Updates(all_details: widget.all_details);
    check.any_updates();
     screens=[
    Timetabling(openReminder:openr,all_details:widget.all_details),
    Home(all_details:widget.all_details,roaster: widget.roaster,),
    Results(all_details: widget.all_details,)
  ]; 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: <Widget>[
          screens[_curr_index],
            add_reminder?
    Container(
      color: Colors.transparent,
      child: ListView(
        children:[
        GestureDetector(
          onTap:(){
            setState(() {
              add_reminder=false;
            });
          } ,
            child: Container(
               height:MediaQuery.of(context).size.height*0.6,
               color: Colors.transparent,
            ),
          ),
          Container(
             height:MediaQuery.of(context).size.height*0.4,
             decoration: BoxDecoration(
               color: Colors.pink[300],
               boxShadow: [BoxShadow(color: Colors.pink,blurRadius: 4)],
               borderRadius: BorderRadius.only(topLeft:Radius.circular(30),topRight:Radius.circular(30))
             ),
             child: SingleChildScrollView(
               child: Column(
                 children:[
                   SizedBox(height: 5,),
                   Text('Add Reminder',style: TextStyle(fontSize: 30,color: Colors.white)),
                   Text('9:35'+'-'+'10:15',style: TextStyle(fontSize: 20,color: Colors.pink[100])),
                    Text('Monday'+' '+'3/8/2020',style: TextStyle(fontSize: 20,color: Colors.pink[100])),
                   SizedBox(height: 5,),
                   Container(
                       height:70,
                     decoration: BoxDecoration(
                       color: Colors.pink[100],
                       borderRadius: BorderRadius.circular(20),
                     ),
                     margin: EdgeInsets.symmetric(horizontal:30),
                     child: TextFormField(
                       keyboardType: TextInputType.multiline,
                       maxLines: 3,
                       decoration: InputDecoration(
                         contentPadding: EdgeInsets.all(10),
                         hintText: 'Your reminder',
                         border: InputBorder.none,
                         

                       ),
                     ),
                     ),
                     SizedBox(height:20),
                     Builder(builder: (context)=>
                     Kabtn(text: 'Add', action: (){
                       setState(() {
                         add_reminder=false;
                       });
                       Scaffold.of(context).showSnackBar(SnackBar(content: Text('added'),
                       shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))));
                     }, active: true,color: Color(0xff715bd0),width: 200,)
                     ),
                 ]
               ),
             ),
          )
        ]
      ),
      // floatingActionButton: FloatingActionButton(
      //   heroTag: 'rem',
      //   child: Icon(Icons.close),
      //   onPressed:(){
      //       setState(() {
      //         add_reminder=false;
      //       });
      //     } ,
      //   ),
    ):Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.file_upload),onPressed: ()=>Navigator.of(context).pushNamed('/upload',arguments: {'all_details':widget.all_details}),),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
     bottomNavigationBar:BottomNavigationBar(
       type: BottomNavigationBarType.shifting,
       currentIndex: _curr_index,
       selectedItemColor: Colors.pink,
       unselectedItemColor: Color.fromRGBO(46, 37,80 ,1),
       selectedIconTheme: IconThemeData(size:30),
       onTap: (index){
         setState(() {
           _curr_index=index;
           
         });
       },
       items:[
     
         BottomNavigationBarItem(
         icon:Icon(Icons.calendar_today ),
         title: Text('Timetable')
         ),
           BottomNavigationBarItem(
         icon:Icon(Icons.pages ),
         title: Text('Home')
         ),
          BottomNavigationBarItem(
         icon:Icon(Icons.pie_chart ),
         title: Text('Results')
         ),
        
     ]),
    );
  }
}