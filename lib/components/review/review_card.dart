import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:guc_swiss_knife/components/review/review_details.dart';
import 'package:guc_swiss_knife/components/utils/verified_check.dart';
import 'package:guc_swiss_knife/models/review.dart';
import 'package:guc_swiss_knife/models/user.dart';
import 'package:guc_swiss_knife/services/user_service.dart';
import '../../utils_functions/profile.dart';

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
        width: MediaQuery.of(context).size.width * 0.85,
        height: null,
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
              Widget header = _buildHeader(user);
              return InkWell(
                  onTap: () {
                    if (widget.review.review != null &&
                        widget.review.review!.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ReviewDetails(
                              review: widget.review, header: header);
                        },
                      );
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: header,
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
                                itemSize:
                                    MediaQuery.of(context).size.width * 0.05,
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
                      if (widget.review.review != null &&
                          widget.review.review!.isNotEmpty)
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

  Widget _buildHeader(User? user) {
    Widget userAvatar = generateAvatar(context, user!);

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          userAvatar,
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("${user.firstName} ${user.lastName}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (user.isPublisher) const VerifiedCheck(),
                ],
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(user.header ?? '',
                      style: const TextStyle(color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
        ],
      ),
    );
  }
}
