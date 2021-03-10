import 'package:blog_app/services/crud.dart';
import 'package:blog_app/views/home.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

  String authorName, title, desc;

  bool _isLoading = false;
  CrudMethods crudMethods =
      CrudMethods(); //making object of crud method by which we can access function defined in crudmethod

  File selectedImage;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  uploadBlog() async {
    if (selectedImage != null) {
      setState(() {
        _isLoading = true;
      });
      firebase_storage.Reference firebaseStorageRef = firebase_storage
          .FirebaseStorage.instance //making reference of firebase storage folder
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}");//making reference of firebase storage folder

      final firebase_storage.UploadTask task = firebaseStorageRef.putFile(selectedImage);//uploading image to that given reference or folder

      var downloadUrl = await (await task).ref.getDownloadURL();
      print("this is url $downloadUrl");

      //map is a collection of key value pair.add method inside crud takes always map
      Map<String, String> blogMap = {
        "imgUrl": downloadUrl,
        "author": authorName,
        "title": title,
        "description": desc,
      };
      crudMethods.addData(blogMap).then((result){
        Navigator.pop(context);
      });

    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Flutter",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "Blog",
              style: TextStyle(fontSize: 22, color: Colors.blue),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.file_upload),
            ),
          ),
        ],
      ),
      body: _isLoading ? Container(alignment: Alignment.center,child: CircularProgressIndicator(),) : Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: selectedImage != null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            selectedImage,
                            fit: BoxFit.cover,
                          )),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        color: Colors.black,
                        size: 60,
                      ),
                    ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: "Author Name"),
                    onChanged: (val) {
                      authorName = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Title"),
                    onChanged: (val) {
                      title = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Description"),
                    onChanged: (val) {
                      desc = val;
                    },
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
