import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lilac_machine_test/model/user_model.dart';

class DataRepo{

  static CollectionReference userCollection = getFirestoreInstance()!.collection('user');

  Future<DocumentReference> addUser(UserModel userModel) {
    return userCollection.add(userModel.toJson());
  }

  Future updateUser(UserModel userModel) async {
    await userCollection.doc(userModel.id).update(userModel.toJson());
  }

  static FirebaseFirestore? getFirestoreInstance() {
      return FirebaseFirestore.instance;
  }

  static FirebaseStorage? getFirestoreStorageInstance() {
      return FirebaseStorage.instance;
  }
}