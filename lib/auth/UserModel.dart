import 'dart:convert';

class UserDetails {
  final String userName;
  final String photoURL;
  final String banner;
  final String uid;
  final bool isAuthenticated;
  final List<String> awards;
  final int Karma;

  UserDetails({required this.userName, required this.photoURL, required this.banner, required this.uid, required this.isAuthenticated, required this.awards, required this.Karma});


  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'photoURL': photoURL,
      'banner': banner,
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'awards': awards,
      'Karma': Karma,
    };
  }

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      userName: map['userName'] ?? '',
      photoURL: map['photoURL'] ?? '',
      banner: map['banner'] ?? '',
      uid: map['uid'] ?? '',
      isAuthenticated: map['isAuthenticated'] ?? false,
      awards: List<String>.from(map['awards']),
      Karma: map['Karma']?.toInt() ?? 0,
    );
  }

  

  UserDetails copyWith({
    String? userName,
    String? photoURL,
    String? banner,
    String? uid,
    bool? isAuthenticated,
    List<String>? awards,
    int? Karma,
  }) {
    return UserDetails(
      userName: userName ?? this.userName,
      photoURL: photoURL ?? this.photoURL,
      banner: banner ?? this.banner,
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      awards: awards ?? this.awards,
      Karma: Karma ?? this.Karma,
    );
  }
}
