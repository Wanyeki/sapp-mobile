import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:schoolapp_x/screens/result_screens/class_result.dart';
import 'package:schoolapp_x/screens/results_data.dart';
import 'package:schoolapp_x/screens/uploader.dart';

class UploadScreen extends StatefulWidget {
  UploadScreen({Key key,@required this.all_details}) : super(key: key);
  final all_details;
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

ResultData rd;
Uploader ud;
String selected_exam;
String selected_form;
String selected_class;
String selected_subject;
String selected_paper;
Map all_files;
@override
void initState() { 
  ud=Uploader(all_details: widget.all_details);
  rd=ResultData(all_details: widget.all_details);
  super.initState();
  rd.load_items().then((val){
    ud.get_all().then((Map files){
    setState((){
      streams=rd.classes['classes'];
      selected_class=streams[0]['name'];
  
      subjects=widget.all_details['subjects'];
      selected_subject=subjects[0]['name'];

      exams=rd.exams['exams'];
      selected_exam=exams[0]['exam']+' '+exams[0]['term'];

      selected_form='form-1';
      selected_paper='paper1';

      uploads=files['files'];
      all_files=files;
    });
    }).catchError((e){
      ud.create_main_file('zener');
      setState((){
      streams=rd.classes['classes'];
      selected_class=streams[0]['name'];
  
      subjects=widget.all_details['subjects'];
      selected_subject=subjects[0]['name'];

      exams=rd.exams['exams'];
      selected_exam=exams[0]['exam']+' '+exams[0]['term'];

      selected_form='form-1';
      selected_paper='paper1';

      uploads=[];
    });
    });
  });


  
}

void update_files(){
  ud.get_all().then((Map files){
    setState(() {
      uploads=files['files'];
      all_files=files;
    });
  });
}

Future createfile() async{
  Map item = await ud.create(selected_subject, selected_form, selected_class, selected_paper, selected_exam);
  setState(() {
    add_result=false;
    uploads.add(item);
  });
  return true;


}

bool selectors_filled(){
  return selected_exam!=null &&
  selected_form!=null &&
  selected_class!=null &&
  selected_subject!=null &&
  selected_paper!=null;
}
    List streams=[];
    List subjects=[];
    List exams=[];
    bool add_result=false;
    List uploads= [];
 
 List<DropdownMenuItem> get_papers(){
   return [
     DropdownMenuItem(child: Text('paper1'),value: 'paper1',),
     DropdownMenuItem(child: Text('paper2'),value: 'paper2',),
     DropdownMenuItem(child: Text('writing'),value: 'writing',),
     DropdownMenuItem(child: Text('practical'),value: 'practical',)
   ];
 }
  List<DropdownMenuItem> get_forms(){
    List<DropdownMenuItem> forms=[];
    for(int i=1;i<5;i++){
      forms.add(
        DropdownMenuItem(child: Text('form-'+i.toString()),value:'form-'+i.toString())
      );
    }
    return forms;
  }
 List<DropdownMenuItem> get_subjects(){
  
    List<DropdownMenuItem> stms=[];
    for(int i=0;i<subjects.length;i++){
      stms.add(
        DropdownMenuItem(child: Text(subjects[i]['name']),value:subjects[i]['name'])
      );
    }
    return stms;
  }
   List<DropdownMenuItem> get_streams(){
  
    List<DropdownMenuItem> stms=[];
    for(int i=0;i<streams.length;i++){
      stms.add(
        DropdownMenuItem(child: Text(streams[i]['name']),value:streams[i]['name'])
      );
    }
    return stms;
  }

