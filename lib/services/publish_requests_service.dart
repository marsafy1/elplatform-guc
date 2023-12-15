import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/publish_request.dart';

class PublishRequestsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<PublishRequest>> fetchPublishRequests() {
    Stream<List<PublishRequest>> fetchedRequests = _firestore
        .collection("publish_requests")
        .snapshots()
        .asyncMap((snapshot) async {
      List<PublishRequest> requests = [];
      for (var doc in snapshot.docs) {
        PublishRequest request = PublishRequest.fromMap(doc.data());
        requests.add(request);
      }
      return requests;
    });
    return fetchedRequests;
  }

  // approve publish request
  Future<void> approvePublishRequest(PublishRequest publishRequest) async {
    await _firestore
        .collection("publish_requests")
        .doc(publishRequest.id)
        .update({'approved': true});
    _firestore.collection("users").doc(publishRequest.userId).update({
      'is_publisher': true,
    });
  }

  // add new publish request
  Future<void> addPublishRequest(PublishRequest publishRequest) async {
    await _firestore.collection("publish_requests").add(publishRequest.toMap());
  }
}
