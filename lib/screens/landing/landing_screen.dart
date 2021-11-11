import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffffe6e8),Color(0xfff75353)],
            transform: GradientRotation(1.5)
          )
        ),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[

          Container(
            // margin: EdgeInsets.only(top:100),
            padding: EdgeInsets.symmetric(horizontal:20,),
            // height:200,
            child:SafeArea(
              child: Column(children: <Widget>[
                Container(
                  width:90,
                  child:Image.asset('assets/images/my_logo.png',
                  fit: BoxFit.cover,)
                ),SizedBox(height:10),
                Text('Welcome to',style: TextStyle(fontSize: 25,color: Colors.black54),),
                Text('Schoolapp',style: TextStyle(fontSize: 55,color: Colors.pink),),
                SizedBox(height: 10,),
                Text('A super organized and easier way to manage and access your school\'s environment on your mobile device',
                style: TextStyle(color: Colors.black45,fontWeight: FontWeight.w600,fontSize: 17),textAlign: TextAlign.center,)
              ],),
            )
          ),
          SizedBox(height:20),
          Container(
            height: 350,
            child:Image.asset('assets/images/lab.png',
            fit: BoxFit.cover,),
          ),
          SizedBox(height:30),
          Container(
            margin: EdgeInsets.symmetric(horizontal:30),
            child:  InkWell(
            onTap: (){Navigator.of(context).pushNamed('/login');},
            child:Container(
              padding: EdgeInsets.symmetric(horizontal:20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color:Colors.white,width:2,style:BorderStyle.solid)
              
              ),
              width: 300,
              height: 40.0,
              child: Center(
              child:Text('Login teachers',style: TextStyle(color: Colors.white,fontSize: 20),),
              )
            )
          ),
          ),
          SizedBox(height:30),
           Container(
            margin: EdgeInsets.symmetric(horizontal:30),
            child:  InkWell(
            onTap: (){
              showDialog(context: context,builder: (_){
                       return AlertDialog(
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                         title: Text('Coming soon'),
                         content: Text('The student feature is in development. We will notify you when its completed'),
                         actions: <Widget>[
                         FlatButton(child: Text('Cancel'),onPressed: null,),
                         FlatButton(child: Text('ok'),onPressed: null,),
                       ],);
                     });
            },
            child:Container(
              padding: EdgeInsets.symmetric(horizontal:20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white
              ),
              width: 300,
              height: 40.0,
              child: Center(
              child:Text('Student/parent',style: TextStyle(color: Color(0xfff75353),fontSize: 20),),
              )
            )
          ),
          )
        ],),
      )
    );
  }
}