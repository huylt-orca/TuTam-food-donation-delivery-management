import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/post_list.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/post/comment_dialog.dart';

class PostDetailScreen extends StatelessWidget {
  final PostList post;
  const PostDetailScreen({
    super.key,
    required this.post
    });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết bài đăng'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(post.createBy.avatar),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.createBy.fullName,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Utils.convertDateToTimeDateVN(post.createdDate),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
                ],
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  post.content,
                  style: const TextStyle(fontSize: 12),
                  softWrap: true,
                ),
              ),
              const Divider(),
              Padding(
              padding: const EdgeInsets.all(8.0),
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
                      onTap: (){
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return CommentDialog(postId: post.id);
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

            
            const Divider(thickness: 4, height: 4,),
            post.images.isEmpty ? const SizedBox() :
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: post.images.length,
              itemBuilder: (context,index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 2.0),
                  child: Image.network(
                      post.images[index],
                      fit: BoxFit.cover,
                    ),
                );
              }
              ),
            ],
          ),
        ),
      ),
    );
  }
}