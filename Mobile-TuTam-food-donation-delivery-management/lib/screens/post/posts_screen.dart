import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/post_list.dart';
import 'package:food_donation_delivery_app/services/post_service.dart';
import 'package:food_donation_delivery_app/widgets/post/post_card.dart';
import 'package:food_donation_delivery_app/widgets/post/shimmer_post_card.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {

  final _scrollController = ScrollController();
  List<PostList> _posts = List.empty(growable: true);
  int _page = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    PostService.fetchPostList().then((value) {
        _posts = value;
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _page++;
      PostService.fetchPostList(page: _page,)
          .then((data) {
        setState(() {
          _posts.addAll(data);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Danh sách bài đăng'),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _isLoading ? 3 : _posts.length,
            itemBuilder: (context, index) {
              return _isLoading ? const ShimmerPostCard()
              : PostCard(post: _posts[index],);
            }, 
            separatorBuilder: (BuildContext context, int index) { 
              return Divider(color: Colors.grey.shade500, thickness: 4,);
             },
          )
        ],
      ),
    ),
      ),
    );
  }
}