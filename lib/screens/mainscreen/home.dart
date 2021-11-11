import 'dart:io';

import 'package:flutter/material.dart';
import 'package:schoolapp_x/screens/teaching_tt.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Home extends StatefulWidget {
  Home({Key key ,@required this.all_details,@required this.roaster});
  final all_details;
  final roaster;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File image;
  Roaster rs=Roaster();
  List teachers;
  int week;


  void initState(){
   
    Map rst=rs.this_week(widget.roaster);
    if(rst['teachers'].length==0){
      var tt=Teaching_tt(all_details:widget.all_details);
      tt.clear_alarm();
    }
    teachers=rst['teachers'];
    week=rst['week'];
    image=File(widget.all_details['path']+'/teachers_images'+widget.all_details['teacher_title']+'.png');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children:[
                Container(
                  padding: EdgeInsets.fromLTRB(25,30,25,0),
                  child:
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Hero(tag:'head',child: Text('Schoolapp',style: TextStyle(fontSize: 35,color: Color.fromRGBO(46, 37,80 ,1)))),
                          Hero(tag:'subhead',child: Text('Welcome, '+widget.all_details['teacher_title'],style: TextStyle(fontSize: 15,color: Color.fromRGBO(162, 175, 189,1)),))
                        
                        ]
                      ),
                      Hero(
                        tag: 'me',
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape:BoxShape.circle,
                            border: Border.all(color:Colors.pink,width: 1)
                          ),
                          child: GestureDetector(
                            onTap: ()=>Navigator.of(context).pushNamed('/settings',arguments: {'all_details':widget.all_details,'image':image,'home_image':(File fl){
                              setState(() {
                                image=fl;
                              });
                              
                            }}),
                            child: CircleAvatar(
                              backgroundImage: FileImage(image),
                              onBackgroundImageError: (a,b){},
                              radius: 25,
                            ),
                          ),
                        ),
                      )
                    ],
                    ),
                ),
                SizedBox(height:20),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:get_weekdays()
                ),
                SizedBox(height:10),
                
                Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:get_days()[0]
                ),
                SizedBox(height:5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:get_days()[1],
                ),
                 SizedBox(height:40),
                 //School details future
                Stack(
                  alignment: AlignmentDirectional.topEnd,      
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                      color: Color.fromRGBO(238, 235, 255,1),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      width: MediaQuery.of(context).size.width*0.95,
                      child:Column(
                        children:[
                          Text(widget.all_details['school_name'],style:TextStyle(fontSize:25,color:Color.fromRGBO(113, 91, 208,1))),
                          SizedBox(height: 10,),
                          Container(
                            child: Hero(
                              tag:'logo',
                              child:Image(
                                image:FileImage(File(widget.all_details['path']+'/logo.png'),),
                                fit: BoxFit.cover,
                                height: 100,
                                errorBuilder: (a,b,c){
                                  return Image.asset('assets/images/my_logo.png',fit: BoxFit.cover,
                                height: 100,);
                                },),
                            ),
                            
                          ),
                          SizedBox(height:20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                            Column(children:[
                              Row(children: <Widget>[
                                Icon(Icons.people, color:Color.fromRGBO(113, 91, 208,1) ,),
                                Text(' students: ',style: TextStyle(color:Color.fromRGBO(113, 91, 208,1)),),
                                Text(widget.all_details['students'].toString(),style: TextStyle(fontSize: 20,color:Color.fromRGBO(113, 91, 208,1)),)
                              ],),
                              SizedBox(height:10),
                              Row(children: <Widget>[
                                Icon(Icons.toys,color:Color.fromRGBO(113, 91, 208,1)),
                                Text( ' Classes: ',style: TextStyle(color:Color.fromRGBO(113, 91, 208,1)),),
                                Text(widget.all_details['classes'].toString(),style: TextStyle(fontSize: 20,color:Color.fromRGBO(113, 91, 208,1)),)
                              ],)
                            ]),
                            Column(children:[
                              Row(children: <Widget>[
                                Icon(Icons.home,color:Color.fromRGBO(113, 91, 208,1)),
                                Text(' Teachers: ',style: TextStyle(color:Color.fromRGBO(113, 91, 208,1)),),
                                Text(widget.all_details['teachers'].toString(),style: TextStyle(fontSize: 20,color:Color.fromRGBO(113, 91, 208,1)),)
                              ],),
                              SizedBox(height:10),
                              Row(children: <Widget>[
                                Icon(Icons.strikethrough_s,color:Color.fromRGBO(113, 91, 208,1)),
                                Text( ' Streams: ',style: TextStyle(color:Color.fromRGBO(113, 91, 208,1)),),
                                Text(widget.all_details['streams'].toString(),style: TextStyle(fontSize: 20,color:Color.fromRGBO(113, 91, 208,1)),)
                              ],)
                            ])
                          ],)
                        ]
                      ) ,
                      ),
                       Container(
                    
                      decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                      ),
                      padding:EdgeInsets.all(5),
                      
                      child: CircleAvatar(
                        backgroundColor:Color.fromRGBO(113, 91, 208,1),
                        radius: 10,
                      ),
                    )
                  ],
                ),
                SizedBox(height:20),
               
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: <Widget>[
                    Container(
                      
                      decoration: BoxDecoration(
                      color: Color.fromRGBO(218, 249, 245,1),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      width: MediaQuery.of(context).size.width*0.95,
                      child: Column(
                        children: <Widget>[
                          Text('Message',style: TextStyle(fontSize: 25,color: Color.fromRGBO(44, 166, 164,1)),),
                            ListTile(
                              leading: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape:BoxShape.circle,
                              border: Border.all(color:Color.fromRGBO(44, 166, 164,1),width:3)
                            ),
                            
                                child: CircleAvatar(
                                  //backgroundImage:AssetImage('assets/images/g.jpg'),
                                  radius: 25,
                                ),
                              ),
                              title: Text('Welcome',style: TextStyle(color:Color.fromRGBO(44, 166, 164,1)),),
                              subtitle:Text('welcome to schoolapp',style: TextStyle(color: Color.fromRGBO(44, 166, 164,1)),), 
                              trailing: IconButton(icon: Icon(Icons.open_in_browser,color: Color.fromRGBO(44, 166, 164,1)), onPressed: null),) 
                            ,
                        ],
                      ),
                    ),
                    Container(
                    
                      decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                      ),
                      padding:EdgeInsets.all(5),
                      
                      child: CircleAvatar(
                        backgroundColor:Color.fromRGBO(44, 166, 164,1),
                        radius: 10,
                      ),
                    )
                  ],
                ),
                SizedBox(height:40),
                 teachers.length>0?
                 InkWell(
                    onTap: ()=>Navigator.of(context).pushNamed('/roaster',arguments:{"get_weekdays":get_weekdays,"get_days":get_days,'roaster':widget.roaster['roaster'],'week':week,'all_details':widget.all_details}),
                    splashColor: Colors.purple,child: TodTab(teachers: teachers,week: 'week'+week.toString(),title: 'Teachers On Duty',all_details: widget.all_details,)
                  ):Container(),
                        
                  SizedBox(height:100)

              ]
            ),
          ),
        ],
      )
    );
  }
  List<String> weekdays=['not','Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
  List<Widget> get_weekdays(){
    List<Widget> wd=[];
    for(int i=1;i<weekdays.length;i++){
      wd.add(
        Container(
          width: 50,
        child: Text(weekdays[i][0],textAlign: TextAlign.center,style: TextStyle(fontSize: 25,color: Color.fromRGBO(162, 175, 189,1)))));
    }
    return wd;
  }
  List<List<Widget>> get_days(){
    var now=DateTime.now();
    List<Widget> wd=[];
    List<Widget> dots=[];
    int yar=now.year;
    int mon=now.month;
    List<int> months=[0,31,yar%4==0?29:28,31,30,31,30,31,31,30,31,30,31];
    
    int today=now.day;
    int wkd=now.weekday;
    int initial=today-wkd+1;

    for(int i=initial;i<initial+7;i++){
      
      Widget dot=Container(width:50,child:Container());
     
      int dy=i;
      if(dy<1){
       int prevmonth= months[mon-1];
       dy=i+prevmonth;
      }else if(dy>months[mon]){
        dy=dy-months[mon];
      } 
      if(dy==today){
        dot=Container(
          width: 50,
            child: CircleAvatar(
            backgroundColor: Colors.pinkAccent,
            radius: 3,
            child: Text(''),
          ),
        );
      }
      dots.add(dot);
      wd.add(
        Container(
          padding: EdgeInsets.all(2),
          width: 50,
          decoration: BoxDecoration(
          color:dy==today?Color.fromRGBO(218, 219, 248,1):Colors.white,
            shape: BoxShape.circle
          ),
          child: Text(dy.toString(),
          textAlign: TextAlign.center,style: TextStyle(fontSize: 25,color:dy==today?Color.fromRGBO(86, 94, 245,1): Color.fromRGBO(46, 37,80 ,1))))
        );
    }
    return [wd,dots];
  }

}

