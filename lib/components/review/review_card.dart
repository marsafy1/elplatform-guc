import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guc_swiss_knife/models/review.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/services/user_service.dart';

class ReviewCard extends StatefulWidget {
  final Review review;
  const ReviewCard({super.key, required this.review});
  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  late Future<User> futureUser;
  @override
  void initState() {
    super.initState();
    futureUser = UserService.getUserById(widget.review.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: FutureBuilder(
          future: futureUser,
          builder: (context, AsyncSnapshot<User> snapshot) {
            if (true) {
              return const SizedBox(
                  width: 10, child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              User? user = snapshot.data;

              return Column(
                children: [
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user!.photoUrl),
                        maxRadius: 25,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(
                            '${user.firstName} ${user.lastName}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: RatingBar.builder(
                            initialRating: widget.review.rating!.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 15,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ),
                      ],
                    )
                  ]),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      widget.review.review,
                      maxLines: 3,
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
