import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:schoolapp_x/screens/result_screens/class_result.dart';
import 'package:url_launcher/url_launcher.dart';

class IndividualResults extends StatefulWidget {
   IndividualResults({
    Key key,
    @required this.resultData
  });
  final resultData;
  @override
  _IndividualResultsState createState() => _IndividualResultsState();
}

class _IndividualResultsState extends State<IndividualResults> {

 Future<Map> entries;
 String selected_term;
 var adm=TextEditingController();
 var avatar=AssetImage('assets/images/avatar.png');
 List exams;
 List subjects;
 
 @override
 void initState() { 
   super.initState();
   exams=widget.resultData.exams['exams'];
   subjects=widget.resultData.classes['subjects'];
   selected_term=exams[0]['term'];
  //  entries= widget.resultData.get_individual(0,selected_term);
 }
 
  List<DropdownMenuItem> get_terms(){
    List<DropdownMenuItem> tms=[];
    List<String>trms=[];
    for(int i=0;i<exams.length;i++){
      if(trms.indexOf(exams[i]['term'])<0){
        tms.add(
          DropdownMenuItem(child: Text(exams[i]['term']),value:exams[i]['term'])
        );
       trms.add(exams[i]['term']);
      }
      
    }
    // print(exams);
    return tms;
  }
 double sum_points=0;
 double sum_score=0;
 int count=0;
  String get_grade(String combo){
    count++;
    if(combo==null)return '0';
    List<String> grades=['E','E','D-','D','D+','C-','C','C+','B-','B','B+','A-','A'];
    List score_grade=combo.split(',');
          String score=score_grade[0];
          sum_score+=int.parse(score);
          sum_points+=int.parse(score_grade[1]);
          String grade=grades[int.parse(score_grade[1]).round()];
          return (score+', '+grade.toString());
  }
 List <DataRow> get_rows(data){
   List <DataRow> rows=[];
  if(data.length>0){
     for(int i=0;i<subjects.length;i++){
        List<DataCell> cells=[];
        cells.add(DataCell(Text(subjects[i]['name'])));
        cells.add(DataCell(Text(data[0]!=null?get_grade(data[0][subjects[i]['name']]):'pending')));
        cells.add(DataCell(Text(data[1]!=null?get_grade(data[1][subjects[i]['name']]):'pending')));
        cells.add(DataCell(Text(data[2]!=null?get_grade(data[2][subjects[i]['name']]):'pending')));
      
        cells.add(DataCell(Text((sum_score/(count==0?1:count)).toString())));
        cells.add(DataCell(Text((sum_points/(count==0?1:count)).toString())));

        sum_points=0;
        sum_score=0;
        count=0;
        rows.add(DataRow(cells: cells));
     }
   }
   return rows;

 } 
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Scaffold(
        backgroundColor: Colors.white,
        body:Stack(children: <Widget>[
          Container(height: 300,
           decoration: BoxDecoration(
             color: Colors.pink
           ),
           child: SafeArea(
             child:Column(
               mainAxisAlignment: MainAxisAlignment.start,
               children: <Widget>[
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                    IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,) ,onPressed:()=>Navigator.of(context).pop(),),
                    Text('Individual Results',style: TextStyle(fontSize: 20,color: Colors.white),),
                    IconButton(icon:Icon(Icons.share,color: Colors.white,) ,onPressed:(){
                        FlutterShare.share(title: 'Schoolapp',text: 'Check out the new Highschool management software',linkUrl: 'https://wanyeki.github.io/schoolapp');
                        },),
               ],),
               Container(
                 padding: EdgeInsets.only(top:20),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>[
                   Container(
                     padding: EdgeInsets.all(5),
                     decoration: 
                     BoxDecoration(
                       border:Border.all(color: Color(0xff64caff),width: 3),
                       shape: BoxShape.circle
                     ),
                     child: CircleAvatar(
                       backgroundImage:avatar,
                       radius: 50,
                       
                     ),
                   ),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children:[
                       Container(
                         width: 200,
                         child: TextFormField(
                           onChanged: (val){
                              setState(() {
                               entries= widget.resultData.get_individual(val,selected_term);
                             });
                           },
                          controller: adm,                     
                          style: TextStyle(color: Colors.white,fontSize: 20),
                           keyboardType: TextInputType.number,
                           decoration: InputDecoration(
                             labelStyle: TextStyle(color: Colors.white),
                             labelText: 'Admission no',
                             border: InputBorder.none,
                             filled: true,
                             icon: Icon(Icons.search,color: Colors.white,),
                            
                           ),
                           
                         ),
                       ),
                       SizedBox(height: 20,),
                       MyDrop(data: get_terms, hint: 'Select term', icon: Icons.table_chart, color: Color(0xff64caff), on_changed: (val){setState(() {
                       selected_term=val;  
                       });}, val: selected_term),

                     ]
                   )
                 ],),
               )

             ],)
           ),
           ),

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
                  child:FutureBuilder(future: entries,builder: (context,snapshot){
                    if(snapshot.hasData){
                      return  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(snapshot.data['name']+'-'+snapshot.data['adm'].toString(),style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
                            snapshot.data['parent']=='no'?Container():IconButton(tooltip: 'call parent',icon: Icon(Icons.call,), onPressed: (){
                              Uri lnk=Uri(
                                scheme: 'tel',
                                path: snapshot.data['parent'],
                              );
                              // print(lnk.toString());
                               launch(lnk.toString());
                            },color: Color(0xff33e350),)
                          ],
                        );
                    }
                    return  Text('Input adm no above',style: TextStyle(fontSize: 30),textAlign: TextAlign.center,);

                  },)
                ),
               SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child: FutureBuilder(builder: (context,snapshot){
                   if(snapshot.hasData){
                     return DataTable(
                   sortColumnIndex: 4,
                   columns: [
                   DataColumn(label: Text('Subject',style: TextStyle(color: Colors.pink),)),
                   DataColumn(label: Text('End',style: TextStyle(color: Colors.pink),)),
                   DataColumn(label: Text('Opener',style: TextStyle(color: Colors.pink),)),
                   DataColumn(label: Text('Mid',style: TextStyle(color: Colors.pink),)),
                   DataColumn(label: Text('Avg',style: TextStyle(color: Colors.pink),)),
                   DataColumn(label: Text('points',style: TextStyle(color: Colors.pink),)),

                   
                 ], rows: get_rows(snapshot.data['entries']));
                   }else if(snapshot.hasError){
                      return NoNet(onReload: (){
                             setState(() {
                               entries= widget.resultData.get_individual(adm.text,selected_term);
                             });
                           });
                   }
                   return NoDataLoad();
                 },future: entries,),
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
      )
    );
  }
    double get_avg(data){
    double count2=0;
    double sum=0;
    for(int i=0;i<data.length;i++){
      if(data[i]!=null){
        count2++;
        sum+=data[i]['points'];
      }
    }
    return sum/(count2==0?1:count2);
  }
}

class FloatingMean extends StatelessWidget {
  const FloatingMean({
    Key key,
    this.name,
    this.value,
    this.color,
  }) : super(key: key);

  final name;
  final color;
  final value;

  @override
  Widget build(BuildContext context) {
    return Container(
       decoration:BoxDecoration(
     boxShadow: [BoxShadow(blurRadius: 5,color: color!=null?color:Color(0xff33e350),)],
     borderRadius:BorderRadius.circular(20),
     color: color!=null?color:Color(0xff33e350)
       ),
       width:150,
       height:60,
       child:Center(child: Row(
     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
     children:[
       Text(name,style:TextStyle(color: Colors.white,fontSize:25)),
       Text(value.toString(),style:TextStyle(color : Colors.white,fontSize:30))
     ]
       ),)
     );
  }
}