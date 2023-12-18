import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:guc_swiss_knife/services/user_service.dart';
import 'package:guc_swiss_knife/utils_functions/confirm_action.dart';
import 'package:provider/provider.dart';

class InstructorCard extends StatelessWidget {
  User instructor;
  InstructorCard({Key? key, required this.instructor}) : super(key: key);
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
                    onConfirm: () {},
                    title: 'Delete Instructor',
                    message:
                        'Are you sure you want to delete ${instructor.firstName.toLowerCase()} ${instructor.lastName.toLowerCase()}?',
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
            "${instructor.firstName.toLowerCase()} ${instructor.lastName.toLowerCase()}"),
        subtitle: Text(
            "${isNotNumber(instructor.rating!) ? 5.0 : instructor.rating} ⭐"),
        onTap: () {
          Navigator.pushNamed(context, '/instructorDetails',
              arguments: instructor);
        },
      ),
    );
  }

  bool isNotNumber(num number) {
    return number.isNaN || number.isInfinite || number.isNegative;
  }
}
