import 'dart:convert';

class ContainerModel {
   final String randomuid;
   final  int CreatedAt;
    final String commuintyName;
    final String communityProfile;
    final String? Description;
    final String? Link;
    final String title;
    final List<String> upVotes;
    final List<String>  downVotes;
    final int commentCount;
    final String username;
    final String  uid;
    final List<String> awards;
    final String type;

  ContainerModel({required this.type,required this.randomuid, required this.CreatedAt, required this.commuintyName, required this.communityProfile,  this.Description, required this.Link, required this.title, required this.upVotes, required this.downVotes, required this.commentCount, required this.username, required this.uid, required this.awards});


  Map<String, dynamic> toMap() {
    return {
      'randomuid': randomuid,
      'CreatedAt': CreatedAt,
      'commuintyName': commuintyName,
      'communityProfile': communityProfile,
      'Description': Description,
      'Link': Link,
      'title': title,
      'upVotes': upVotes,
      'downVotes': downVotes,
      'commentCount': commentCount,
      'username': username,
      'uid': uid,
      'awards': awards,
      'type': type,
    };
  }

  factory ContainerModel.fromMap(Map<String, dynamic> map) {
    return ContainerModel(
      randomuid: map['randomuid'] ?? '',
      CreatedAt: map['CreatedAt']?.toInt() ?? 0,
      commuintyName: map['commuintyName'] ?? '',
      communityProfile: map['communityProfile'] ?? '',
      Description: map['Description'],
      Link: map['Link'],
      title: map['title'] ?? '',
      upVotes: List<String>.from(map['upVotes']),
      downVotes: List<String>.from(map['downVotes']),
      commentCount: map['commentCount']?.toInt() ?? 0,
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      awards: List<String>.from(map['awards']),
      type: map['type'] ?? '',
    );
  }

 

  
}
