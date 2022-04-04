import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hustle_app/api/firestore_service.dart';
import 'package:hustle_app/api/post_service.dart';
import 'package:hustle_app/model/post_model.dart';
import 'package:hustle_app/utils/storage.dart';

class PostCard extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String time;
  final String sport;
  final String message;
  final String firebaseToken;
  final BuildContext context;
  final String imageURL;
  final int postID;
  final VoidCallback onDeletedPost;
  final VoidCallback onRequestSent;
  final bool isOnMap;
  final String? email;
  final String? myFirstName;
  final String? myLastName;
  final String? myPhoneNumber;
  final String? myImgURL;

  const PostCard({
    Key? key,
    required this.context,
    required this.firebaseToken,
    required this.firstName,
    required this.lastName,
    required this.time,
    required this.message,
    required this.sport,
    required this.imageURL,
    required this.postID,
    required this.onDeletedPost,
    required this.onRequestSent,
    required this.isOnMap,
    required this.email,
    required this.myFirstName,
    required this.myLastName,
    required this.myPhoneNumber,
    required this.myImgURL,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isMine = false;
  late DeletePostRequest deletePostRequest;
  late DeletePostResponse deletePostresponse;
  late PostService postService = PostService();
  bool _isRequested = true;

  @override
  void initState() {
    super.initState();
    if (widget.email == email) {
      _isMine = true;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkRequestExists();
    });
  }

  @override
  Widget build(context) {
    return Wrap(children: <Widget>[
      Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: widget.isOnMap
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 200)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 55,
                    height: 55,
                    child: ClipOval(
                      child: Material(
                        color: Theme.of(context).colorScheme.onBackground,
                        child: Image.network(
                          widget.imageURL.toString(),
                          height: 150.0,
                          width: 100.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  '${widget.firstName} ${widget.lastName}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Sport:  ${widget.sport}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              Text(
                'Time: ${widget.time}',
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Align(
                  child: Text(
                    widget.message,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                  alignment: Alignment.topLeft),
              const SizedBox(height: 10),
              Container(
                  child: !_isMine
                      ? Align(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: widget.isOnMap
                                ? ButtonBar(children: [
                                    TextButton(
                                      onPressed: !_isRequested
                                          ? () {
                                              createDocument();
                                              _isRequested = true;
                                              setState(() {});
                                              widget.onRequestSent();
                                            }
                                          : null,
                                      child: const Text('Send Request',
                                          style: TextStyle(fontSize: 15)),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Dismiss'),
                                      child: const Text('Dismiss'),
                                    ),
                                  ])
                                : TextButton(
                                    onPressed: !_isRequested
                                        ? () {
                                            createDocument();
                                            _isRequested = true;
                                            setState(() {});
                                            widget.onRequestSent();
                                          }
                                        : null,
                                    child: const Text('Send Request',
                                        style: TextStyle(fontSize: 15)),
                                  ),
                          ),
                          alignment: Alignment.bottomRight,
                        )
                      : ButtonBar(
                          children: [
                            TextButton(
                              onPressed: () => {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => SizedBox(
                                    width: 300,
                                    height: 400,
                                    child: AlertDialog(
                                      title: const Text('Alert'),
                                      content: const Text(
                                          'Are you sure you want to delete your post?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'OK');
                                            deletePostRequest =
                                                DeletePostRequest(
                                                    postID: widget.postID);
                                            postService
                                                .deletePost(deletePostRequest,
                                                    jwtToken!)
                                                .then((value) {
                                              if (!value.error.isNotEmpty) {
                                                widget.onDeletedPost();
                                              }
                                            });
                                          },
                                          child: Text(
                                            'OK',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              },
                              child: Text('Delete',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      fontSize: 15)),
                            ),
                          ],
                        ))
            ],
          ),
        ),
      ),
    ]);
  }

  Future createDocument() async {
    if (!_isRequested) {
      final refMessage =
          FirebaseFirestore.instance.collection('requests').doc();
      await refMessage.set({
        'senderID': email,
        'receiverID': widget.email,
        'isAccepted': false,
        'firebaseToken': widget.firebaseToken,
        'imgURL': imgURL,
        'senderFirstName': widget.myFirstName,
        'senderLastName': widget.myLastName
      });

      await sendNotification(
          widget.firebaseToken, widget.myFirstName, widget.myLastName);
      _isRequested = true;
    }
  }

  checkRequestExists() async {
    QuerySnapshot querySender = await FirebaseFirestore.instance
        .collection('requests')
        .where('senderID', isEqualTo: email)
        .where('receiverID', isEqualTo: widget.email)
        .get();
    QuerySnapshot queryReceiver = await FirebaseFirestore.instance
        .collection('requests')
        .where('senderID', isEqualTo: widget.email)
        .where('receiverID', isEqualTo: email)
        .get();
    if (this.mounted) {
      setState(() {
        querySender.docs.isEmpty && queryReceiver.docs.isEmpty
            ? _isRequested = false
            : _isRequested = true;
      });
    }
  }
}
