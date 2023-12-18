import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guc_swiss_knife/models/course.dart';
import 'package:guc_swiss_knife/providers/auth_provider.dart';
import 'package:guc_swiss_knife/services/course_service.dart';
import 'package:guc_swiss_knife/utils_functions/confirm_action.dart';
import 'package:provider/provider.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({
    Key? key,
    required this.course,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isAdmin = Provider.of<AuthProvider>(context, listen: false).isAdmin;

    return Card(
      margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CircularProgressIndicator(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: FadeInImage(
                      placeholder: const AssetImage('assets/Empty.png'),
                      image: NetworkImage(course.photoUrl),
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBar.builder(
                            initialRating: course.averageRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemSize: 15,
                            onRatingUpdate: (_) {},
                            ignoreGestures: true,
                          ),
                          Text(
                            course.description,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.left,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]),
                  ],
                ),
              ),
            ),
            if (isAdmin)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    ConfirmAction.showConfirmationDialog(
                      context: context,
                      onConfirm: () {
                        CourseService.deleteCourse(course.id);
                      },
                      title: 'Delete Course',
                      message: 'Are you sure you want to delete this course?',
                      confirmButton: 'Delete',
                    );
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
