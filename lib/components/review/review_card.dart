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
      child: FutureBuilder(
        future: futureUser,
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            User? user = snapshot.data;
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl),
              ),
              title: Text(user.firstName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.review.review),
                  RatingBar.builder(
                    initialRating: widget.review.rating!.toDouble(),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 20,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
