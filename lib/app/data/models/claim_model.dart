import 'package:lost_and_found/app/data/models/report_model.dart';
import 'package:lost_and_found/app/data/models/user_model.dart';

class Claim {
  final int id;
  final int itemId;
  final int claimerId;
  final int finderId;
  final String status;

  // Objek lengkap (Nested Objects)
  final Report? item;
  final User? claimer;
  final User? finder;

  Claim({
    required this.id,
    required this.itemId,
    required this.claimerId,
    required this.finderId,
    required this.status,
    this.item,
    this.claimer,
    this.finder,
  });

  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      // Parsing ID dengan aman (menerima int atau string angka)
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      itemId: json['item_id'] is int
          ? json['item_id']
          : int.parse(json['item_id'].toString()),
      claimerId: json['claimer_id'] is int
          ? json['claimer_id']
          : int.parse(json['claimer_id'].toString()),
      finderId: json['finder_id'] is int
          ? json['finder_id']
          : int.parse(json['finder_id'].toString()),

      status: json['status'] ?? 'pending',

      item: json['item'] != null
          ? Report.fromJson(json['item'] as Map<String, dynamic>)
          : null,

      claimer: json['claimer'] != null
          ? User.fromJson(json['claimer'] as Map<String, dynamic>)
          : null,

      finder: json['finder'] != null
          ? User.fromJson(json['finder'] as Map<String, dynamic>)
          : null,
    );
  }

  static List<Claim> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Claim.fromJson(json)).toList();
  }
}
