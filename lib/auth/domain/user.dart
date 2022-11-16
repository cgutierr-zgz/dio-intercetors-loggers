// ignore_for_file: sort_constructors_first

import 'package:flutter/material.dart';

@immutable
class User {
  const User({required this.uid});
  final String uid;

  User copyWith({
    String? uid,
  }) {
    return User(
      uid: uid ?? this.uid,
    );
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
    };
  }
}
