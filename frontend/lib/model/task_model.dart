// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TaskModel {
  final String id;
  final String uid;
  final String title;
  final String description;
  final String hexCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime dueAt;
  TaskModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.description,
    required this.hexCode,
    required this.createdAt,
    required this.updatedAt,
    required this.dueAt,
  });

  TaskModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? description,
    String? hexCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      hexCode: hexCode ?? this.hexCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueAt: dueAt ?? this.dueAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'title': title,
      'description': description,
      'hexCode': hexCode,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'dueAt': dueAt.millisecondsSinceEpoch,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      hexCode: map['hexCode'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      dueAt: DateTime.parse(map['dueAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(id: $id, uid: $uid, title: $title, description: $description, hexCode: $hexCode, createdAt: $createdAt, updatedAt: $updatedAt, dueAt: $dueAt)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uid == uid &&
        other.title == title &&
        other.description == description &&
        other.hexCode == hexCode &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.dueAt == dueAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        title.hashCode ^
        description.hashCode ^
        hexCode.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        dueAt.hashCode;
  }
}
