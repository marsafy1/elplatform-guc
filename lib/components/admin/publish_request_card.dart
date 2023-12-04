import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/models/publish_request.dart';
import 'package:intl/intl.dart';

class PublishRequestCard extends StatelessWidget {
  final PublishRequest publishRequest;

  PublishRequestCard({
    required this.publishRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person),
        ),
        trailing: Text(
          getFormattedDateTime(publishRequest.createdAt),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 7),
        ),
        title: Text(publishRequest.title),
        subtitle: Text(
          publishRequest.content,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamed('/publishRequestDetails', arguments: publishRequest);
        },
      ),
    );
  }

  String getFormattedDateTime(DateTime dateTime) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    return '$formattedDate \n $formattedTime';
  }
}
