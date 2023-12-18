import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guc_swiss_knife/components/utils/no_content.dart';
import 'package:guc_swiss_knife/configs/constants.dart';
import 'package:guc_swiss_knife/models/location.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:guc_swiss_knife/services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  LocationService locationService = LocationService();
  final StreamController<String> _searchController = StreamController<String>();
  late Stream<List<Location>> _locationsStream;
  late bool isAdmin;

  @override
  void initState() {
    _locationsStream = _searchController.stream.switchMap((searchTerm) {
      return locationService.fetchLocations(searchTerm);
    });
    isAdmin = Provider.of<AuthProvider>(context, listen: false).isAdmin;
    _searchController.add("");
    super.initState();
  }

  @override
  void dispose() {
    _searchController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("$appName - Navigation"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                width: 310.0, // Adjust the width as needed
                height: 60.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(25.0), // Set the background color
                ),
                child: Card(
                  elevation: 2.0,
                  child: TextField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      border: InputBorder.none, // Remove the default border
                      label: Text("Search Locations"),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) => _searchController.add(value),
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: _locationsStream,
              builder: (context, AsyncSnapshot<List<Location>> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.isEmpty
                      ? const NoContent(text: "No Data Available")
                      : SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  // delete
                                  trailing: !isAdmin
                                      ? null
                                      : IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () async {
                                            locationService.deleteLocation(
                                                snapshot.data![index].id ?? "");
                                          },
                                        ),
                                  leading: const SizedBox(
                                    width: 50,
                                    child: Icon(Icons.location_on),
                                  ),
                                  title: Text(snapshot.data![index].name ?? "",
                                      overflow: TextOverflow.ellipsis),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        '/locationDetails',
                                        arguments: snapshot.data![index]);
                                  },
                                ),
                              );
                            },
                          ),
                        );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/gucMap');
            },
            shape: const CircleBorder(),
            tooltip: "GUC Map",
            heroTag: null,
            child: const FaIcon(FontAwesomeIcons.mapLocation),
          ),
          if (isAdmin) ...[
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/addLocation');
              },
              shape: const CircleBorder(),
              heroTag: null,
              child: const Icon(Icons.add),
            ),
          ]
        ],
      ),
    );
  }
}
