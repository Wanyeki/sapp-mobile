import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:schoolapp_x/screens/teaching_tt.dart';
import 'package:schoolapp_x/screens/updates.dart';

class Timetabling extends StatefulWidget {
  Timetabling({Key key,@required this.openReminder,this.all_details});
  final openReminder;
  final all_details;
  @override
  _TimetablingState createState() => _TimetablingState();
}

class _TimetablingState extends State<Timetabling> {
int idx=0;
    var now=DateTime.now();
    int da,yar,wkday,mon;
    List<int> months;
    String disp_wkday;
    String disp_date;
    List<String> days=['Monday','Tuesday','Wednesday','Thursday','Friday'];
    List<String> times=['8:00','8:40','9:20','9:35','10:15','10:55','11:25','12:05','12:45','14:00','14:40','15:20'];
    Future<List> my_tt;
    Teaching_tt teaching;
    
    //init state
    void initState(){
      teaching=Teaching_tt(all_details: widget.all_details);
      super.initState();
      wkday=now.weekday;
      yar=now.year;
      da=wkday>5?now.day-(wkday-5):now.day;
      months=[0,31,yar%4==0?29:28,31,30,31,30,31,31,30,31,30,31];
      wkday=wkday>5?5:wkday;
      disp_wkday=days[wkday-1];
      mon=now.month;
      if(da<1){
           da=da+months[mon];
           mon--;
         }
      disp_date=da.toString()+'/'+
                mon.toString()+'/'+
                yar.toString();
      my_tt=teaching.get_tt(wkday, widget.all_details['teacher_title']);
    }

    //next day
    void get_next(){
      setState(() {
        wkday=wkday==5?1:wkday+1;
         disp_wkday=days[wkday-1];
         wkday==1?da+=3:da++;
         if(da>months[mon]){
           da=da-months[mon];
           mon++;
         }

         disp_date=da.toString()+'/'+
                mon.toString()+'/'+
                yar.toString();
      setState(() {
        my_tt=teaching.get_tt(wkday, widget.all_details['teacher_title']);
      });
      });
      
         
    }

    //prev day
    void get_prev(){
  setState(() {
        wkday=wkday==1?5:wkday-1;
         disp_wkday=days[wkday-1];
         wkday==5?da-=3:da--;
         if(da<1){
           da=da+months[mon];
           mon--;
         }

         disp_date=da.toString()+'/'+
                mon.toString()+'/'+
                yar.toString();
      setState(() {
        my_tt=teaching.get_tt(wkday, widget.all_details['teacher_title']);
      });
      });
    }

