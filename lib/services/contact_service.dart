import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/contact.dart';

class ContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<Contact>> fetchContacts() {
    Stream<List<Contact>> fetchedContacts = _firestore
        .collection("contacts")
        .snapshots()
        .asyncMap((snapshot) async {
      List<Contact> contacts = [];
      for (var doc in snapshot.docs) {
        Contact contact = Contact.fromMap(doc.data(), doc.id);
        contacts.add(contact);
      }
      return contacts;
    });
    return fetchedContacts;
  }
}
