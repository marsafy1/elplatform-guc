import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guc_swiss_knife/components/review/review_details.dart';
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

//get screen width
  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.2,
        child: FutureBuilder(
          future: futureUser,
          builder: (context, AsyncSnapshot<User> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.height * 0.1,
                  child: const CircularProgressIndicator(
                    strokeWidth: 5.0,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              User? user = snapshot.data;

              return InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ReviewDetails(review: widget.review, user: user);
                      },
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(user!.photoUrl ?? ""),
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 2, top: 2),
                                  child: Text(
                                    user.bio ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                              child: RatingBar.builder(
                                initialRating: widget.review.rating.toDouble(),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 0.1),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {},
                                ignoreGestures: true,
                              ),
                            ),
                          ]),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.review.review ?? "",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ));
            }
          },
        ),
      ),
    );
  }
}