class TodTab extends StatelessWidget {
  const TodTab({
    Key key,
    @required this.teachers,
    @required this.week,
    @required this.all_details,
    @required this.title,
    this.color
  }) : super(key: key);

  final List teachers;
  final String week;
  final String title;
  final Map all_details;
  final List color;
  String get_initials(name){
    // print('....................');
   
    List<String> names=name.split(' ');
    names=names.length>2?names.where((e) => e!='').toList():names;
    //  print(names);
    return names[1][0].toUpperCase()+names[1][1].toUpperCase();
  }
  getColor()=>color==null? Colors.pink[300]:color[0];
  getColor2()=>color==null? Color.fromRGBO(255, 230, 232,1):color[1];
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
          color: getColor2(),
          borderRadius: BorderRadius.all(Radius.circular(20))
          ),
         height: 190,
          width: MediaQuery.of(context).size.width*0.95,
          child:Column(children: <Widget>[
            Text(title,style: TextStyle(fontSize: 25,color: getColor()),),
            SizedBox(height:20),
            
            Expanded(
              child:SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children:
                 teachers.map((tr) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal:20),
                  child: Column(
                    children:[
                      Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape:BoxShape.circle,
                  border: Border.all(color:getColor(),width:3)
                ),
                        child: InkWell(
                          child: CircleAvatar(radius: 30,
                          child: Text(get_initials(tr['name']),style: TextStyle(color: getColor())),
                          backgroundColor: getColor2(),
                          onBackgroundImageError: (s,b){},
                          backgroundImage:FileImage(File(all_details['path']+'/teachers_images'+tr['name']+'.png')),),
                          onTap: (){
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (_){
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  contentPadding: EdgeInsets.zero,
                                  content: Container(
                                  // width: MediaQuery.of(context).size.width,
                                  child: Image.file(File(all_details['path']+'/teachers_images'+tr['name']+'.png'),
                                  // fit: BoxFit.fitWidth,
                                  errorBuilder: (a,b,c){
                                    return Container(height: 200,
                                    child: Center(child: Text('No Image'),),);
                                  },),
                            ),
                                );
                              }
                            );
                          },
                        ),
                      ),
                      Text(tr['name'],style: TextStyle(color: getColor()),)
                    ]
                  ),
                ) ;
               }).toList(),)
              ),
              
            ),
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children:[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(week,style: TextStyle(color: getColor()),),
              ),
              IconButton(icon: Icon(Icons.more_horiz,color: getColor()), onPressed: null)
              ]
            )

          ],)
        ),
         Container(
        
          decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle
          ),
          padding:EdgeInsets.all(5),
          
          child: CircleAvatar(
            backgroundColor:getColor(),
            radius: 10,
          ),
        )
      ],
    );
  }
}
