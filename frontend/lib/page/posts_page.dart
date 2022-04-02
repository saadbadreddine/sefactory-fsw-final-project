import 'package:flutter/material.dart';
import 'package:hustle_app/utils/storage.dart';
import 'package:hustle_app/widget/appbar_widget.dart';
import 'package:hustle_app/widget/post_card_widget.dart';

import '../api/post_service.dart';
import '../model/post_model.dart';
import '../model/sport_model.dart';
import '../model/user_model.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  PostService postService = PostService();

  List<Post> posts = [];
  List<User> users = [];
  List<Sport> sports = [];

  Future getPosts() async {
    int i = 0;
    GetPostsResponse postResponse = await postService.getPosts(jwtToken!);
    posts.clear();
    users.clear();
    posts.clear();
    for (var element in postResponse.data) {
      {
        posts.add(Post.fromJson(element));
        User newUser = User.fromJson(posts[i].user);
        users.add(newUser);
        Sport newSport = Sport.fromJson(posts[i].sport);
        sports.add(newSport);
        i++;
      }
    }

    return posts;
  }

  Future getUsers() async {
    return users;
  }

  Future getSports() async {
    return sports;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: 'Posts'),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: FutureBuilder(
            future: Future.wait([getPosts(), getUsers(), getSports()]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              } else if (snapshot.hasData) {
                if (snapshot.data![0].length == 0) {
                  return const Center(child: Text("Nothing to show here ..."));
                } else {
                  var posts = snapshot.data![0] as List<Post>;
                  var users = snapshot.data![1] as List<User>;
                  var sports = snapshot.data![2] as List<Sport>;
                  return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return PostCard(
                          key: UniqueKey(),
                          context: context,
                          firebaseID: users[index].firebaseID,
                          message: posts[index].message,
                          time: posts[index].time,
                          sport: sports[index].sport,
                          imageURL: users[index].imageURL,
                          firstName: users[index].firstName,
                          lastName: users[index].lastName,
                          postID: posts[index].postID,
                          onDeletedPost: () {
                            posts.removeAt(index);
                            users.removeAt(index);
                            sports.removeAt(index);
                            setState(() {});
                          },
                        );
                      });
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }
}
