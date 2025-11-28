import 'package:lost_and_found/app/data/models/user_model.dart';

class Message {
  final int id;
  final int claimId;
  final int senderId; // ID Pengirim (Sesuai DB kamu)
  final int receiverId; // ID Penerima (Sesuai DB kamu)
  final String message; // Isi Pesan (Sesuai DB kamu)
  final DateTime createdAt;
  final User? sender; // Info detail user pengirim (Nama, dll)

  Message({
    required this.id,
    required this.claimId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdAt,
    this.sender,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      claimId: int.parse(json['claim_id'].toString()),
      senderId: int.parse(json['sender_id'].toString()),
      receiverId: int.parse(json['receiver_id'].toString()),
      message: json['message'] ?? '', // Mengambil field 'message' dari JSON
      createdAt: DateTime.parse(json['created_at']),
      sender: json['sender'] != null ? User.fromJson(json['sender']) : null,
    );
  }

  static List<Message> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => Message.fromJson(e)).toList();
  }
}
