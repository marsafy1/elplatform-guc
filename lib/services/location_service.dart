import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/location.dart';

class LocationService {
  final String collectionName = "location";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<Location>> fetchLocations(String? searchTerm) {
    Stream<List<Location>> fetchedRequests = _firestore
        .collection(collectionName)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Location> locations = [];

      for (var doc in snapshot.docs) {
        Location location = Location.fromMap(doc.data(), doc.id);

        if (location.name.toString().contains(searchTerm.toString())) {
          locations.add(location);
        }
      }

      return locations;
    });
    return fetchedRequests;
  }

  // add new publish request
  Future<void> addLocation(Location Location) async {
    await _firestore.collection(collectionName).add(Location.toMap());
  }
}
