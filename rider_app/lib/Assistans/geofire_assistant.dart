import 'package:rider_app/Models/nearby_available_drivers.dart';

class GeofireAssistant {
  static List<NearbyAvailableDrivers> nearbyAvailableDriversList = [];

  static void removeDriverFromList(String key) {
    int index = nearbyAvailableDriversList.indexWhere((element) => element.key == key);
    nearbyAvailableDriversList.removeAt(index);
  }

  static void updatDriverNearbyLocation(NearbyAvailableDrivers driver) {
    int index = nearbyAvailableDriversList.indexWhere((element) => element.key == driver.key);
    nearbyAvailableDriversList[index].latitude = driver.latitude;
    nearbyAvailableDriversList[index].longitude = driver.longitude;
  }
}