   List<DropdownMenuItem> get_terms(){
  
    List<DropdownMenuItem> tms=[];
    for(int i=0;i<exams.length;i++){
      tms.add(
        DropdownMenuItem(child: Text(exams[i]['exam']+' '+exams[i]['term']),value:exams[i]['exam']+' '+exams[i]['term'])
      );
    }
    return tms;
  }

  

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          
          body:CustomScrollView(

            slivers:[
              SliverAppBar(
                floating: true,
                snap: true,
                actions: <Widget>[IconButton(icon: Icon(Icons.share), onPressed: null)],
                backgroundColor: Colors.pink[50],
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                flexibleSpace: Flex(
                  direction:Axis.vertical,          
                  children: <Widget>[
                    Flexible(
                      
                           child: Hero(
                             tag:'logo',
                             child: Image.file(File(widget.all_details['path']+'/logo.png'),
                             // fit: BoxFit.cover,
                             errorBuilder: (a,b,c)=>Image.asset('assets/images/my_logo.png'),
                            
                             ),
                           ),

                         ),
                          Text('Upload Results',style:TextStyle(fontSize:30,color: Color.fromRGBO(46, 37,80 ,1)))

                  ],
                ),
                expandedHeight: 200,
                
              ),
              SliverList(
                delegate: uploads.length>0? SliverChildBuilderDelegate(
                  
                  (context,i){
                    return Container(
                      color:get_color(uploads[i]['status']),
                      child: InkWell(
                        splashColor: Colors.pink[100],
                        onTap: ()=>Navigator.of(context).pushNamed('/edit_upload',arguments:
                        {"title":uploads[i]['subject']+' '+uploads[i]['form']+' '+uploads[i]['class']+' '+uploads[i]['paper'],
                         "subtitle":uploads[i]['exam'],
                         "update_all_files":update_files,
                         "all_details":widget.all_details}
                        ),
                        child:ListTile(
                          leading:Image.asset('assets/images/icon.png'),
                          title:Text(uploads[i]['subject']+' '+uploads[i]['form']+' '+uploads[i]['class']+' '+uploads[i]['paper']) ,
                          subtitle: Text(uploads[i]['exam']),
                          trailing:Column(
                            children: <Widget>[
                              // Text(uploads[i]['status']), 
                              Builder(
                                builder: (context) {
                                  return PopupMenuButton(itemBuilder: (context){
                                    return[
                                      PopupMenuItem(
                                        child: Container(
                                          color:get_color2(uploads[i]['status']),
                                          padding: EdgeInsets.symmetric(horizontal:10,vertical:5) ,
                                          child: Text(uploads[i]['status'],style: TextStyle(color: Colors.white),)),
                                          value: 1,),
                                      PopupMenuItem(child: Text('Delete'),value: 2,),
                                      PopupMenuItem(child: Text(uploads[i]['status']=='Local'?'Submit':'Resubmit'),value: 3,)
                                    ];
                                  },
                                  onSelected: (val){
                                  String filename=uploads[i]['subject']+' '+uploads[i]['form']+' '+uploads[i]['class']+' '+uploads[i]['paper']+' '+uploads[i]['exam']+'.json';

                                    if(val==2){
                                        setState(() {
                                          uploads.removeAt(i);
                                        });
                                        ud.delete_file(filename, uploads);
                                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Deleted'),));
                                    }else if(val==3){
                                     var done=ud.submit(filename, {'teacher':'francis','files':uploads});
                                     done.then((value){
                                       setState(() {
                                         uploads=value['files'];
                                       });
                                       Scaffold.of(context).showSnackBar(SnackBar(content: Text('Sent to your school'),));

                                        });
                                    
                                    }
                                    
                                  },
                                  );
                                }
                              )
                            ],
                          ) ,
                        ) ,),
                    );
                  },
                  childCount: uploads.length
                ):
                SliverChildListDelegate([   
                      SizedBox(height: 100,),   
                      Icon(FontAwesome.frown_o),
                      Text('No files yet\nTry creating one.',textAlign: TextAlign.center,)
                ])

              )
            ]
          ),
          floatingActionButton: FloatingActionButton(onPressed: (){
            setState(() {
              add_result=true;
            });
            Navigator.of(context).pushNamed('/upload/add');
          }, child: Icon(Icons.add),),
        ),
        add_result?
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              GestureDetector(
              onTap:(){
                setState(() {
                  add_result=false;
                });
              } ,
                child: Container(
                   height:MediaQuery.of(context).size.height*0.5,
                   color: Colors.transparent,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                height:MediaQuery.of(context).size.height*0.5,
                decoration: BoxDecoration(
                  boxShadow:[BoxShadow(color:Colors.black26,blurRadius: 20)],
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(40),topRight: Radius.circular(40)),
                  color:Colors.pink[300],
                  
                ),
                child: ListView(
                  children: <Widget>[
                    Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                      Text('Create a List',style: TextStyle(color: Colors.white,fontSize: 30),textAlign:TextAlign.center,),
                      SizedBox(height:20),
                      MyDrop(on_changed: (val){setState(() { selected_exam=val; });},val: selected_exam ,data:get_terms,hint: 'Select Exam',icon: Icons.grade,color: Color(0xffff96bf)),
                      SizedBox(height:20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          MyDrop(on_changed: (val){setState(() { selected_form=val; });},val: selected_form ,data:get_forms,hint: 'Select Form',icon: Icons.people,color:Color(0xffff96bf)),
                          MyDrop(on_changed: (val){setState(() { selected_subject=val; });},val: selected_subject ,data:get_subjects,hint: 'Select Subject',icon: Icons.bookmark_border,color: Color(0xffff96bf)),

                        ],
                      ),
                      SizedBox(height:20),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          MyDrop(on_changed: (val){setState(() { selected_class=val; });},val: selected_class ,data:get_streams,hint: 'Select class',icon: Icons.class_,color: Color(0xffff96bf)),
                          MyDrop(on_changed: (val){setState(() { selected_paper=val; });},val: selected_paper ,data:get_papers,hint: 'Select paper',icon: Icons.class_,color: Color(0xffff96bf))

                        ],
                      ),
                      SizedBox(height:40),
                       Builder(
                         builder: (context) {
                           return Kabtn(color:Color(0xff715bd0),text: 'Add',active: selectors_filled(),action: (){createfile().catchError((e){
                             Scaffold.of(context).showSnackBar(SnackBar(content: Text('File exists'),));
                           });},);
                         }
                       )

                    ],),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'hello',
            onPressed:(){
              setState(() {
                add_result=false;
              });
            } ,child: Icon(Icons.close),),
        )
        :Container()
      ],
    );
  }

  Color get_color(String status){
    switch(status){
      case 'Submitted':
      return Color(0xffdaf9f5);
      break;
      case 'Rejected':
      return Color(0xffffe5e7);
      break;
      default:
      return Color(0xffffffff);
      // break;
    }

  }
   Color get_color2(String status){
    switch(status){
      case 'Submitted':
      return Color(0xff5bd2d0);
      break;
      case 'Rejected':
      return Color(0xffec848d);
      break;
      default:
      return Color(0xff5e64f5);
      // break;
    }

  }

}

class Kabtn extends StatelessWidget {
  const Kabtn({
    Key key,
    @required this.text,
    this.color,
    this.width,
    @ required this.action,
   @required this.active
  }) : super(key: key);

final String text;
final Color color;
final double width;
final bool active;
final action;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        active?action():false;
      },
      child: Container(
           width: width!=null?width:300,
           padding: EdgeInsets.symmetric(horizontal:20),
           decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(30),
           color: active?color:Colors.black12,
           
           ),
           height: 40.0,
           child: Center(
              child:Text(text,style: TextStyle(color:Colors.white ,fontSize: 20),),
             )
          ),
    );
  }
}