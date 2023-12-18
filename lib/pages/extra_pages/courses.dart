import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/utils/no_content.dart';
import 'package:guc_swiss_knife/configs/constants.dart';
import 'package:guc_swiss_knife/models/course.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:guc_swiss_knife/services/course_service.dart';
import 'package:provider/provider.dart';
import '../../components/course/course_card.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
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

  final CourseService instructorReviewService = CourseService();
  @override
  Widget build(BuildContext context) {
    var keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;

    return StreamBuilder(
      stream: CourseService.getCourses(),
      builder: (context, AsyncSnapshot<List<Course>> snapshot) {
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
                            return CourseCard(
                              course: snapshot.data![index],
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
                      Navigator.of(context).pushNamed('/addCourse');
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
      SearchController controller, List<Course> courses) {
    final String input = controller.value.text.toLowerCase();
    return courses
        .where((Course course) => course.title.toLowerCase().contains(input))
        .map(
          (Course filteredCourse) => CourseCard(course: filteredCourse),
        );
  }

  void handleSelection(Course selectedCourse) {
    Navigator.of(context)
        .pushNamed('/courseDetails', arguments: {'instructor': selectedCourse});
  }
}
