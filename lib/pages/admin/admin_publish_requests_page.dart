import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/admin/publish_request_card.dart';
import 'package:guc_swiss_knife/components/app_bar_widget.dart';
import 'package:guc_swiss_knife/components/drawer_widget.dart';
import 'package:guc_swiss_knife/models/publish_request.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:guc_swiss_knife/services/publish_requests_service.dart';
import 'package:provider/provider.dart';

class AdminPublishRequests extends StatefulWidget {
  const AdminPublishRequests({super.key});

  @override
  State<AdminPublishRequests> createState() => _AdminPublishRequestsState();
}

class _AdminPublishRequestsState extends State<AdminPublishRequests> {
  final PublishRequestsService _publishRequestsService =
      PublishRequestsService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _publishRequestsService.fetchPublishRequests(),
        builder: (context, AsyncSnapshot<List<PublishRequest>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: MyAppBar(),
              drawer: const MainDrawer(),
              // generate list of cards in the body
              body: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return snapshot.data![index].approved != 0
                      ? null
                      : PublishRequestCard(
                          publishRequest: snapshot.data![index],
                        );
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
