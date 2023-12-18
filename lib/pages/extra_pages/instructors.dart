import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/instructor_card.dart';
import 'package:guc_swiss_knife/components/utils/no_content.dart';
import 'package:guc_swiss_knife/configs/constants.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:guc_swiss_knife/services/instructor_service.dart';
import 'package:provider/provider.dart';

class Instructors extends StatefulWidget {
  const Instructors({super.key});

  @override
  State<Instructors> createState() => _InstructorsState();
}

class _InstructorsState extends State<Instructors> {
  late AuthProvider _authProvider;
  late bool isAdmin;

  @override
  void initState() {
    setState(() {
      _authProvider = Provider.of<AuthProvider>(context, listen: false);
      isAdmin = _authProvider.isAdmin;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;

    return StreamBuilder(
      stream: InstructorService.fetchInstructors(),
      builder: (context, AsyncSnapshot<List<User>> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("$appName - Instructors"),
            ),
            body: SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: SearchAnchor.bar(
                    barHintText: 'Search instructors',
                    suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                      return getSuggestions(controller, snapshot.data!);
                    },
                  ),
                ),
                snapshot.data!.isEmpty
                    ? const NoContent(text: "No Data Available")
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8 -
                            keyBoardHeight,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          itemBuilder: (context, index) {
                            return InstructorCard(
                              instructor: snapshot.data![index],
                            );
                          },
                        ),
                      )
              ]),
            ),
            floatingActionButton: !isAdmin
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/addInstructor');
                    },
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add),
                  ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Iterable<Widget> getSuggestions(
      SearchController controller, List<User> instructors) {
    final String input = controller.value.text.toLowerCase();
    return instructors
        .where((User instructor) =>
            instructor.firstName.toLowerCase().contains(input) ||
            instructor.lastName.toLowerCase().contains(input) ||
            ("${instructor.firstName.toLowerCase()} ${instructor.lastName.toLowerCase()}")
                .contains(input))
        .map(
          (User filteredInstructor) =>
              InstructorCard(instructor: filteredInstructor),
        );
  }

  void handleSelection(User selectedCourse) {
    Navigator.of(context)
        .pushNamed('/instructorDetails', arguments: {'course': selectedCourse});
  }
}
