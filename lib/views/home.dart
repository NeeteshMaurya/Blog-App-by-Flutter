import 'package:blog_app/services/crud.dart';
import 'package:blog_app/views/create_blog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CrudMethods crudMethods = CrudMethods();

  Stream blogsStream;

  Widget BlogList() {
    return Container(
      child: blogsStream != null
          ? StreamBuilder<QuerySnapshot>(
              stream: blogsStream,
              builder: (context, snapshot) {
                QuerySnapshot values = snapshot.data;
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return BlogsTile(
                      authorName: snapshot.data.docs[index].get('author'),
                      title: snapshot.data.docs[index].get('title'),
                      description: snapshot.data.docs[index].get('description'),
                      imgUrl: snapshot.data.docs[index].get('imgUrl'),
                      docId: snapshot.data.docs[index].id,
                    );
                  },
                );
              },
            )
          : Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    crudMethods.getData().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
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
      ),
      body: BlogList(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateBlog()));
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  CrudMethods crudMethods = CrudMethods();
  String imgUrl, title, description, authorName;
  var docId;
  BlogsTile({@required this.imgUrl, @required this.docId, @required this.title, @required this.description, @required this.authorName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: (){
        crudMethods.deleteData(docId);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  Text(authorName),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
