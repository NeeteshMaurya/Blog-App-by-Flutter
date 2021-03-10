import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods{

  //function
  Future<void>addData(blogMap)async{
    FirebaseFirestore.instance.collection("blogs").add(blogMap).catchError((e){
      print(e);
    });
  }

  getData()async{
    return await FirebaseFirestore.instance.collection("blogs").snapshots();
  }
}