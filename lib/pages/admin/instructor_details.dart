import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/instructor/instructor_reviews.dart';
import 'package:guc_swiss_knife/models/user.dart';

import '../../utils_functions/profile.dart';

class InstructorDetails extends StatelessWidget {
  const InstructorDetails({super.key});

  @override
  Widget build(BuildContext context) {
    User instructor = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
        appBar: AppBar(
          title: Text(instructor.firstName),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _header(context, instructor),
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoTile('Email', instructor.email),
                  if (instructor.gucId != null)
                    _buildInfoTile('GUC ID', instructor.gucId!),
                  _buildInfoTile(
                      'Publisher', instructor.isPublisher ? 'Yes' : 'No'),
                  _buildInfoTile('Bio', instructor.bio ?? ''),
                  InstructorReviews(
                      reviews: const [], instructorId: instructor.id)
                ],
              )
            ],
          ),
        ));
  }

  Widget _header(BuildContext context, User user) {
    return Column(
      children: [
        generateAvatar(context, user, radius: 100, isClickable: false),
        const SizedBox(height: 20),
        Text(
          "${user.firstName} ${user.lastName}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "${StringUtils.capitalize(user.userType.toShortString())} @ ${user.faculty ?? "GUC"}",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          user.header ?? "",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  ListTile _buildInfoTile(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
