

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:schoolapp_x/screens/result_screens/class_result.dart';
import 'package:schoolapp_x/screens/upload_screen/upload_screen.dart';
import 'package:schoolapp_x/screens/uploader.dart';


class EditUpload extends StatefulWidget {
  
  const EditUpload(
    {
    Key key,
    @required this.all_details,
    @required this.update_all_files,
    @required this.title,
    @required this.subtitle
    }) :super(key:key);

  final subtitle;
  final all_details;
  final title;
  final update_all_files;
  @override
  _EditUploadState createState() => _EditUploadState();
}

class _EditUploadState extends State<EditUpload> {
  var outof_controller=TextEditingController();
  var score_controller=TextEditingController();
  var adm_controller=TextEditingController();
  var edit_mode=false;
  Map selected={};
  

  bool all_done=false;
   bool all_filled(){
   bool x=
     adm_controller.text !=''&&
     score_controller.text !=''&&
     outof_controller.text !='';
     return x!=all_done;
     
  }
 Uploader ud;
 Future<Map> entries;
 Map fill_data;
 @override
 void initState() { 
   super.initState();
   ud=Uploader(all_details: widget.all_details);
   entries=ud.read_file(widget.title+' '+widget.subtitle+'.json');
   
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*0.9,
              padding: EdgeInsets.all(10),
              child:ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                        padding: EdgeInsets.fromLTRB(0,20,25,0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:[
                                 edit_mode?
                                Text('Select entries to delete',style:TextStyle(fontSize: 20,color: Colors.pink)):
                                Text(widget.title,style: TextStyle(fontSize: 20,color: Color.fromRGBO(46, 37,80 ,1))),
                                Text(widget.subtitle,style: TextStyle(fontSize: 15,color: Color.fromRGBO(162, 175, 189,1)),)
                              ]
                            ),
                            edit_mode?
                            IconButton(icon: Icon(FontAwesome.close, color:Colors.pink,size: 30,), onPressed:(){
                              setState(() {
                                edit_mode=false;
                                selected={};
                              });
                            } ):
                            Builder(builder: (context)=>IconButton(icon: Icon(FontAwesome.upload, color: Color(0xff5bd2d0),size: 30,), onPressed:(){
                              showDialog(context: context,builder: (_){
                              return MyAlert(ud: ud, widget: widget,ctx:context,update_all_files: widget.update_all_files,);
                             });
                            }),),
                            edit_mode?
                            Builder(
                              builder: (context) {
                                return IconButton(icon: Icon(FontAwesome.check, color: Color(0xff5bd2d0),size: 30,), onPressed: (){
                                  delete_items();
                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('deleted'),));
                                });
                              }
                            ):
                            IconButton(icon: Icon(Icons.delete,color: Color(0xff5bd2d0),size: 30,), onPressed: (){
                              setState(() {
                                edit_mode=true;
                              });
                            }),
                            
                          ],
                          ),
                      ),
                      SingleChildScrollView(
                        child: FutureBuilder(
                          future: entries,
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              fill_data=snapshot.data;
                            return DataTable(
                              sortColumnIndex: 0,
                              columns:[
                                DataColumn(label: Text('ADM',style: TextStyle(color: Colors.pink),)),
                                DataColumn(label: Text('Score',style: TextStyle(color: Colors.pink),)),
                                DataColumn(label: Text('Max',style: TextStyle(color: Colors.pink),)),
                              ] ,
                              rows:get_rows(snapshot.data['entries']) ,);
                            }
                            return NoDataLoad();
                          }
                        ),
                      )
                      
                ],
              )
            ),
            Container(
              // margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.Center9),
              decoration: BoxDecoration(
                boxShadow:[BoxShadow(color: Colors.green),] ,
                color:Color(0xffdaf9f5),
                ),
              
              height:MediaQuery.of(context).size.height*0.1 ,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  SizedBox(width: 5,),
                  Kainput(on_change:
                  (val){
                    if(all_filled()){
                    setState(() {
                    all_done=!all_done;
                    });}
                      },name:'Adm',controller: adm_controller,),
                  Kainput(on_change:(val){
                    if(all_filled()){
                    setState(() {
                    all_done=!all_done;
                  });}},name:'Score',controller: score_controller,),
                  Kainput(on_change:(val){
                    if(all_filled()){
                    setState(() {
                    all_done=!all_done;
                  });}},name:'Outof',controller: outof_controller,),
                  Kabtn(width: 100,text:'Add',active: all_done,action: insert,color: Color(0xffc89a6a),)
                ]
              ),
            )
          ],
        ),
      ),

    );
  }
   Future<Map> change_future() async=> fill_data;
  Future insert() async{
    Map data={
      'adm':adm_controller.text,
      'score':score_controller.text,
      'max':outof_controller.text
    };

    fill_data['entries'].add(data);
   
    
     setState(() {
       all_done=!all_done;
       entries=change_future();
     });

    ud.write_to_file(fill_data,widget.title+' '+widget.subtitle+'.json');
    Future update =ud.make_local(widget.title+' '+widget.subtitle+'.json');
    update.then((value) => widget.update_all_files());
    adm_controller.clear();
    score_controller.clear();

  }

  void delete_items(){
    // print(selected);
    List safe_items=[];
    for(int i=0;i<fill_data['entries'].length;i++){
     Map e=fill_data['entries'][i];
        if(selected[i]!=true){
          safe_items.add(e);
        }
    }
    // print(safe_items);
    fill_data['entries']=safe_items;
    selected={};
    setState(() {
       entries=change_future();
       edit_mode=false;

     });
    Future update =ud.make_local(widget.title+' '+widget.subtitle+'.json');
    update.then((value) => widget.update_all_files());
    ud.write_to_file(fill_data,widget.title+' '+widget.subtitle+'.json');

  }

  List<DataRow> get_rows(data){
    List<DataRow> rows=[];
    for(int i=0;i<data.length;i++){
      List<DataCell> cells=[];
      for(MapEntry e in data[i].entries){
        cells.add(DataCell(Text(e.value.toString(),),showEditIcon: e.key=='max',onTap: (){
        if(e.key=='max'){
          showDialog(context:context,builder: (context){
            TextEditingController ad=TextEditingController(text:data[i]['adm'] );
            TextEditingController sco=TextEditingController(text:data[i]['score'] );
            TextEditingController mx=TextEditingController(text:data[i]['max'] );

            return AlertDialog(
              actionsPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              actions: <Widget>[
                 FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Cancel')),
                FlatButton(onPressed: (){
                  fill_data['entries'][i]['adm']=ad.text;
                  fill_data['entries'][i]['max']=mx.text;
                  fill_data['entries'][i]['score']=sco.text;
                  setState(() {
                     entries=change_future();
                  });
                  Future update =ud.make_local(widget.title+' '+widget.subtitle+'.json');
                  update.then((value) => widget.update_all_files());
                  ud.write_to_file(fill_data,widget.title+' '+widget.subtitle+'.json');
                  Navigator.of(context).pop();
                }, child: Text('Update'))
              ],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text('Edit ',textAlign: TextAlign.center,),
              content: Container(
                height: 200,
                child:Column(children: <Widget>[
                  TextFormField(
                    controller: ad,
                    keyboardType: TextInputType.number,
                    decoration:InputDecoration(
                      labelText: 'Adm'
                    )
                  ),
                  TextFormField(
                    controller: sco,
                    keyboardType: TextInputType.number,
                    decoration:InputDecoration(
                      labelText: 'Score'
                    )
                  ),
                  TextFormField(
                    controller: mx,
                    keyboardType: TextInputType.number,
                    decoration:InputDecoration(
                      labelText: 'Max'
                    )
                  )
                ],)
              ),
            );
          });
        }
        } ));
      }
      rows.add(DataRow(cells: cells,onSelectChanged:edit_mode?(ind){
            setState(() {
              selected[i]=ind;
            });
            
      }:null,selected:selected[i]==true),);
    }
    return rows;
  }

}

