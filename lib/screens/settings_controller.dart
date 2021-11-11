import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'global.dart';

class SettingsController{
  SettingsController({
    this.all_details,
  });
  final all_details;
  Future<File> get_image(bool camera) async{
    var picker=ImagePicker();
    PickedFile picked_file=await picker.getImage(source:camera?ImageSource.camera:ImageSource.gallery,maxHeight: 600,maxWidth: 600);
    File image=File(picked_file.path);
    File cropped_file=await ImageCropper.cropImage(sourcePath:picked_file.path ,
    aspectRatio:CropAspectRatio(ratioX: 1,ratioY: 1),
    androidUiSettings: AndroidUiSettings(
      toolbarTitle: 'Schoolapp crop',
      toolbarColor: Colors.pink,
      toolbarWidgetColor: Colors.white

    )
    );

  var img=cropped_file.readAsBytesSync();
  File file=File(all_details['path']+'/teachers_images'+all_details['teacher_title']+'.png');
  await upload_image(img);
  file.writeAsBytesSync(img);
  

    return cropped_file;
  }

File my_image=File('');
Future load_image() async{
    this.my_image=File(all_details['path']+'/teachers_images'+all_details['teacher_title']+'.png');   
}

Future<Map> upload_image(bytes) async{
  Map data={
    'teacher_id':all_details['teacher_id'],
    'school_id':all_details['school_id'],
     'image':bytes
  };
  String url='/api/mobile/image/me';
  Map res= await send_data(data, url);
  return res;
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
      throw 'No such url';
    }
  }

  Future<bool> sign_out() async{
    File allDetails=File(all_details['path']+'/initial.json');
    File allFiles=File(all_details['path']+'/all_files.json');
    File logo=File(all_details['path']+'/logo.png');
    File me=File(all_details['path']+'/teachers_images'+all_details['teacher_title']+'.png');
    File tt=File(all_details['path']+'/tt.json'); 
    File roaster=File(all_details['path']+'/roaster.json');


    Map data={
    'teacher_id':all_details['teacher_id'],
    'school_id':all_details['school_id'],
    };
    String url='/api/mobile/sign_out';

    Map to_delete=await send_data(data, url);
    if(to_delete['accepted']==true){
    allDetails.delete();
    allFiles.delete();
    me.delete();
    logo.delete();
    roaster.delete();
    tt.delete();
    return true;
    }
    return false;
    
  }
      Future write_to_file(String data,String filename) async{
      Directory dir=await getApplicationDocumentsDirectory();
      String path=dir.path;
      File file=File(path+'/'+filename);
      await file.writeAsString(data);

    }
}