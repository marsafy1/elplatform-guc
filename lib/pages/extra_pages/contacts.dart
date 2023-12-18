import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/utils/no_content.dart';
import 'package:guc_swiss_knife/configs/constants.dart';
import 'package:guc_swiss_knife/models/contact.dart';
import 'package:guc_swiss_knife/services/contact_service.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  ContactService contactService = ContactService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: contactService.fetchContacts(),
      builder: (context, AsyncSnapshot<List<Contact>> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("$appName - Contacts"),
            ),
            body: snapshot.data!.isEmpty
                ? const NoContent(text: "No Data Available")
                : ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              contactService.deleteContact(
                                  snapshot.data![index].id ?? "");
                            },
                          ),
                          leading: SizedBox(
                            width: 50,
                            child: Column(
                              children: [
                                Icon(
                                  IconData(
                                    snapshot.data![index].iconCodePoint,
                                    fontFamily:
                                        snapshot.data![index].iconFontFamily,
                                  ),
                                ),
                                Text(
                                  snapshot.data![index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          title: Text(snapshot.data![index].phoneNumber),
                          onTap: () {
                            makePhoneCall(snapshot.data![index].phoneNumber);
                          },
                        ),
                      );
                    },
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/addContact');
              },
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void makePhoneCall(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: phoneNumber);
    print(phoneLaunchUri);
    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    } else {
      print('Could not launch $phoneNumber');
    }
  }
}
