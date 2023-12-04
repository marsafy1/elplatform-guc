import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/admin/publish_request_card.dart';
import 'package:guc_swiss_knife/components/app_bar_widget.dart';
import 'package:guc_swiss_knife/components/drawer_widget.dart';
import 'package:guc_swiss_knife/models/publish_request.dart';

class AdminPublishRequests extends StatelessWidget {
  const AdminPublishRequests({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        drawer: const MainDrawer(),
        // generate list of cards in the body
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return PublishRequestCard(
              publishRequest: PublishRequest(
                title: 'title',
                content: 'content',
                tags: ['tag1', 'tag2'],
              ),
            );
          },
        ));
  }
}
