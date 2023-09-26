import 'dart:convert';

class Comments {

 final  DateTime CreatedAt;
  final String  UserId;
  final String  comments;
  final String CommentsId;
  final String CommuintyName;
  final String ProfileUrl;
  final String PostId;


  Comments({required this.PostId,required this.ProfileUrl,required this.CreatedAt, required this.UserId, required this.comments, required this.CommentsId, required this.CommuintyName});

  Map<String, dynamic> toMap() {
    return {
      'CreatedAt': CreatedAt.millisecondsSinceEpoch,
      'UserId': UserId,
      'comments': comments,
      'CommentsId': CommentsId,
      'CommuintyName': CommuintyName,
      'ProfileUrl': ProfileUrl,
      'PostId': PostId,
    };
  }

  factory Comments.fromMap(Map<String, dynamic> map) {
    return Comments(
      CreatedAt: DateTime.fromMillisecondsSinceEpoch(map['CreatedAt']),
      UserId: map['UserId'] ?? '',
      comments: map['comments'] ?? '',
      CommentsId: map['CommentsId'] ?? '',
      CommuintyName: map['CommuintyName'] ?? '',
      ProfileUrl: map['ProfileUrl'] ?? '',
      PostId: map['PostId'] ?? '',
    );
  }

  
  Comments copyWith({
    DateTime? CreatedAt,
    String? UserId,
    String? comments,
    String? CommentsId,
    String? CommuintyName,
    String? ProfileUrl,
    String? PostId,
  }) {
    return Comments(
      CreatedAt: CreatedAt ?? this.CreatedAt,
      UserId: UserId ?? this.UserId,
      comments: comments ?? this.comments,
      CommentsId: CommentsId ?? this.CommentsId,
      CommuintyName: CommuintyName ?? this.CommuintyName,
      ProfileUrl: ProfileUrl ?? this.ProfileUrl,
      PostId: PostId ?? this.PostId,
    );
  }

  

  
}
