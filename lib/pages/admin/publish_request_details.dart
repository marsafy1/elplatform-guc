import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/app_bar_widget.dart';
import 'package:guc_swiss_knife/models/publish_request.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/services/publish_requests_service.dart';
import 'package:guc_swiss_knife/utils_functions/profile.dart';

class PublishRequestsDetails extends StatelessWidget {
  const PublishRequestsDetails({super.key});
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    User user = args['user'] as User;

    PublishRequest publishRequest = args['publish_request'] as PublishRequest;

    PublishRequestsService publishRequestsService = PublishRequestsService();

    const sizedBoxSpaceV = SizedBox(
      height: 30,
    );
    const sizedBoxSpaceH = SizedBox(
      width: 30,
    );
    return Scaffold(
      appBar: MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: generateAvatar(context, user),
                title: Text(
                  user.firstName,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: const Text("Publish Request"),
              ),
            ),
            sizedBoxSpaceV,
            const Text(
              'Message',
              style: TextStyle(fontSize: 18.0),
            ),
            Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SingleChildScrollView(
                child: Text(
                  publishRequest!.content,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            sizedBoxSpaceV,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.green,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      publishRequestsService
                          .approvePublishRequest(publishRequest);
                      Navigator.pop(context);
                    },
                  ),
                ),
                sizedBoxSpaceH,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.red,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      publishRequestsService
                          .declinePublishRequest(publishRequest);
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
