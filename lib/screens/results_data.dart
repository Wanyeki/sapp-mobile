import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'global.dart';

class ResultData{

  ResultData({this.all_details});
  final all_details;
  Map exams;
  Map classes;

  Future load_items() async{
    this.exams= await read_file('exams.json');
    this.classes= await read_file('classes.json');
     return true;
  }
  Future<Map>get_subject(exam,subject,form) async{
     Map data={
       'exam':exam,
       'subject':subject,
       'form':form,
       'teacher_id':all_details['teacher_id'],
       'school_id':all_details['school_id']
     };
     String url='/api/mobile/results/subject';
     Map entries= await get_data(data, url);
     return entries;
   }
 Future<Map>search_school(String query) async{
   print('printer..........................');
     Map data={
       'query':query.toUpperCase(),
     };
     String url='/api/mobile/results/search_school';
     Map entries= await get_data(data, url);
     return entries;
   }
 Future<Map>get_school_data(school_name,subject,exam) async{
     Map data={
       'school_name':school_name,
       'subject':subject,
       'exam':exam,
       'teacher_id':all_details['teacher_id'],
       'school_id':all_details['school_id']
     };

     String url='/api/mobile/results/school_data';
     Map entries= await get_data(data, url);
     return entries;
   }


  Future<Map>get_individual(adm,term) async{
     Map data={
       'term':term,
       'adm':adm,
       'teacher_id':all_details['teacher_id'],
       'school_id':all_details['school_id']
     };
     String url='/api/mobile/results/individual';
     Map entries= await get_data(data, url);
     return entries;
   } 


  Future<Map>get_ranking(subject,exam) async{
     Map data={
       'exam':exam,
       'subject':subject,
       'teacher_id':all_details['teacher_id'],
       'school_id':all_details['school_id']
     };
     String url='/api/mobile/results/ranking';
     Map entries= await get_data(data, url);
     return entries;
   }

   Future<Map>get_class(exam,form,stream) async{
     Map data={
       'form':form,
       'stream':stream,
       'exam':exam,
       'teacher_id':all_details['teacher_id'],
       'school_id':all_details['school_id']
     };
     String url='/api/mobile/results/class';
     Map entries= await get_data(data, url);
     return entries;
   }


  Future<Map>get_data(data,String url) async{
    http.Response res=await http.post(Global.server+url,
      headers: {
        'Content-Type':'application/json; charset=UTF-8'
      },
      body: jsonEncode(data)
    );
    if(res.statusCode==200){
      return jsonDecode(res.body);
    }else{
      return {};
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
}