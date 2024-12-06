import 'package:flutter_apps/services/google_map_service.dart';

class TemplateUtil {
  static GoogleMapService googleMapService = GoogleMapService();
  
  static Future<String> defaultTemplate() async {
    return await googleMapService.getAddressDetails();
  }
}
