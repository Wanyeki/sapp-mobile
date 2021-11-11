
import 'package:flutter/material.dart';
import 'package:schoolapp_x/screens/duty_roaster/duty_roaster.dart';
import 'package:schoolapp_x/screens/landing/landing_screen.dart';
import 'package:schoolapp_x/screens/landing/sign_in.dart';
import 'package:schoolapp_x/screens/mainscreen/main_page.dart';
import 'package:schoolapp_x/screens/result_screens/class_result.dart';
import 'package:schoolapp_x/screens/result_screens/individual_result.dart';
import 'package:schoolapp_x/screens/result_screens/other_school.dart';
import 'package:schoolapp_x/screens/result_screens/ranking_results.dart';
import 'package:schoolapp_x/screens/result_screens/subject_result.dart';
import 'package:schoolapp_x/screens/settings/settings_screen.dart';
import 'package:schoolapp_x/screens/upload_screen/edit_upload.dart';
import 'package:schoolapp_x/screens/upload_screen/upload_screen.dart';

import 'main.dart';
class RouteGenerator{
  static Route<dynamic> generateRoutes(RouteSettings settings){
    
    final Map args=settings.arguments;
    switch(settings.name){
      case '/':
      return MaterialPageRoute(builder: (_)=>Bait());
      break;
      case '/upload':
      return MaterialPageRoute(builder: (_)=>UploadScreen(all_details: args['all_details'],));
      break;
      case '/class_p':
      return MaterialPageRoute(builder: (_)=>ClassResults(resultData:args['resultData']));
      break;
       case '/individual_p':
      return MaterialPageRoute(builder: (_)=>IndividualResults(resultData:args['resultData']));
      break;
       case '/others_p':
      return MaterialPageRoute(builder: (_)=>OtherSchools(resultData:args['resultData'],all_details:args['all_details'],school: args['school'],));
      break;
       case '/subject_p':
      return MaterialPageRoute(builder: (_)=>SubjectResults(resultData:args['resultData']));
      break;
       case '/roaster':
      return MaterialPageRoute(builder: (_)=>DutyRoaster(get_weekdays: args['get_weekdays'],get_days: args['get_days'],roaster: args['roaster'],week: args['week'],all_details:args['all_details']));
      break;
      case '/ranking_p':
      return MaterialPageRoute(builder: (_)=>Rankings(resultData:args['resultData'],all_details: args['all_details']));
      break;
      case '/settings':
      return MaterialPageRoute(builder: (_)=>Settings(all_details:args['all_details'],image: args['image'],home_image:args['home_image']));
      break;
      case '/landing':
      return MaterialPageRoute(builder: (_)=>Landing());
      break;
       case '/main':
      return MaterialPageRoute(builder: (_)=>MainPage(all_details: args['all_details'],roaster:args['roaster']));
      break;
      case '/login':
      return MaterialPageRoute(builder: (_)=>SignIn());
      break;
      case '/edit_upload':
      return MaterialPageRoute(builder: (_)=>EditUpload(title: args['title'],subtitle: args['subtitle'],update_all_files:args['update_all_files'],all_details: args['all_details'],));
      break;
    }
  }


}