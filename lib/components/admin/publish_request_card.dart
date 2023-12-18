import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/models/publish_request.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/services/user_service.dart';
import 'package:guc_swiss_knife/utils_functions/profile.dart';
import 'package:intl/intl.dart';

class PublishRequestCard extends StatefulWidget {
  final PublishRequest publishRequest;

  PublishRequestCard({
    required this.publishRequest,
  });

  @override
  State<PublishRequestCard> createState() => _PublishRequestCardState();
}

class _PublishRequestCardState extends State<PublishRequestCard> {
  User? user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  void _fetchUser() {
    UserService.getUserById(widget.publishRequest.userId).then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: generateAvatar(context, user ?? User.defaultUser),
        trailing: Text(
          getFormattedDateTime(widget.publishRequest.createdAt),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 7),
        ),
        title: Text(widget.publishRequest.title),
        subtitle: Text(
          widget.publishRequest.content,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/publishRequestDetails', arguments: {
            "publish_request": widget.publishRequest,
            "user": user
          });
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
