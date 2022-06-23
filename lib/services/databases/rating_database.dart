import 'package:cloud_firestore/cloud_firestore.dart';

class RatingDatabase {
  final String? uid;
  RatingDatabase({this.uid});

  final CollectionReference ratingCollection =
      FirebaseFirestore.instance.collection('rating');

  Future<DocumentReference<Object?>> addRating(int rating,
      DocumentReference id_produk, DocumentReference id_seller) async {
    return await ratingCollection.add({
      'rating': rating,
      'id_produk': id_produk,
      'id_buyer': FirebaseFirestore.instance.doc('user/' + uid!),
      'id_seller': id_seller,
    });
  }

  Future<void> updateRating(DocumentReference id_rating, int rating) async {
    return await ratingCollection.doc(id_rating.id).update({
      'rating': rating,
    });
  }
}
