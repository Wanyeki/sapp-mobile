import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_share/flutter_share.dart';

class ClassResults extends StatefulWidget {
  ClassResults({
    Key key,
    @required this.resultData
  });
  final resultData;
  @override
  _ClassResultsState createState() => _ClassResultsState();
}

class _ClassResultsState extends State<ClassResults> {


String selected_exam;
String selected_form;
String selected_class;

    Future<Map> entries;
    List streams;
    List subjects;
    List exams;
  
  @override
  void initState() { 
    super.initState();
    // print(widget.resultData);
    streams=widget.resultData.classes['classes'];
    selected_class=streams[0]['name'];
 
    subjects=widget.resultData.classes['subjects'];

    exams=widget.resultData.exams['exams'];
    selected_exam=exams[0]['exam']+' '+exams[0]['term'];

    selected_form='form-1';

    entries=widget.resultData.get_class(selected_exam,selected_form,selected_class);
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
   List<DropdownMenuItem> get_streams(){
  
    List<DropdownMenuItem> stms=[];
    for(int i=0;i<streams.length;i++){
      stms.add(
        DropdownMenuItem(child: Text(streams[i]['name']),value:streams[i]['name'])
      );
    }
    return stms;
  }
  double get_avg(data){
    double avg=0;
   for (var i = 0; i < data.length; i++) {
     avg+=data[i]['points'];
   }
   return avg/data.length;
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

  

  List<DataColumn> get_cols(){
   List<DataColumn> cols=[];
   cols.add(DataColumn(label: Text('Adm',style: TextStyle(color: Colors.pink),)));
   cols.add(DataColumn(label: Text('Fname',style: TextStyle(color: Colors.pink),)));
   cols.add(DataColumn(label: Text('Lname',style: TextStyle(color: Colors.pink),)));
   for(int i=0;i<subjects.length;i++){
     cols.add(
       DataColumn(label: Text(subjects[i]['name']),numeric: true)
     );
   } 
   cols.add(DataColumn(label: Text('Total',style: TextStyle(color: Colors.pink),)));
   cols.add(DataColumn(label: Text('Points',style: TextStyle(color: Colors.pink),)));
   cols.add(DataColumn(label: Text('Grade',style: TextStyle(color: Colors.pink),)));
   
   return cols;
  }

  List<DataRow> get_rows(data){
     List<DataRow> rows=[];
     List<String> grades=['E','E','D-','D','D+','C-','C','C+','B-','B','B+','A-','A'];
     for(int i=0;i<data.length;i++){
       List<DataCell> cells=[];
        cells.add( DataCell(Text(data[i]['adm'].toString())));
        cells.add( DataCell(Text(data[i]['first_name'])));
        cells.add( DataCell(Text(data[i]['middle_name'])));

        for(int j=0;j<subjects.length;j++){
          List score_grade=data[i][subjects[j]['name']]==null?['0','0']:data[i][subjects[j]['name']].split(',');
          String score=score_grade[0];
          String grade=grades[int.parse(score_grade[1]).round()];
          cells.add( DataCell(Text(score+', '+grade.toString())));
        }
        cells.add( DataCell(Text(data[i]['total_marks'].toString())));
        cells.add( DataCell(Text(data[i]['points'].toString())));
        cells.add( DataCell(Text(data[i]['grade'])));
      rows.add(
        DataRow(cells: cells)
      );
     }
     return rows;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     body: Stack(
       children: <Widget>[
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children:[
                     IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed: ()=>Navigator.pop(context)),
                     MyDrop(on_changed: (val){setState(() {
                        selected_exam=val; 
                        entries=widget.resultData.get_class(selected_exam,selected_form,selected_class);
                        });},val: selected_exam ,data:get_terms,hint: 'Select Exam',icon: Icons.grade,color: Color(0xffff96bf)),
                     IconButton(icon: Icon(Icons.share,color: Colors.white,),onPressed:(){
                        FlutterShare.share(title: 'Schoolapp',text: 'Check out the new Highschool management software',linkUrl: 'https://wanyeki.github.io/schoolapp');
                        }),

                    ]
                  ),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children:[
                     MyDrop(on_changed: (val){setState(() { 
                       selected_form=val; 
                       entries=widget.resultData.get_class(selected_exam,selected_form,selected_class);
                       });},val: selected_form ,data:get_forms,hint: 'Select Form',icon: Icons.people,color:Color(0xffff96bf)),
                     MyDrop(on_changed: (val){setState(() {
                        selected_class=val; 
                        entries=widget.resultData.get_class(selected_exam,selected_form,selected_class);
                        });},val: selected_class ,data:get_streams,hint: 'Select class',icon: Icons.class_,color: Color(0xffff96bf))
                  
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
       
         margin:EdgeInsets.only(top:220),
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
                  child: Text('Class Results',style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
                ),
               SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child: FutureBuilder(builder:(context,snapshot){
                   if(snapshot.hasData){
                     return DataTable(
                   columnSpacing: 30,
                   sortColumnIndex:subjects.length+3,
                   columns:get_cols(), rows: get_rows(snapshot.data['entries']));
                   }else if(snapshot.hasError){
                     return NoNet(onReload: (){setState(() {
                            entries=widget.resultData.get_class(selected_exam,selected_form,selected_class);
                          });
                        },);
                   }
                   return NoDataLoad();
                 } ,future: entries,)

               ),SizedBox(height:100)
             ],),
           ),
         ),
       ),

     ],
     ),
     floatingActionButton: Container(
       decoration:BoxDecoration(
         boxShadow: [BoxShadow(blurRadius: 5,color: Color(0xffff96bf),)],
         borderRadius:BorderRadius.circular(20),
         color: Color(0xffff96bf)
       ),
       width:150,
       height:60,
       child:Center(child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children:[
           Text('AVG',style:TextStyle(color: Colors.white,fontSize:25)),
           FutureBuilder(
             future: entries,
             builder: (context, snapshot) {
               if(snapshot.hasData){
               return Text(get_avg(snapshot.data['entries']).toString(),style:TextStyle(color: Colors.white,fontSize:30));
               }
               return Text('0.0',style:TextStyle(color: Colors.white,fontSize:30));
             }
           )
         ]
       ),)
     ),
    );
  }
}

class NoNet extends StatelessWidget {
  const NoNet({
    Key key,
    @required this.onReload
  }) : super(key: key);
 final onReload;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child:Column(
        children: <Widget>[
          Icon(FontAwesome.frown_o),
          Text('An error occured:\nno internet.',textAlign:TextAlign.center,),
          IconButton(
          alignment: Alignment.center,
          onPressed:onReload,
          icon: Icon(FontAwesome.refresh),
          )
        ],
      )
    );
  }
}

class NoDataLoad extends StatelessWidget {
  const NoDataLoad({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical:10),
        child: CircularProgressIndicator()
        ),
    );
  }
}

class MyDrop extends StatelessWidget {
  const MyDrop({
    Key key,
    @required this.data,
    @required this.hint,
    @required this.icon,
    @required this.color,
    @required this.on_changed,
    @required this.val
  }) : super(key: key);

final data;
final hint;
final icon;
final color;
final on_changed;
final val;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:20),
     decoration: BoxDecoration(
       color: color,
       borderRadius: BorderRadius.all(Radius.circular(15))
     
     ),
      child: DropdownButton(
      
      value: val,
      underline: null,
      elevation: 5,
      hint: Text(hint,style:TextStyle(color: Colors.white)),
      icon:Icon(icon,color: Colors.white,) ,
      items:data() ,
       onChanged:(val){
         on_changed(val);
       } ,),
      );
  }
}