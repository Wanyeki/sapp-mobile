import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schoolapp_x/routing.dart';


void main() => runApp(Schoolapp());

class Schoolapp extends StatefulWidget {
  Schoolapp({Key key}) : super(key: key);

  @override
  _SchoolappState createState() => _SchoolappState();
}

class _SchoolappState extends State<Schoolapp> {
  @override
    Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schoolapp',
      initialRoute:'/',
      onGenerateRoute: RouteGenerator.generateRoutes,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily:'Montserrat'
      ),
    
    );
  }
}

class Bait extends StatefulWidget {
  @override
  _BaitState createState() => _BaitState();
}

class _BaitState extends State<Bait> {
  
  void navigate_to(Map all_details){
    bool active=all_details['accepted'];
    active=active==null?false:true;
    if(active){
      read_file('roaster.json').then((roaster){
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('/main',arguments: {'all_details':all_details,'roaster':roaster});
      }).catchError((e){
         Navigator.of(context).pop();
         Navigator.of(context).pushNamed('/landing');
      });
      
    }else{
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('/landing');
    }
  }
  void initState(){
    super.initState();
    Future<Directory> di=getApplicationDocumentsDirectory();
    
     di.then((value) { 
       Future<Map> fl=read_file('initial.json');
       fl.then((all_details){
         navigate_to(all_details);
       }).catchError((e){
         Navigator.of(context).pop();
         Navigator.of(context).pushNamed('/landing');
       });

       });
     
  }
  Future<Map> read_file(filename) async{
   Directory dir= await getApplicationDocumentsDirectory();
     String directory=dir.path;
     File file=File(directory+'/'+filename);
     String contents=await file.readAsString();
     Map data=jsonDecode(contents);
     data['path']=directory;
     return data;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child: CircularProgressIndicator(),)
    );
  }
}