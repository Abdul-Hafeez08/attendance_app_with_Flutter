/*import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  late LocationData _locData;
  Future<void> initialize() async {
    bool _serviceEnable;
    PermissionStatus _permission;
    _serviceEnable = await location.serviceEnabled();
    if (!_serviceEnable) {
      _serviceEnable = await location.serviceEnabled();
      if (!_serviceEnable) {
        return;
      }
    }
    _permission = await location.hasPermission();
    if (_permission == PermissionStatus.denied) {
      _permission = await location.requestPermission();
      if(_permission == PermissionStatus.granted){
        return;
      }
    }
  }
}
*/
