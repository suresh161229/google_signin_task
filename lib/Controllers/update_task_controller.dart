import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UpdateTaskController extends GetxController{
   bool isLoading = true;
   void updateTask(id,taskname,taskdesc)async{
      FirebaseFirestore firestore = FirebaseFirestore.instance;

   await  firestore.collection('Todo').doc(id).update({
     "taskname":taskname,
     "taskdesc":taskdesc,
   
   });
   isLoading = false;
    update();
 }
}