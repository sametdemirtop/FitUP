import 'package:cloud_firestore/cloud_firestore.dart';

class Kullanici {
  final String? id;
  final String? profileName;
  final String? email;
  final Timestamp? timestamp;
  final String? gender;
  final int? age;
  final int? length;
  final int? weight;
  final String? fromWhere;

  Kullanici({
    this.id,
    this.profileName,
    this.email,
    this.timestamp,
    this.gender,
    this.age,
    this.length,
    this.weight,
    this.fromWhere,
  });

  factory Kullanici.fromDocument(DocumentSnapshot doc) {
    return Kullanici(
      id: doc['id'],
      email: doc['email'],
      profileName: doc['profileName'],
      timestamp: doc['timestamp'],
      gender: doc['gender'],
      age: doc['age'],
      length: doc['length'],
      weight: doc['weight'],
      fromWhere: doc['fromWhere'],
    );
  }
}