class MyAlert extends StatefulWidget {
  const MyAlert({
    Key key,
    @required this.ud,
    @required this.widget,
    @required this.ctx,
    @required this.update_all_files,
  }) : super(key: key);

  final Uploader ud;
  final EditUpload widget;
  final BuildContext ctx;
  final update_all_files;

  @override
  _MyAlertState createState() => _MyAlertState();
}

class _MyAlertState extends State<MyAlert> {
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: loading?Text('Submitting'):Text('Submit exam'),
      content:loading?LinearProgressIndicator() :Text('Submit your results to your school?'),
      actions: <Widget>[
      FlatButton(child: Text('Cancel'),onPressed: (){Navigator.of(context).pop();},),
      loading?Container() :FlatButton(child: Text('Submit'),onPressed:(){
      var done=widget.ud.submit(widget.widget.title+' '+widget.widget.subtitle+'.json', null);
    setState(() {
      loading=true;
    });
    done.then((value) => {
      widget.update_all_files(),
      Navigator.of(context).pop(),
      Scaffold.of(widget.ctx).showSnackBar(SnackBar(content: Text('submitted'),))
    });
      },),
    ],);
  }
}

class Kainput extends StatelessWidget {
  const Kainput({
    Key key,
    @required this.on_change,
    this.name,
    this.controller
  }) : super(key: key);
final on_change;
final name;
final controller;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(   
        margin:EdgeInsets.only(right:3),
        decoration: BoxDecoration(
          color: Color(0xff5bd2d0),
          borderRadius: BorderRadius.circular(10)
        ),
        child: TextFormField(
          controller: controller,
          onChanged:on_change,
          keyboardType:TextInputType.number,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54,fontSize: 25),
          decoration:InputDecoration(
            border: InputBorder.none,
            hintText:name,
          )
        ),
      ),
    );
  }
}
