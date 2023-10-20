import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DeleteTaskController extends GetxController{
     bool isLoading = true;

   void deleteTask(docid)async{
          FirebaseFirestore firestore = FirebaseFirestore.instance;

   await firestore.collection('Todo').doc(docid).delete();
    isLoading = false;
    update();
 }
}