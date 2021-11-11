import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_share/flutter_share.dart';

import 'class_result.dart';

class OtherSchools extends StatefulWidget {
   OtherSchools({
    Key key,
    @required this.resultData,
    @required this.all_details,
    this.school
  });
  final resultData;
  final all_details;
  final school;
  @override
  _OtherSchoolsState createState() => _OtherSchoolsState();
}

class _OtherSchoolsState extends State<OtherSchools> {
  String sc;
  var search_controller;
  bool suggest=false;
  String selected_exam;
  String selected_subject;
  List subjects;
  List exams;
  Future<Map> entries;
  Future<Map> suggestions;
  @override
  void initState() { 
    super.initState();
    sc=widget.school==null?widget.all_details['school_name']:widget.school;
    search_controller=TextEditingController(text:sc);
     subjects=widget.resultData.classes['subjects'];
          selected_subject=subjects[0]['name'];

          exams=widget.resultData.exams['exams'];
          selected_exam=exams[0]['exam']+' '+exams[0]['term'];
          
          entries=widget.resultData.get_school_data(sc,selected_subject,selected_exam);

  }

  void submit(school_name){
  entries=widget.resultData.get_school_data(school_name,selected_subject,selected_exam);
  FocusScope.of(context).unfocus();
    if(suggest){
      setState(() {
        suggest=false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        body:Stack(
          children:[
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
                    Container(
                         width: 250,
                         child: TextFormField(
                           controller: search_controller,
                           onEditingComplete: (){
                             setState(() {
                                 suggest=false;
                               });
                               submit(search_controller.text);
                               FocusScope.of(context).unfocus();
                           },
                           onChanged: (val){
                               setState(() { 
                                 if(suggest==false){
                                 suggest=true;
                                 }
                                  suggestions=widget.resultData.search_school(val);
                               });
                           },
                          
                           style: TextStyle(color: Colors.white),
                           decoration: InputDecoration(
                             labelStyle: TextStyle(color: Colors.white),
                             labelText: 'School Name',
                             border: InputBorder.none,
                             filled: true,
                             icon: Icon(Icons.search,color: Colors.white,)
                           ),
                           
                         ),
                       ),
                     IconButton(icon: Icon(Icons.share,color: Colors.white,), onPressed:(){
                        FlutterShare.share(title: 'Schoolapp',text: 'Check out the new Highschool management software',linkUrl: 'https://wanyeki.github.io/schoolapp');
                        }),
                  
                    ]
                  ),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children:[
                     MyDrop(on_changed: (val){setState(() { selected_subject=val; }); submit(search_controller.text); },val: selected_subject ,data:get_subjects,hint: 'Select Subject',icon: Icons.bookmark_border,color: Color(0xff64caff)),
                     MyDrop(on_changed: (val){setState(() { selected_exam=val; });submit(search_controller.text);},val: selected_exam ,data:get_terms,hint: 'Select Exam',icon: Icons.grade,color: Color(0xff64caff)),

                    
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
         width:MediaQuery.of(context).size.width,
       
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
                  child:FutureBuilder(builder: (context,snapshot){
                    if(snapshot.hasData){
                      return Text(snapshot.data['school_name'].toLowerCase(),style: TextStyle(fontSize: 30),textAlign: TextAlign.center,);
                    }
                    return Text('Input school name above',style: TextStyle(fontSize: 30),textAlign: TextAlign.center,);
                  },future:entries)
                ),
               SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child:FutureBuilder(builder: (context,snapshot){
                   if(snapshot.hasData){
                     return DataTable(
                          columns:[
                          DataColumn(label: Text('Grade',style: TextStyle(color: Colors.pink),)),
                          DataColumn(label: Text('Form1',style: TextStyle(color: Colors.pink),)),
                          DataColumn(label: Text('Form2',style: TextStyle(color: Colors.pink),)),
                          DataColumn(label: Text('Form3',style: TextStyle(color: Colors.pink),)),
                          DataColumn(label: Text('Form4',style: TextStyle(color: Colors.pink),)),
                          ] ,rows:get_rows(snapshot.data['entries']),);
                   }else if(snapshot.hasError){
                      return NoNet(onReload: (){submit(search_controller.text);});
                   }
                   return NoDataLoad();
                 },future:entries)
               ),SizedBox(height:100)
             ],),
           ),
         ),
       ),
       suggest?
       Card(
         margin: EdgeInsets.only(top:130,left:20,right:20),
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
          ]
        )
      )
    );
  }
    List<DataRow> get_rows(data){
      List<DataRow> rows=[];
      List<String> grades=['A','A2','B1','B','B2','C1','C','C2','D1','D','D2','E'];
      for(int i=0;i<grades.length;i++){
        List<DataCell> cells=[];
        String grade=grades[i].replaceAll('1', '+');
        grade=grade.replaceAll('2', '-');
        cells.add(DataCell(Text(grade)));
        for(int j=1;j<5;j++){
          cells.add(DataCell(Text(data[j-1]==null?'pending':data[j-1][grades[i]].toString())));
        }
        rows.add(DataRow(cells: cells));
      }
      
      print(rows);
      return rows;
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
List<Widget> get_schools_list(List data){
  List<Widget> the_list=[];
  for(int i=0;i<data.length;i++){
    the_list.add(
      Container(
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          splashColor: Colors.pink,
          onTap: (){
            search_controller.text=data[i];
            submit(data[i]);
          },
          child: ListTile(title: Text(data[i]),trailing: Icon(Icons.navigate_next),leading: Icon(Feather.tag),))
    )
    );
  }
  return the_list;
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