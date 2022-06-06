import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dahar/models/dahar_user.dart';

class UserDatabase {
  final String? uid;
  UserDatabase({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  Future<void> updateUser(String nama, String email, String foto) async {
    return await userCollection
        .doc(uid)
        .set({'nama': nama, 'email': email, 'foto': foto});
  }

  List<DaharUser> _userListFromSnapshot(QuerySnapshot? snapshot) {
    return snapshot!.docs.map((doc) {
      return DaharUser(
          id: doc.id,
          nama: doc.get('nama') ?? '',
          email: doc.get('email') ?? '',
          foto: doc.get('foto'));
    }).toList();
  }

  Stream<List<DaharUser>> get user {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}
