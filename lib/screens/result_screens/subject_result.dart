import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:schoolapp_x/screens/result_screens/individual_result.dart';

import 'class_result.dart';

class SubjectResults extends StatefulWidget {
   SubjectResults({
    Key key,
    @required this.resultData
  });
  final resultData;
  @override
  _SubjectResultsState createState() => _SubjectResultsState();
}

class _SubjectResultsState extends State<SubjectResults> {
  String selected_exam;
  String selected_subject;
  String selected_form;
 
  Future<Map> entries;
  List subjects;
  List streams;
  List exams;
    @override
    void initState() { 
      super.initState();
          streams=widget.resultData.classes['classes'];
      
          subjects=widget.resultData.classes['subjects'];
          selected_subject=subjects[0]['name'];

          exams=widget.resultData.exams['exams'];
          selected_exam=exams[0]['exam']+' '+exams[0]['term'];

          selected_form='form-1';

          entries=widget.resultData.get_subject(selected_exam,selected_subject,selected_form);
    }
    List<DataRow> get_rows(data){
      int find_class(strm){
        for(int z=0;z<data.length;z++){
          if(data[z]['class']==strm){
            return z;
          }else if(z==data.length-1){
            return null;
          }
        }
      }
      List<DataRow> rows=[];
      List<String> grades=['A','A2','B1','B','B2','C1','C','C2','D1','D','D2','E'];
      for(int i=0;i<grades.length;i++){
        List<DataCell> cells=[];
        String grade=grades[i].replaceAll('1', '+');
        grade=grade.replaceAll('2', '-');
        cells.add(DataCell(Text(grade)));
        for(int j=0;j<streams.length;j++){
          cells.add(DataCell(Text(find_class(streams[j]['name'])==null?'pending':data[find_class(streams[j]['name'])][grades[i]].toString())));
        }
        rows.add(DataRow(cells: cells));
      }

      return rows;
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

    List<DataColumn> get_streams(){
  
    List<DataColumn> stms=[];
    stms.add(DataColumn(label: Text('Grade',style: TextStyle(color: Colors.pink),)));
    for(int i=0;i<streams.length;i++){
      stms.add(
        DataColumn(label: Text(streams[i]['name'],style: TextStyle(color: Colors.pink),))
      );
    }
    return stms;
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Scaffold(
        backgroundColor: Colors.white,
        body:Stack(children: <Widget>[
        Container(
        height: 300,
           decoration: BoxDecoration(
             color: Colors.pink
           ),
           child: SafeArea(child:
         Column(
           children: <Widget>[
             Container(
               height: 200,
               child:
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children:[
                     IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed: ()=>Navigator.pop(context)),
                     MyDrop(on_changed: (val){
                       setState(() { selected_exam=val; });
                        entries=widget.resultData.get_subject(selected_exam,selected_subject,selected_form);

                       },val: selected_exam ,data:get_terms,hint: 'Select Exam',icon: Icons.grade,color: Color(0xff64caff)),
                     IconButton(icon: Icon(Icons.share,color: Colors.white,), onPressed:(){
                        FlutterShare.share(title: 'Schoolapp',text: 'Check out the new Highschool management software',linkUrl: 'https://wanyeki.github.io/schoolapp');
                        }),
                  
                    ]
                  ),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children:[
                     MyDrop(on_changed: (val){
                       setState(() { selected_subject=val; 
                        entries=widget.resultData.get_subject(selected_exam,selected_subject,selected_form);
                       });},val: selected_subject ,data:get_subjects,hint: 'Select Subject',icon: Icons.bookmark_border,color: Color(0xff64caff)),
                     MyDrop(on_changed: (val){
                       setState(() { selected_form=val; });
                        entries=widget.resultData.get_subject(selected_exam,selected_subject,selected_form);
                       },val: selected_form ,data:get_forms,hint: 'Select Form',icon: Icons.people,color:Color(0xff64caff)),
                    
                   ]
                  ),
                  
                ],
              ),

             ),
             SizedBox(height:50)
           ],
         ),
         )
       ,),
       Container(
        //  width:MediaQuery.of(context).size.width,
       
         margin:EdgeInsets.only(top:230),
         decoration: BoxDecoration(
           borderRadius: BorderRadius.only(topRight:Radius.circular(50),topLeft:Radius.circular(50)),
           color:Color(0xffffffff)

         ),
         child: ClipRRect(
           borderRadius: BorderRadius.only(topRight:Radius.circular(50),topLeft:Radius.circular(50)),
           child: Container(
             width: MediaQuery.of(context).size.width,
             child: ListView(
               shrinkWrap: true,
               children: <Widget>[
               Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:Text(selected_subject+' '+selected_form,style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
                ),
               SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child: FutureBuilder(builder: (context,snapshot){
                   if(snapshot.hasData){
                     return DataTable(columnSpacing: 85,columns: get_streams(),rows: get_rows(snapshot.data['entries']),);
                   }else if(snapshot.hasError){
                       return NoNet(onReload: (){
                             setState(() {
                               entries=widget.resultData.get_subject(selected_exam,selected_subject,selected_form);
                             });
                           },);
                   }
                   return NoDataLoad();
                 },future: entries,)
               ),SizedBox(height:100)
             ],),
           ),
         ),
       ),
        
        ],),
        floatingActionButton: FutureBuilder(
             future: entries,
             builder: (context, snapshot) {
               if(snapshot.hasData){
               return FloatingMean(name: 'AVG',value: get_avg(snapshot.data['entries']).toString(),color: Color(0xff64caff),);
               }
               return FloatingMean(name: 'AVG',value: '0.0',color: Color(0xff64caff),);
             }
           )
        
      ) ,
    );
  }
      double get_avg(data){
    double avg=0;
   for (var i = 0; i < data.length; i++) {
     avg+=data[i]['avg'];
   }
   return avg/data.length;
  }
}