import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  final FirebaseFirestore _firebaseFirestore;

  //FirebaseAuth instance
  FirestoreProvider(this._firebaseFirestore);

  get firestore => _firebaseFirestore;

  getUser(String? email) async {
    CollectionReference users_collection =
        _firebaseFirestore.collection('users');
    QuerySnapshot<Object?> users =
        await users_collection.where('email', isEqualTo: email ?? '').get();
    return users.docs.asMap();
  }
}
