import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guc_swiss_knife/models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: InkWell(
        onTap: () => Navigator.of(context)
            .pushNamed('/courseDetails', arguments: {'id': course.id}),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
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
            CourseCardDetails(course: course)
          ],
        ),
      ),
    );
  }
}

class CourseCardDetails extends StatelessWidget {
  final Course course;
  const CourseCardDetails({required this.course, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 5),
            child: Text(
              course.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            )),
        RatingBar.builder(
          initialRating: 3.5,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemSize: 15,
          onRatingUpdate: (_) {},
          ignoreGestures: true,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          width: MediaQuery.of(context).size.width - 140,
          child: const Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
            style: TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.left,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
