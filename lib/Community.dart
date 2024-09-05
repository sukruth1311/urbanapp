import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Community extends StatelessWidget {
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  String extractUsername(String email) {
    return email.split('@')[0];
  }

  Future<List<String>> uploadMedia(List<XFile> files) async {
    List<String> urls = [];
    for (XFile file in files) {
      String fileName = file.name;
      Reference storageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = storageRef.putFile(File(file.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      urls.add(downloadUrl);
    }
    return urls;
  }

  Future<void> createBlogPost(String title, String content, List<XFile> files) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String username = extractUsername(user.email!);
      List<String> mediaUrls = await uploadMedia(files);
      BlogPost newPost = BlogPost(
        id: '',
        username: username,
        title: title,
        content: content,
        mediaUrls: mediaUrls,
        likes: 0,
      );

      await FirebaseFirestore.instance.collection('posts').add(newPost.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Color.fromARGB(255, 243, 153, 153)),
        centerTitle: true,
        title: Text(
          "Community",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromRGBO(88, 140, 108, 1),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var posts = snapshot.data!.docs.map((doc) => BlogPost.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: BlogPostWidget(post: posts[index]),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Dummy sign in for testing, replace with actual sign in logic
          await signInWithEmail('test@example.com', 'password');

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostScreen()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromRGBO(88, 140, 108, 1),
      ),
    );
  }
}

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _mediaFiles = [];

  Future<void> _pickMedia() async {
    final List<XFile>? selectedFiles = await _picker.pickMultiImage();
    if (selectedFiles != null) {
      setState(() {
        _mediaFiles.addAll(selectedFiles);
      });
    }
  }

  Future<void> _submitPost() async {
    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
      final homeScreen = Community();

      await homeScreen.createBlogPost(
        _titleController.text,
        _contentController.text,
        _mediaFiles,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Color.fromARGB(255, 243, 153, 153)),
        centerTitle: true,
        title: Text(
          "Create Post",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromRGBO(88, 140, 108, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 4,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickMedia,
              child: Text('Pick Images'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('Submit Post'),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogPost {
  String id;
  String username;
  String title;
  String content;
  List<String> mediaUrls;
  int likes;

  BlogPost({
    required this.id,
    required this.username,
    required this.title,
    required this.content,
    required this.mediaUrls,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'title': title,
      'content': content,
      'mediaUrls': mediaUrls,
      'likes': likes,
    };
  }

  static BlogPost fromMap(Map<String, dynamic> map, String id) {
    return BlogPost(
      id: id,
      username: map['username'],
      title: map['title'],
      content: map['content'],
      mediaUrls: List<String>.from(map['mediaUrls']),
      likes: map['likes'],
    );
  }
}

class Comment {
  String id;
  String username;
  String content;

  Comment({
    required this.id,
    required this.username,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'content': content,
    };
  }

  static Comment fromMap(Map<String, dynamic> map, String id) {
    return Comment(
      id: id,
      username: map['username'],
      content: map['content'],
    );
  }
}

class BlogPostWidget extends StatelessWidget {
  final BlogPost post;

  BlogPostWidget({required this.post});

  Future<void> likePost() async {
    await FirebaseFirestore.instance.collection('posts').doc(post.id).update({
      'likes': FieldValue.increment(1),
    });
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CommentSection(postId: post.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 231, 214, 162),
      child: Padding(
        padding: const EdgeInsets.all(16.0),  // Added padding here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: Icon(Icons.person, size: 30),
                  ),
                  SizedBox(width: 10),
                  Text('${post.username}', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(post.title, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 10),
            // Display media (images/videos)
            post.mediaUrls.isNotEmpty
                ? SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: post.mediaUrls.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Image.network(post.mediaUrls[index]),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(post.content),
            ),
            Container(
              height: 2,
              width: double.infinity,
              color: Color.fromRGBO(88, 140, 108, 1),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: likePost,
                ),
                Text('${post.likes} Likes'),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    _showComments(context);
                  },
                ),
                Text('Comments'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CommentSection extends StatefulWidget {
  final String postId;

  CommentSection({required this.postId});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _commentController = TextEditingController();

  Future<void> _addComment() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && _commentController.text.isNotEmpty) {
      String username = Community().extractUsername(user.email!);
      Comment newComment = Comment(
        id: '',
        username: username,
        content: _commentController.text,
      );

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .add(newComment.toMap());

      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var comments = snapshot.data!.docs.map((doc) => Comment.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 226, 168, 168), // Background color for the comment
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          comments[index].username,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(comments[index].content),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Add a comment...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
