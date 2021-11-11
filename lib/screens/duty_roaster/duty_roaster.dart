import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:schoolapp_x/screens/mainscreen/home.dart';

class DutyRoaster extends StatefulWidget {
  DutyRoaster({
    Key key,
    @required this.get_weekdays,
    @required this.get_days,
    @required this.roaster,
    @required this.week,
    @required this.all_details,
    });
  final get_weekdays;
  final get_days;
  final week;
  final roaster;
  final all_details;
  @override
  _DutyRoasterState createState() => _DutyRoasterState();
}

class _DutyRoasterState extends State<DutyRoaster> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Stack(
          children:[
            SizedBox(height:10),
            Column(
              children: <Widget>[
                 SizedBox(height:10),
                Container(
                      padding: EdgeInsets.fromLTRB(25,30,25,0),
                      child:
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.navigate_before), onPressed: (){
                            Navigator.of(context).pop();
                          }),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                              Text('Duty Roaster',style: TextStyle(fontSize: 35,color: Color.fromRGBO(46, 37,80 ,1))),
                              Text(widget.all_details['school_name'],style: TextStyle(fontSize: 15,color: Color.fromRGBO(162, 175, 189,1)),)
                            ]
                          ),
                          IconButton(icon: Icon(Icons.share), onPressed:(){
                        FlutterShare.share(title: 'Schoolapp',text: 'Check out the new Highschool management software',linkUrl: 'https://wanyeki.github.io/schoolapp');
                        })
                        ],
                        ),
                    ),
                  SizedBox(height:20),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:widget.get_weekdays()
                ),
                 SizedBox(height:10),
                
                Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:widget.get_days()[0]
                ),
                SizedBox(height:5),  
              ],
            ),
                
                Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top:170),
                  child: ClipRRect(
                   borderRadius: BorderRadius.only(topRight:Radius.circular(50),topLeft:Radius.circular(50)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.roaster.length,
                      itemBuilder: (context,i){
                    
                      Map wk=widget.roaster[i];
                      List<String> tcrs=wk['teachers'].split(',');
                      List<Map> teachers=tcrs.map((t){
                        return {
                          'name':t,
                        
                        };
                      }).toList();

                      return Container(
                        margin: EdgeInsets.only(bottom:10),
                        child: TodTab(
                          color:wk['t_slot']==widget.week?[Color.fromRGBO(113, 91, 208,1),Color.fromRGBO(238, 235, 255,1),]:null,
                          teachers:teachers,
                          week: 'week'+wk['t_slot'].toString(),
                          title: 'week'+wk['t_slot'].toString(),
                          all_details: widget.all_details,
                          ));
                    }),
                  ),
                )
          ]
        ),
      )
    );
  }
}

