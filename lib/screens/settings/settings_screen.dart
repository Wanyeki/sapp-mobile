

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:schoolapp_x/screens/mainscreen/results.dart';
import 'package:schoolapp_x/screens/settings_controller.dart';
import 'package:schoolapp_x/screens/teaching_tt.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  Settings({
    Key key,
    @required this.all_details,
    @required this.image,
    @required this.home_image
  });
  final all_details;
  final File image;
  final home_image;
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  File _image;
  bool allow_notifications;
  SettingsController settings_controller;
  @override
  void initState() { 
    super.initState();
    allow_notifications=widget.all_details['allow_notifications'];
    // print(widget.all_details);
    _image=widget.image;
    settings_controller= SettingsController(all_details:widget.all_details);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:CustomScrollView(
        slivers:[
          SliverAppBar(
            // backgroundColor: Colors.pink[100],
            actions: <Widget>[
            

            ],
            shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(30)),
            
            flexibleSpace:Hero(
              tag: 'me',
              child: Container(

                child:Image.file(_image,
                fit:BoxFit.cover,
                errorBuilder: (a,b,c){
                  return Center(
                   child: Text('No image',style:TextStyle(color: Colors.white))
                  );
                },
                )
              ),
            ),
            expandedHeight: MediaQuery.of(context).size.width*0.92,
          ),

         SliverList(
           delegate:SliverChildListDelegate([
              SizedBox(height:20),
                      Text(widget.all_details['teacher_title'],style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
                      MyTile(title: 'Edit Photo',icon: Icon(Icons.add_a_photo,color: Colors.white,), onPressed:(){
                        showDialog(context: context,builder: (_){
                         return AlertDialog(
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                           title: Text('Select source'),
                           content: Container(
                             height: 120,
                             child: Column(
                               children:[
                                 InkWell(child: ListTile(leading: Icon(FontAwesome.picture_o),title: Text('Pick from gallery'),),
                                 onTap:(){
                                   Future<File> img=settings_controller.get_image(false);
                                   img.then((imoge){
                                     Navigator.of(context).pop();
                                     setState(() {
                                       _image=imoge;
                                       
                                     });
                                        widget.home_image(imoge);
                                   }).catchError((e){
                                    //  Navigator.of(context).pop();
                                      showDialog(context: context,builder:(_){
                                        return AlertDialog(
                                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          title: Text('No internet'),
                                          content: Text('The image could not be uploaded'),
                                          actions: <Widget>[
                                            FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text('ok'))
                                          ],
                                          );
                                      });
                                   });
                                 },
                                 splashColor: Colors.pink[100],),
                                 InkWell(child: ListTile(leading: Icon(Icons.camera),title: Text('Pick from camera'),),
                                 onTap:(){
                                   Future<File> img= settings_controller.get_image(true);
                                   img.then((image){
                                     Navigator.of(context).pop();
                                     setState(() {
                                       _image=image;
                                     });
                                  widget.home_image(image);

                                            
                                   }).catchError((e){
                                    //  Navigator.of(context).pop();
                                      showDialog(context: context,builder:(_){
                                        return AlertDialog(
                                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          title: Text('No internet'),
                                          content: Text('The image could not be uploaded'),
                                          actions: <Widget>[
                                            FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text('ok'))
                                          ],
                                          );
                                      });
                                   });
                                 },
                                 splashColor: Colors.pink[100],),
                               ]
                             ),
                           ),
                           
                          );
                       });
                        },color: Color(0xffff96bf),),
                      MyTile(title: 'Invite schools',icon: Icon(FontAwesome.share,color: Colors.white,), onPressed:(){
                        FlutterShare.share(title: 'Schoolapp',text: 'Check out the new Highschool management software',linkUrl: 'https://wanyeki.github.io/schoolapp');
                        },color: Color(0xff64caff),),
                      MyTile(title: 'Sign Out',icon: Icon(FontAwesome.sign_out,color: Colors.white,), onPressed:(){
                        showDialog(context:context,builder:(con)=>LogoutAlert(settings_controller: settings_controller)
                        );
                      },color: Color(0xffffb42e),),
                      // MyTile(title: 'Other schools',icon: Icon(Icons.home,color: Colors.white,), onPressed:(){Navigator.of(context).pushNamed('others_p');},color: Color(0xff33e350),),
                     
            MyTile(title: 'Allow notifications',icon: Icon(Icons.message,color: Colors.white,), onPressed:change_notifications,color: Color(0xffffb42e),toggle: true,toggle_state: allow_notifications,),
             MyTile(title: 'About Schoolapp',icon: Icon(Icons.info,color: Colors.white,), onPressed:(){
                        showAboutDialog(
                          context:context,
                         applicationIcon: Image.asset('assets/images/my_logo.png',height: 80,),
                          applicationVersion: '1.0.0',
                          children: [
                            SizedBox(height:10),
                            InkWell(child: Text('view more'),onTap: (){
                              Uri lnk=Uri(
                                scheme: 'http',
                                path: 'wanyeki.github.io/schoolapp',
                              );
                               launch(lnk.toString());

                            },)
                          ]
                          
                          );
                      },color: Color(0xffeb90ff),),
            SizedBox(height:300)
           ])
           ),
        ]
      )

      );
  }
  void change_notifications(){
    setState(() {
    allow_notifications=!allow_notifications;
      
    });
    var tt=Teaching_tt(all_details: widget.all_details);
    if(!allow_notifications){
      tt.clear_alarm();
    }else{
      tt.set_alarm(widget.all_details['teacher_name'], null);
    }
    Map data1=widget.all_details;
    data1['allow_notifications']=allow_notifications;
    String data=jsonEncode(data1);

    settings_controller.write_to_file(data, 'initial.json');
  }
}

class LogoutAlert extends StatefulWidget {
  const LogoutAlert({
    Key key,
    @required this.settings_controller,
  }) : super(key: key);

  final SettingsController settings_controller;

  @override
  _LogoutAlertState createState() => _LogoutAlertState();
}

class _LogoutAlertState extends State<LogoutAlert> {
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:loading?Text('Please wait'):Text('Sign Out'),
      content:loading?LinearProgressIndicator(): Text('Are you sure you want to sign out?'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actions: <Widget>[
       loading?Container(): FlatButton(onPressed:(){
          Navigator.of(context).pop();
        } ,child: Text('No'),),
       loading?Container():  FlatButton(onPressed:(){
         setState(() {
           loading=true;
         });
          widget.settings_controller.sign_out().then((value){
            if(value){
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/');
            }
          }).catchError((e)=>setState((){loading=false;}));

        } ,child: Text('Yes'),),
      ],

    );
  }
}