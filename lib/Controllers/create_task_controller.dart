import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CreateTaskController extends GetxController{
  bool isLoading = true;
    setData(docid,taskname,taskdesc) async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String id = auth.currentUser!.uid;
    CollectionReference reference =  firestore.collection("Todo");
    reference.doc(docid).set({
      'taskname':taskname,
      'taskdesc':taskdesc,
      "docid":docid,
      "uid":id,
      "iscompleted":false

    });
    isLoading = false;
    update();
  }

}
