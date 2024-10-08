import 'package:dorm_client/src/models/jobs/queries/dorm_column.dart';
import 'package:dorm_client/src/models/jobs/queries/dorm_embed.dart';
import 'package:dorm_client/src/models/jobs/queries/dorm_join.dart';
import 'package:dorm_client/src/models/jobs/queries/dorm_order.dart';
import 'package:dorm_client/src/models/jobs/dorm_job.dart';
import 'package:dorm_client/src/models/jobs/queries/dorm_where.dart';

class DORMRead extends DORMJob {
  final List<DORMColumn>? columns;
  late final List<DORMWhere>? where;
  final List<DORMJoin>? join;
  final DORMOrder? order;
  final int? limit;
  final List<DORMEmbed>? embed;

  DORMRead({
    required from,
    this.columns,
    this.where,
    this.join,
    this.order,
    this.limit,
    this.embed,
    super.before,
    super.after,
  }) : super(
          job: 'read',
          from: from,
        );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();

    Map<String, dynamic> readJson = {
      if (columns != null)
        'columns': columns!.map((column) => column.toJson()).toList(),
      if (where != null)
        'where': where!.map((whereElement) => whereElement.toJson()).toList(),
      if (order != null) 'order': order!.toJson(),
      if (limit != null) 'limit': limit,
      if (embed != null)
        'embed': embed!.map((embedElement) => embedElement.toJson()).toList(),
    };

    if (join != null) {
      readJson['join'] =
          join!.map((joinElement) => joinElement.toJson()).toList();
    }

    json.addAll(readJson);

    return json;
  }

  @override
  List<Object?> get props =>
      [from, columns, where, join, order, limit, embed, before, after];
}
