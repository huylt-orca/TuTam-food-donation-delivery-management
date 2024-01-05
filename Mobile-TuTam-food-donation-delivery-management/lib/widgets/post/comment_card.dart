import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/models/comment_list.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';

class CommentCard extends StatelessWidget {
  final CommentList comment;

  const CommentCard({
    super.key,
    required  this.comment,
  }) ;


  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(backgroundImage:  NetworkImage(comment.image)),
        const SizedBox(width: 10,),
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.greyBackground,
              borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                ),
                Text(comment.content)
              ],
            ),
          ),
          Text('● ${Utils.convertDateToTimeDateVN(comment.createdDate)}',
          style: const TextStyle(
            fontSize: 10
          ),
          )
        ],
      ),
      ],
    );
  }
}