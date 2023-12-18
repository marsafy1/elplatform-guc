import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/instructor/instructor_reviews.dart';
import 'package:guc_swiss_knife/models/instructor_review.dart';
import 'package:guc_swiss_knife/utils_functions/profile.dart';

class InstructorDetails extends StatelessWidget {
  const InstructorDetails({super.key});

  @override
  Widget build(BuildContext context) {
    InstructorReview instructorReview =
        ModalRoute.of(context)!.settings.arguments as InstructorReview;

    return Scaffold(
        appBar: AppBar(
          title: Text(instructorReview.firstName),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _header(context, instructorReview),
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoTile('Email', instructorReview.email),
                  InstructorReviews(
                      reviews: instructorReview.reviews!,
                      instructorId: instructorReview.id ?? " ")
                ],
              )
            ],
          ),
        ));
  }

  Widget _header(BuildContext context, InstructorReview instructorReview) {
    return Column(
      children: [
        const SizedBox(height: 20),
        generateColoredAvatar(
          avatarChar: instructorReview.firstName.characters.first,
          radius: 50,
        ),
        const SizedBox(height: 20),
        Text(
          "${instructorReview.firstName} ${instructorReview.lastName}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "${StringUtils.capitalize("instructor")} @ ${instructorReview.faculty ?? "GUC"}",
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