    bool prev_double=false;

//right side function
    List<Widget> get_classes(day_classes){
      List<Widget> classes=[];
      for(int i=1;i<10;i++){

         Map cls=find_item(i,day_classes);
         
         if(cls!=null){
          //  cls['double']==1?i++:i;
            classes.add(
              Container(
              width: MediaQuery.of(context).size.width*0.75,
                height:cls['double']==1?200:100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromRGBO(255, 230, 232,1),
                ),
                child: Tt_class(
                  title: cls['subject']+' '+cls['form']+' '+cls['strm'],
                  subtitle: 'No Reminder',
                  trailing: Container(),
                ),

              )
            );
         }else{
           if(!prev_double){
           classes.add(
              Container(
                height:100,
               width: MediaQuery.of(context).size.width*0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromRGBO(218, 249, 245,1),
                ),
                child: Tt_class(
                  title:'Free',
                  subtitle:'No Reminder',
                  trailing: Container(),
                ),

              )
            );
           }

         }
         if(i%2==0 && i!=8){
         
           classes.add(Container(
                height:50,
              width: MediaQuery.of(context).size.width*0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Tt_class(
                  title: 'Break',
                  subtitle: 'No Reminder',
                  trailing: Container(),
                ),

              ));
         }
         if(cls!=null && cls['double']==1){
           prev_double=true;

         }else{
           prev_double=false;
         }
      }
      return classes;
    }

    Map find_item(no,day_classes){
      for(int j=0;j<day_classes.length;j++){
        if(day_classes[j]['no']==no){
          return day_classes[j];
        }
      }
      return null;
    }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(10),
      child:ListView(children: <Widget>[
        Container(
                  padding: EdgeInsets.fromLTRB(0,20,25,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text(disp_wkday,style: TextStyle(fontSize: 35,color: Color.fromRGBO(46, 37,80 ,1))),
                          Text(disp_date,style: TextStyle(fontSize: 15,color: Color.fromRGBO(162, 175, 189,1)),)
                        ]
                      ),
                      Row(
                        children: <Widget>[
                            Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape:BoxShape.circle,
                              border: Border.all(color:Colors.pink,width: 1)
                            ),
                            child: GestureDetector(child: Icon(Icons.navigate_before,color: Colors.pink,size: 30,),onTap:get_prev,)
                          ),
                          Container(
                            margin: EdgeInsets.only(left:10),
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape:BoxShape.circle,
                              border: Border.all(color:Colors.pink,width: 1)
                            ),
                            child: GestureDetector(child: Icon(Icons.navigate_next,color: Colors.pink,size: 30,),onTap:get_next,)
                          ),
                        ],
                      )
                    ],
                    ),
                ),
                SizedBox(height:20),
        GestureDetector(
          onHorizontalDragEnd: ( h){
            Offset v=h.velocity.pixelsPerSecond;
            v.dx<0?get_next():get_prev();
          
          },
          child: Row(
            children:[
              Column(children:times.map((String time){
                var index=times.indexOf(time);
//left side
                return Container(
                  padding: EdgeInsets.only(left: 5),
                  height:(index+1)%3==0 && index!=11?50:100,
                  width:MediaQuery.of(context).size.width*0.2,
                  child:Text(time),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  color:(index+1)%3==0 && index!=11?Colors.pink[100]:Colors.white,
                  )
                );
              }).toList(),),
              //right side
              FutureBuilder(builder:(cont,snapshot){
                if(snapshot.hasData){
                  if(snapshot.data.length==0){
                     return Container(
                       width: MediaQuery.of(context).size.width*0.75,
                       child: Column(
                         children: <Widget>[
                           Icon(FontAwesome.frown_o),
                           Text('No timetable',textAlign: TextAlign.center,),
                         ],
                       ),
                     );
                  }else{
                    return  Column(
                      children:get_classes(snapshot.data),
                    );
                    
                  }
                }else if(snapshot.hasError){
                  return Container(child:Text('some error'));
                }
                return Container(
                  width:MediaQuery.of(context).size.width*0.75 ,
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator(),
                  );
              } ,future: my_tt,)
            ]
          ),
        ),
        SizedBox(height:10),
        FutureBuilder(future: my_tt,builder: (context,snapshot){
          if(snapshot.hasData){
            return Text('Timetable: '+teaching.teaching['term'],style: TextStyle(color: Colors.pink),textAlign: TextAlign.center,);
          
          }
            return Text('No data',style: TextStyle(color: Colors.pink),textAlign: TextAlign.center,);
        },),
        IconButton(icon: Icon(Icons.refresh), onPressed: (){
          Updates updates=Updates(all_details:widget.all_details);
          updates.any_updates().then((value){
            teaching.teaching=null;
            setState(() {

             my_tt=teaching.get_tt(wkday, widget.all_details['teacher_title']);
            });
          });
        },color: Colors.pink,tooltip: 'Refresh timetable',),
        SizedBox(height:100)
      ],)
    );
  }
}
class Tt_class extends StatelessWidget {
  const Tt_class({Key key,@required this.title,this.trailing,this.subtitle}) : super(key: key);
  final title,trailing,subtitle;
  @override
  Widget build(BuildContext context) {
           
       return Row(
        
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Container(
              width: MediaQuery.of(context).size.width*0.60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text(title,style: TextStyle(fontSize: 20),),
                  Text(subtitle,style: TextStyle(color: Colors.black45),)
                ]
              ),
            ),
            trailing
          ]
        );
     
   
  }
}

