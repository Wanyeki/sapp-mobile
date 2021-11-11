import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:schoolapp_x/screens/teaching_tt.dart';

import 'global.dart';

class Updates{
  Updates({this.all_details});
  final all_details;
  Future any_updates() async{
    http.Response res= await http.get(Global.server+'/api/mobile/any_update',headers:{'teacher_id':all_details['teacher_id'],'school_id':all_details['school_id']});
      String body=res.body;
      Map updates=jsonDecode(body);
      try{
      updates['teaching_tt']?await this.update_teaching_tt():false;
      updates['duty']?await this.update_roaster():false;
      updates['exams']?await this.update_exams():false;
      updates['main']?await this.update_main():false;
      updates['classes']?await this.update_classes():false;
      // updates['avatars']?await this.update_avatars():false;
      }catch(e){
        print(e);
      }

      return true;

  }
  Future update_avatars() async{
   String url='/api/mobile/get_avatars';
   Directory dir=await getApplicationDocumentsDirectory();
   String path=dir.path;
   Map data={
     'teacher_id':all_details['teacher_id'],
     'school_id':all_details['school_id']
   };
      String avat=await send_data(data, url);
      Map avatars=jsonDecode(avat);
      avatars['avatars'].forEach((av){
        if(av['title']!=null){
          File file=File(path+'/teachers_images'+av['title']);
          file.writeAsBytesSync( List<int>.from(av['data']['data']));
        }
      });
      
    }
  Future update_teaching_tt() async{
     Map data={
      'teacher_id':all_details['teacher_id'],
       'school_id':all_details['school_id']
    };
    String url='/api/mobile/get_teaching';
    String body= await send_data(data, url);
    write_to_file(body, 'tt.json');
    var the_tt=Teaching_tt(all_details: all_details);
    await the_tt.set_alarm(all_details['teacher_title'], jsonDecode(body));
    }
  Future update_main() async{
     Map data={
      'teacher_id':all_details['teacher_id'],
       'school_id':all_details['school_id']
    };
    String url='/api/mobile/get_main';
    String body= await send_data(data, url);
    write_to_file(body, 'initial.json');
   
    }
  Future update_roaster() async{
       Map data={
      'teacher_id':all_details['teacher_id'],
       'school_id':all_details['school_id']
    };
    String url='/api/mobile/get_roaster';
    String body= await send_data(data, url);
    write_to_file(body, 'roaster.json');
  }
    Future update_exams() async{
      Map data={
          'teacher_id':all_details['teacher_id'],
          'school_id':all_details['school_id']
        };
        String url='/api/mobile/get_exams';
        String body= await send_data(data, url);
        write_to_file(body, 'exams.json');
  }
    Future update_classes() async{
        Map data={
          'teacher_id':all_details['teacher_id'],
          'school_id':all_details['school_id']
      };
      String url='/api/mobile/get_classes';
      String body= await send_data(data, url);
      write_to_file(body, 'classes.json');
  }

 Future<String>send_data(data,String url) async{
    http.Response res=await http.post(Global.server+url,
      headers: {
        'Content-Type':'application/json; charset=UTF-8'
      },
      body: jsonEncode(data)
    );
    if(res.statusCode==200){
      return res.body;
    }else{
      return '{}';
    }
  }
    Future write_to_file(String data,String filename) async{
      Directory dir=await getApplicationDocumentsDirectory();
      String path=dir.path;
      File file=File(path+'/'+filename);
      await file.writeAsString(data);

    }

}