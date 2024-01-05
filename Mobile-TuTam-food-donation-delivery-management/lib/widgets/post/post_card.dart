import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/post_list.dart';
import 'package:food_donation_delivery_app/screens/post/post_detail_screen.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/indicator.dart';
import 'package:food_donation_delivery_app/widgets/post/comment_dialog.dart';


class PostCard extends StatefulWidget {
  final PostList post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int _selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(post: widget.post,),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1.0),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.post.createBy.avatar),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.createBy.fullName,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            Utils.convertDateToTimeDateVN(widget.post.createdDate),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    widget.post.content,
                    style: const TextStyle(fontSize: 12),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4,),
            widget.post.images.isEmpty ?  const SizedBox() :
            SizedBox(
              height: 170,
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _selectedImage = index;
                  });
                },
                controller: PageController(viewportFraction: 1),
                itemCount: widget.post.images.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.post.images[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            widget.post.images.length < 2  ?  const SizedBox() :
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                      widget.post.images.length,
                      (index) => Indicator(
                            isActive: _selectedImage == index ? true : false,
                          ))
                ],
              ),
            ),

            const Divider(height: 0, thickness: 0.5, indent: 10, endIndent: 10,),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  // const Expanded(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Icon(
                  //         Icons.favorite,
                  //         color: AppTheme.primarySecond,
                  //         size: 20,
                  //       ),
                  //       Text(
                  //         ' 100',
                  //         style: TextStyle(color: AppTheme.primarySecond),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return CommentDialog(postId: widget.post.id);
                          },
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.comment, color: Colors.black54),
                          Text(
                            ' Bình luận',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
