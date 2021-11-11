import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

class Teaching_tt{
  Teaching_tt({this.all_details});
  final all_details;
  List<String> times=['7:00','8:00','8:40','9:35','10:15','11:25','12:05','14:00','14:40','15:20'];
  Map teaching=null;
  List<String>weekdays=['not','mon','tue','wed','thu','fri','sat','sun'];
  List<Day> days=[Day.Monday,Day.Monday,Day.Tuesday,Day.Wednesday,Day.Thursday,Day.Friday];
  
  Future<List> get_tt(day,title) async{
    if(this.teaching==null){
        Directory dir=await getApplicationDocumentsDirectory();
        String path=dir.path;
        File file=File(path+'/tt.json');
        String tt=await file.readAsString();
        Map tc=jsonDecode(tt);
        this.teaching=tc;
    }
    List timetable=this.teaching['timetable'];
    List my_tt=[];
  
    for (Map slt in timetable) {
      if(slt['teachers'].indexOf(title)>-1 && slt['day']==weekdays[day] ){
        my_tt.add(slt);
      }
    }
   return my_tt; 
   
    
  }

  void set_alarm(title,the_timetable) async{

    Map tt= the_timetable==null?await read_file('filename'):the_timetable;
    List timetable=tt['timetable'];
    List my_tt=[];
  
    for (Map slt in timetable) {
      if(slt['teachers'].indexOf(title)>-1 ){
        my_tt.add(slt);
      }
    }
    FlutterLocalNotificationsPlugin notifications=FlutterLocalNotificationsPlugin();
    await clear_alarm();
    var android_init=AndroidInitializationSettings('my_logo');
    var ios_init=IOSInitializationSettings();
    var all_init=InitializationSettings(android_init,ios_init);
    await notifications.initialize(all_init,);
    if(all_details['all_notifications']!=false){
      //for testing..................

      // var androidDetails=AndroidNotificationDetails(
      //    'hi', 'class alert', 'shows you when you have a class',
         
         
      //  );
      //  var iosDetails=IOSNotificationDetails();
      //  var allDetails=NotificationDetails(androidDetails,iosDetails);
      //   notifications.showWeeklyAtDayAndTime(0, 'title', 'Testing', Day(2), Time(14,58,0), allDetails);

    for(int i=0; i<my_tt.length;i++){  
      Map slot=my_tt[i];
       String the_time=times[slot['no']];
       List stime=the_time.split(':');
       Time time=Time(int.parse(stime[0]),int.parse(stime[1]),0);
       if(slot['day']=='mon'){
       }

       var androidDetails=AndroidNotificationDetails(
         i.toString(), 'class alert', 'shows you when you have a class',
         
       );
       var iosDetails=IOSNotificationDetails();
       var allDetails=NotificationDetails(androidDetails,iosDetails);
       Day the_day=days[weekdays.indexOf( slot['day'])];

       String duration=slot['double']==1?'1hr 20min':'40min';
      
       await notifications.showWeeklyAtDayAndTime(
         i, 'You have a class😊', 
         slot['subject']+' '+slot['form']+' '+slot['strm']+' ('+duration+')'
       ,the_day, time, allDetails);

   }

  
  
    }

  }

  void clear_alarm() async{
    FlutterLocalNotificationsPlugin notifications=FlutterLocalNotificationsPlugin();
    await notifications.cancelAll();


  }
}
   Future<Map> read_file(filename) async{
   Directory dir= await getApplicationDocumentsDirectory();
     String directory=dir.path;
     File file=File(directory+'/'+filename);
     String contents=await file.readAsString();
     Map data=jsonDecode(contents);
     return data;
  }



//duty roaster part
class Roaster{
  
Map this_week(Map roaster){

  List duty=roaster['roaster'];
  if(duty.length<1){
    return {'teachers':[],'week':0};
  }
  DateTime now=DateTime.now();
  int yar=now.year;
  List months=[0,31,yar%4==0?29:28,31,30,31,30,31,31,30,31,30,31];
     String duty_start=roaster['duty_start'];
        List starting=duty_start.split('-');
        int starting_days=0;
        int today_days=0;
       for(int i=1;i<(int.parse(starting[1])+1);i++){
           starting_days+=months[i];
       }
      
       starting_days+=int.parse(starting[2]);

       for(int i=1;i<(now.month+1);i++){
        today_days+=months[i];
    }
    today_days+=now.day;
    int passed_days=today_days-starting_days;
    int curr_week=(passed_days/7).floor()+1;

    for(int i=0;i<duty.length;i++){
      if(duty[i]['t_slot']==curr_week.toString()){
        Map wk=duty[i];
        List<String> tcrs=wk['teachers'].split(',');
        List teachers=tcrs.map((t){
          return {
            'name':t,
            'image':'assets/images/me.jpeg'
          };
        }).toList();

        return {'teachers':teachers,'week':curr_week};
      }
    }
    return {'teachers':[],'week':0};
  }



}