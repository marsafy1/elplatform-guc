import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/models/instructor_review.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:guc_swiss_knife/services/instructor_review_service.dart';
import 'package:guc_swiss_knife/utils_functions/confirm_action.dart';
import 'package:provider/provider.dart';

class InstructorCard extends StatelessWidget {
  InstructorReview instructorReview;
  InstructorCard({Key? key, required this.instructorReview}) : super(key: key);
  final InstructorReviewService _instructorReviewService =
      InstructorReviewService();
  @override
  Widget build(BuildContext context) {
    bool isAdmin = Provider.of<AuthProvider>(context, listen: false).isAdmin;
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
                      _instructorReviewService
                          .deleteInstructorReview(instructorReview.id!);
                    },
                    title: 'Delete Instructor',
                    message:
                        'Are you sure you want to delete ${instructorReview.firstName.toLowerCase()} ${instructorReview.lastName.toLowerCase()}?',
                    confirmButton: 'Delete',
                  );
                },
              ),
        leading: const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person),
        ),
        title: Text(
            "${instructorReview.firstName.toLowerCase()} ${instructorReview.lastName.toLowerCase()}"),
        subtitle: Text(
            "${isNotNumber(instructorReview.rating!) ? 5.0 : instructorReview.rating} ⭐"),
        onTap: () {
          Navigator.pushNamed(context, '/instructorDetails',
              arguments: instructorReview);
        },
      ),
    );
  }

  bool isNotNumber(num number) {
    return number.isNaN || number.isInfinite || number.isNegative;
  }
}
