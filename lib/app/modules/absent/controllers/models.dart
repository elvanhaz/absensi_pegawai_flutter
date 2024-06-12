import 'package:cloud_firestore/cloud_firestore.dart';

class BooksModel {
  final String bookID;
  final String bookName;
  final String bookImage;

  BooksModel({
    required this.bookID,
    required this.bookName,
    required this.bookImage,
  });

  factory BooksModel.fromDocument(DocumentSnapshot documentSnapshot) {
    return BooksModel(
      bookID: documentSnapshot['bookID'],
      bookName: documentSnapshot['bookName'],
      bookImage: documentSnapshot['bookImage'],
    );
  }
}
