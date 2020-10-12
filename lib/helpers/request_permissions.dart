import 'package:permission_handler/permission_handler.dart';

class RequestPermissions{

  static Future<Map<Permission, PermissionStatus>> requestPermissionsFor(List<Permission> permissions) async {
    return permissions.request();
  }
}