import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:schoolapp_x/screens/global.dart';
import 'package:schoolapp_x/screens/result_screens/class_result.dart';
import 'package:schoolapp_x/screens/results_data.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  ResultData resultData=ResultData();
  var schoolname_controller=TextEditingController();
  var id_controller=TextEditingController();
  var email_controller=TextEditingController();
  var name_controller=TextEditingController();
  var phone_controller=TextEditingController();
  Future<http.Response> post_details(Map data){
    return http.post(Global.server+'/api/mobile/install',
    headers: {
      'Content-Type':'application/json; charset=UTF-8'
    },
    body: jsonEncode(data)
    );
  }
  final form_key=GlobalKey<FormState>();
  bool suggest=false;
  bool waiting=false;
  Future<Map> suggestions;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
           
            child: Container( 
              padding:EdgeInsets.all(20) ,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.pink[50]
              ),
              child: SafeArea(
                child: Form(
                  key:form_key ,
                  child: ListView(children: <Widget>[
                    SizedBox(height: 30,),
                    Text('Schoolapp',textAlign: TextAlign.center,style: TextStyle(color: Colors.pink,fontSize: 40),),
                    Text('Login(teachers)',textAlign: TextAlign.center,style: TextStyle(color: Colors.pink,fontSize: 20),),
                    SizedBox(height:30),
                    TextFormField(
                      controller: schoolname_controller,
                           onEditingComplete: (){
                             setState(() {
                                 suggest=false;
                               });
                              // submit(search_controller.text);
                               FocusScope.of(context).unfocus();
                           },
                           onChanged: (val){
                               setState(() { 
                                 if(suggest==false){
                                 suggest=true;
                                 }
                                  suggestions=resultData.search_school(val);
                               });
                           },
                      validator: (value){
                        if(value.isEmpty){
                          return 'school name blank';
                        }
                        return null;
                      },
                      decoration:InputDecoration(
                          hintText:'School Name',
                          contentPadding: EdgeInsets.only(left:16),
                          border: OutlineInputBorder(
                            borderRadius:BorderRadius.circular(30),
                            )
                          ),
                    ),
                    SizedBox(height: 40,),

                    TextFormField(
                      controller: id_controller,
                      keyboardType: TextInputType.number,
                      validator: (value){
                        if(value.isEmpty){
                          return 'National id blank';
                        }
                        return null;

                      },
                      decoration: InputDecoration(
                          hintText:'National Id',
                          contentPadding: EdgeInsets.only(left:16),
                          border: OutlineInputBorder(
                            borderRadius:BorderRadius.circular(30),
                            )
                          ),
                    ),

                    SizedBox(height: 40,),
                    TextFormField(
                      controller: email_controller,
                      keyboardType:TextInputType.emailAddress,
                      validator: (value){
                        if(value.isEmpty){
                          return 'email cant be blank';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText:'Email Address',
                          contentPadding: EdgeInsets.only(left:16),
                          border: OutlineInputBorder(
                            borderRadius:BorderRadius.circular(30),
                            )
                          ),
                    ),
                    SizedBox(height: 40,),

                    TextFormField(
                      controller: name_controller,
                      // obscureText: true,
                      validator: (value){
                        if(value.isEmpty){
                          return 'First name can\'t be blank';
                        }
                        return null;

                      },
                      decoration: InputDecoration(
                          hintText:'First Name',
                          contentPadding: EdgeInsets.only(left:16),
                          border: OutlineInputBorder(
                            borderRadius:BorderRadius.circular(30),
                            )
                          ),
                    ),
                    SizedBox(height: 40,),

                    TextFormField(
                      controller:phone_controller ,
                      keyboardType: TextInputType.phone,
                      // obscureText: true,
                      validator: (value){
                        if(value.isEmpty){
                          return 'phone can\'t be blank';
                        }
                        return null;

                      },
                      decoration: InputDecoration(
                          hintText:'Phone',
                          contentPadding: EdgeInsets.only(left:16),
                          border: OutlineInputBorder(
                            borderRadius:BorderRadius.circular(30),
                            )
                          ),
                    ),

                    SizedBox(height:50),
                 waiting? Container(
                  alignment:Alignment.bottomCenter,
                   child: CircularProgressIndicator()):Container(
                    child:  InkWell(
                    onTap: (){
                     
                      if(form_key.currentState.validate()){
                        Map data={
                          'school_name':schoolname_controller.text,
                          'id':id_controller.text,
                          'email':email_controller.text,
                          'name':name_controller.text,
                          'phone':phone_controller.text
                        };
                        setState(() {
                        waiting=true;
                      });
                         var x=post_details(data);
                         x.then((res){
                            setState(() {
                        waiting=false;
                      });
                           if(res.statusCode==200){
                             Map resp=jsonDecode(res.body);
                             if(resp['accepted']==true){
                              
                               write_to_file(res.body).then((value){
                                  resp['path']=value.parent.path;
                                  make_logo(resp['logo'],resp['path']);
                                  resp['logo']='';
                                 Navigator.of(context).pop(); 
                                 Navigator.of(context).pop(); 
                                 Navigator.of(context).pushNamed('/main',arguments:{'all_details':resp,'roaster':{'duty_start':'','roaster':[]}}); 
                               });
                                
                             }
                           }else{
                             showDialog(context: context,builder: (_){
                             return AlertDialog(
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                               title: Text('Wrong Details'),
                               content: Text('We didn\'t find anyone with the submitted details,check your spelling'),
                               actions: <Widget>[
                               FlatButton(child: Text('Cancel'),onPressed: null,),
                               FlatButton(child: Text('Retry'),onPressed: null,),
                             ],);
                           });
                           }
                         }).catchError((err){
                           showDialog(context: context,builder: (_){
                             return AlertDialog(
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                               title: Text('Can\'t connect'),
                               content: Text('We can\'t connect to the server at the moment,try again later'),
                               actions: <Widget>[
                               FlatButton(child: Text('Cancel'),onPressed: null,),
                               FlatButton(child: Text('Retry'),onPressed: null,),
                             ],);
                           });
                         });

                      }
                      
                      },
                    child:Container(
                      margin: EdgeInsets.symmetric(horizontal:50),
                      padding: EdgeInsets.symmetric(horizontal:20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color:Colors.pink,width:2,style:BorderStyle.solid)
                      
                      ),
                      height: 40.0,
                      child: Center(
                      child:Text('Login',style: TextStyle(color: Colors.pink,fontSize: 20),),
                      )
                    )
                  ),
                  )
                  ],),
                ),
              ),
            ),),
                   suggest?
       Card(
         margin: EdgeInsets.only(top:220,left:20,right:20),
         shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)) ,
         child: Container(
           width:MediaQuery.of(context).size.width,
           padding: EdgeInsets.symmetric(horizontal: 20),
           height: 500,
           decoration: BoxDecoration(
             color: Colors.blue[50],
               borderRadius: BorderRadius.circular(10)
           ),
           child:FutureBuilder(builder: (context,snapshot){
             if(snapshot.hasData){
               if(snapshot.data['results'].length==0){
                 return ListTile(leading: Icon(FontAwesome.frown_o),title:  Text('No Match'),);
               }else{
                 return ListView(
                    shrinkWrap: true,
                    children:get_schools_list(snapshot.data['results']),
                  );
               }
             }else if(snapshot.hasError){
               return NoNet(onReload: (){
                 setState(() {
                   suggest=false;
                 });
               });
             }
             return NoDataLoad();
           },future:suggestions)
         ),
       ):Container()
        ],
      )
    );
  }

  Future<File> write_to_file(data) async{
    var directory =await getApplicationDocumentsDirectory();
    var localpath=directory.path;
    var file= File('$localpath/initial.json');
    var fl=await file.writeAsString(data);
    return fl;
  }

  List<Widget> get_schools_list(List data){
  List<Widget> the_list=[];
  for(int i=0;i<data.length;i++){
    the_list.add(
      Container(
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          splashColor: Colors.pink,
          onTap: (){
            schoolname_controller.text=data[i];
            FocusScope.of(context).unfocus();
            setState(() {
              suggest=false;
            });
            //submit(data[i]);
          },
          child: ListTile(title: Text(data[i]),trailing: Icon(Icons.navigate_next),leading: Icon(Feather.tag),))
    )
    );
  }
  return the_list;
}
void make_logo(resp,path) {
  File logo=File(path+'/logo.png');
  logo.writeAsBytesSync(List<int>.from(resp['data']));
  
}

}

