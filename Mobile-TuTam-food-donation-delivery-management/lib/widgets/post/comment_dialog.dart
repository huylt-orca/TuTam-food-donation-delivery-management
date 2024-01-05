import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/comment_list.dart';
import 'package:food_donation_delivery_app/services/comment_service.dart';
import 'package:food_donation_delivery_app/widgets/post/comment_card.dart';
import 'package:food_donation_delivery_app/widgets/post/shimmer_comment_card.dart';

class CommentDialog extends StatefulWidget {
  final String postId;
  const CommentDialog({super.key, required this.postId});

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final _scrollController = ScrollController();
  List<CommentList> _comments = List.empty(growable: true);
  final TextEditingController _txtComment = TextEditingController();
  int _page = 1;
  bool _isLoading = true;
  bool _isRefresh = true;

  void _getData() {
    CommentService.fetchCommentList(postId: widget.postId).then((data) {
      _comments = data;
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _page++;
      CommentService.fetchCommentList(page: _page, postId: widget.postId)
          .then((data) {
        setState(() {
          _comments.addAll(data);
        });
      });
    }
  }

  void _postComment() async {
    if (_txtComment.text.isNotEmpty) {
      bool isSuccess = await CommentService.postComment(
          postId: widget.postId, content: _txtComment.text);
      if (isSuccess){
      _txtComment.text = '';
      _getData();
      setState(() {
        _isRefresh = !_isRefresh;
      });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _isLoading ? 4 : _comments.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: _isLoading
                      ? const ShimmerCommentCard()
                      : CommentCard(comment: _comments[index]),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.07,
              color: Colors.white,
              padding: const EdgeInsets.all(4.0),
              child: TextField(
                controller: _txtComment,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(width: 0.8),
                  ),
                  hintText: 'Bình luận',
                  suffixIcon: IconButton(
                      onPressed: () {
                        // close keyboard
                        FocusScope.of(context).unfocus();
                        _postComment();
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      icon: Icon(
                        Icons.near_me,
                        color: Colors.grey.shade700,
                      )),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
