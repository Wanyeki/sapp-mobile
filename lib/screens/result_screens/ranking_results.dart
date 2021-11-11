import 'package:flutter/material.dart';
import 'package:schoolapp_x/screens/result_screens/individual_result.dart';

import '../global.dart';
import 'class_result.dart';
class Rankings extends StatefulWidget {
   Rankings({
    Key key,
    @required this.resultData,
    @required this.all_details
  });
  final resultData;
  final all_details;
  @override
  _RankingsState createState() => _RankingsState();
}


class _RankingsState extends State<Rankings> {
  String selected_exam;
  String selected_subject;
  int pos=0;

  void get_schools() async{
   Map sc= await widget.resultData.get_ranking(selected_subject,selected_exam);
   for (var i = 0; i < sc['schools'].length; i++) {
     if(sc['schools'][i]['name']==widget.all_details['school_name']){
       pos=i+1;
     }
   }
   setState(() {
     schools=sc['schools'];
   });
  }

  @override
  void initState() { 
    super.initState();
     subjects=widget.resultData.classes['subjects'];
      selected_subject=subjects[0]['name'];

      exams=widget.resultData.exams['exams'];
      selected_exam=exams[0]['exam']+' '+exams[0]['term'];
      get_schools();

  }
  String get_title(){
    if(selected_exam==null && selected_subject==null){
      return 'Select Something';
    }else if(selected_exam==null && selected_subject!=null){
      return 'Select exam';
    }else if (selected_exam!=null && selected_subject==null){
      return 'Select subject';
    }else{
     return selected_subject+' '+selected_exam;
    }
  }
  List subjects;
  List exams;
 List schools=[

 ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:CustomScrollView(
        slivers:<Widget>[
          SliverAppBar(
           // shape: BeveledRectangleBorder(side: BorderSide(color: Colors.blue)),
            //shape:ContinuousRectangleBorder(side: BorderSide(color: Colors.blue)),
           // shape: StadiumBorder(side:BorderSide(color: Colors.blue)),
             shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(30))),
          
            floating:true,
            expandedHeight:200,
            flexibleSpace: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                 
                  Container(
                    padding: EdgeInsets.only(top:10),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children:[
                      Text(get_title(),style:TextStyle(fontSize:25,color: Colors.white))
                      
                     ]
                    ),
                  ),
                   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children:[
                     MyDrop(on_changed: (val){
                       setState(() {selected_subject=val;  });
                       get_schools();
                       },val: selected_subject ,data:get_subjects,hint: 'Select Subject',icon: Icons.bookmark_border,color: Color(0xffeb90ff)),
                       MyDrop(on_changed: (val){
                         setState(() {selected_exam=val;}); 
                         get_schools();
                         },val: selected_exam ,data:get_terms,hint: 'Select Exam',icon: Icons.grade,color: Color(0xffeb90ff)),

                    
                   ]
                  ),
                  
                ],
              ),
            ),
            
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context,i){
                
                return InkWell(
                  splashColor: Colors.pink[100],
                  onTap: ()=>Navigator.of(context).pushNamed('/others_p',arguments:{'resultData':widget.resultData,'all_details':widget.all_details,'school':schools[i]['name']}),
                  child: Container(
                    child: ListTile(
                      leading: Image.network(Global.server+schools[i]['logo']),
                      title: Text(schools[i]['name']),
                      subtitle: Text(schools[i]['mean'].toString()),
                      trailing:  Text((i+1).toString()),
                      
                      ),
                  ),
                );
              } , childCount:schools.length
            ),
          )
        ]
        
      ),
      floatingActionButton: FloatingMean(value:pos,name:'position',color: Color(0xffeb90ff),),
    );
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

     List<DropdownMenuItem> get_terms(){
    List<DropdownMenuItem> tms=[];
    for(int i=0;i<exams.length;i++){
      tms.add(
        DropdownMenuItem(child: Text(exams[i]['exam']+' '+exams[i]['term']),value:exams[i]['exam']+' '+exams[i]['term'])
      );
    }
    return tms;
  }
}