import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/instructor_card.dart';
import 'package:guc_swiss_knife/configs/constants.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/services/instructor_service.dart';

class Instructors extends StatefulWidget {
  const Instructors({super.key});

  @override
  State<Instructors> createState() => _InstructorsState();
}

class _InstructorsState extends State<Instructors> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: InstructorService.fetchInstructors(),
      builder: (context, AsyncSnapshot<List<User>> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("$appName - Instructors"),
            ),
            body: snapshot.data!.isEmpty
                ? const Center(child: Text("No Data Available"))
                : ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return InstructorCard(
                        instructor: snapshot.data![index],
                      );
                    },
                  ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
