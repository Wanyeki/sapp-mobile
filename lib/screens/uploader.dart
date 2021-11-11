import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'global.dart';

class Uploader{

Uploader({this.all_details});

final all_details;

Future<Map> get_all() async{
    Map all_files=await read_file('all_files.json');
    return all_files;
}

void delete_file(filename,uploads) async{
        Map all_details={
          'teacher':'Wanyeki',
          'files':uploads,
          'teacher_id':this.all_details['teacher_id'],
           'school_id':this.all_details['school_id']
        };
        Directory dir=await getApplicationDocumentsDirectory();
        String path=dir.path;
        File file=File(path+'/'+filename);
        file.delete();
        write_to_file(all_details, 'all_files.json');
      
}

Future<Map> submit(filename,all_files) async{
Map file_data= await read_file(filename);
file_data['teacher_id']=this.all_details['teacher_id'];
file_data['school_id']=this.all_details['school_id'];
file_data['file_name']=filename;

all_files= all_files==null? await read_file('all_files.json'):all_files;
String url='/api/mobile/results/upload';
Map res= await send_data(file_data, url);
if(res['accepted']==true){
  for(int i=0;i<all_files['files'].length;i++){
     Map f=all_files['files'][i];
      if(f['filename']==filename){
        all_files['files'][i]['status']='Submitted';
      }
   }
   write_to_file(all_files, 'all_files.json');
}
return all_files;

}

Future<Map> create(subject,form,stream,paper,exam) async{
   String filename=subject+' '+form+' '+stream+' '+paper+' '+exam+'.json';
   
   Map all_files= await read_file('all_files.json');

   bool is_present(){
     for(int i=0;i<all_files['files'].length;i++){
     Map f=all_files['files'][i];
      if(f['filename']==filename){
        return true;
      }
   }
   return false;
   }

   if(is_present()){
     throw('is present');
   }else{
   Map file_data={
     'subject':subject,
     'form':form,
     'class':stream,
     'paper':paper,
     'exam':exam,
     'entries':[]
   };
   Map main_file_data={
     'filename':filename,
      "subject":subject,
      "form":form,
      "class":stream,
      "paper":paper,
      "exam":exam,
      "status":'Local'
   };
    all_files['files'].add(main_file_data);
   write_to_file(file_data, filename);
   write_to_file(all_files, 'all_files.json');

    return main_file_data;
   }
}


void create_main_file(teacher) async{
  Map data={
    'teacher':teacher,
    'files':[]
  };
  write_to_file(data, 'all_files.json');
}

 Future<Map>send_data(data,String url) async{
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

  Future write_to_file(Map data,String filename) async{
      Directory dir=await getApplicationDocumentsDirectory();
      String path=dir.path;
      File file=File(path+'/'+filename);
      String string_data=jsonEncode(data);
      await file.writeAsString(string_data);
      return true;

    }

   Future<Map> read_file(filename) async{
   Directory dir= await getApplicationDocumentsDirectory();
     String directory=dir.path;
     File file=File(directory+'/'+filename);
     String contents=await file.readAsString();
     Map data=jsonDecode(contents);
     return data;
  }

    Future make_local(filename) async{
     Map all_files=await read_file('all_files.json');
    for(int i=0;i<all_files['files'].length;i++){
     Map f=all_files['files'][i];
      if(f['filename']==filename){
        all_files['files'][i]['status']='Local';
      }
   }
   write_to_file(all_files, 'all_files.json');
   return true;
  }
}