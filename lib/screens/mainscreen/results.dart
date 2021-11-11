import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:schoolapp_x/screens/results_data.dart';
class Results extends StatefulWidget {
  Results({Key key,@required this.all_details});
  final all_details;
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  ResultData rd;

  @override
  void initState() { 
    rd=ResultData(all_details: widget.all_details);
    super.initState();
    rd.load_items();
  }
  @override
  Widget build(BuildContext context) {
    return  Stack(
      alignment: AlignmentDirectional.topEnd,
      children:[
        Container(
          width:MediaQuery.of(context).size.width,
           margin: EdgeInsets.only(top:180),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
                    SizedBox(height:20),
                    Text('Results',style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),
                    MyTile(title: 'Class Prefomance',icon: Icon(Icons.pie_chart,color: Colors.white,),onPressed:(){
                      Navigator.of(context).pushNamed('/class_p',arguments:{'resultData':rd,'all_details':widget.all_details});
                      },color: Color(0xffff96bf),),
                    MyTile(title: 'Individual perfomance',icon: Icon(Icons.supervised_user_circle,color: Colors.white,),onPressed:(){
                      Navigator.of(context).pushNamed('/individual_p',arguments:{'resultData':rd,'all_details':widget.all_details});
                      },color: Color(0xff64caff),),
                    MyTile(title: 'Subjects perfomance',icon: Icon(Icons.subject,color: Colors.white,),onPressed:(){
                      Navigator.of(context).pushNamed('/subject_p',arguments:{'resultData':rd,'all_details':widget.all_details});
                      },color: Color(0xffffb42e),),
                    MyTile(title: 'Other schools',icon: Icon(Icons.home,color: Colors.white,),onPressed:(){
                      Navigator.of(context).pushNamed('/others_p',arguments:{'resultData':rd,'all_details':widget.all_details});
                      },color: Color(0xff33e350),),
                    MyTile(title: 'School Ranking',icon: Icon(Icons.line_weight,color: Colors.white,),onPressed:(){
                      Navigator.of(context).pushNamed('/ranking_p',arguments:{'resultData':rd,'all_details':widget.all_details});
                      },color: Color(0xffeb90ff),),

                  ],
          ),
        ),
        Container(
          height: 230,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color:Color(0xff5bd2d0),
            borderRadius: BorderRadius.only(bottomLeft:Radius.circular(150))
          ),
          alignment:AlignmentDirectional.topCenter,
          child:Column(
            children: <Widget>[
              SafeArea(
                child: Container(
                  height: 160,
                  width:200,
                  child: Hero(
                    tag:'logo',
                    child: Image.asset('assets/images/lab.png',
                    fit: BoxFit.cover,
                    ),
                  ),

                ),
              ),
               Text(widget.all_details['school_name'],style:TextStyle(fontSize:25,color:Colors.white))
            ],
          )
        ),
         SafeArea(
           child: Container(
             margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(3),
              child: IconButton(icon: Icon(Icons.share,color: Colors.white,), onPressed:(){
                        FlutterShare.share(title: 'Schoolapp',text: 'Check out the new Highschool management software',linkUrl: 'https://wanyeki.github.io/schoolapp');
                        })
            ),
         )
      ]
    ) ;
  }
}

class MyTile extends StatefulWidget {
  const MyTile({
    Key key,
    this.toggle=false,
    this.toggle_state,
    @required this.color,
    @required this.icon,
    @required this.onPressed,
    @required this.title
  
  }) : super(key: key);
  final title;
  final icon;
  final onPressed;
  final color;
  final toggle;
  final toggle_state;

  @override
  _MyTileState createState() => _MyTileState();
}

class _MyTileState extends State<MyTile> {
  bool allow_notifications;
  @override
  void initState() {
    allow_notifications=widget.toggle_state;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      splashColor: Colors.pink[50],
      child: Container(
        margin: EdgeInsets.only(top:20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading:Container(
               width:60,
               height:60,
               decoration:BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 5,color: widget.color,)],
                 borderRadius:BorderRadius.circular(20),
                 color:widget.color
               ),child: widget.icon,
             ),
             title: Text(widget.title),
             trailing:widget.toggle?Switch(value: widget.toggle_state, onChanged:(val){
               widget.onPressed();
             
             }) :IconButton(icon: Icon(Icons.navigate_next), onPressed: null),
          ),
        ),
      ),
    );
  }
}