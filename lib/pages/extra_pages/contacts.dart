import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/utils/no_content.dart';
import 'package:guc_swiss_knife/configs/constants.dart';
import 'package:guc_swiss_knife/models/contact.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:guc_swiss_knife/services/contact_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils_functions/confirm_action.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  ContactService contactService = ContactService();
  late AuthProvider _authProvider;
  late bool isAdmin;
  @override
  void initState() {
    setState(() {
      _authProvider = Provider.of<AuthProvider>(context, listen: false);
      isAdmin = _authProvider.isAdmin;
    });
    super.initState();
  }

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
                          trailing: !isAdmin
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    ConfirmAction.showConfirmationDialog(
                                      context: context,
                                      onConfirm: () {
                                        contactService.deleteContact(
                                            snapshot.data![index].id ?? "");
                                      },
                                      title: 'Delete Contact',
                                      message:
                                          'Are you sure you want to delete this contact?',
                                      confirmButton: 'Delete',
                                    );
                                  },
                                ),
                          leading: SizedBox(
                            width: 50,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  IconData(
                                    snapshot.data![index].iconCodePoint,
                                    fontFamily:
                                        snapshot.data![index].iconFontFamily,
                                  ),
                                ),
                                Text(snapshot.data![index].name,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 8,
                                    )),
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
            floatingActionButton: !isAdmin
                ? null
                : FloatingActionButton(
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
    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    }
  }
}
