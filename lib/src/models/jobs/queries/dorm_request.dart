import 'package:dorm_client/src/models/jobs/before/dorm_before.dart';
import 'package:dorm_client/src/models/jobs/queries/dorm_column.dart';
import 'package:dorm_client/src/models/jobs/queries/dorm_join.dart';
import 'package:dorm_client/src/models/jobs/dorm_insert.dart';
import 'package:dorm_client/src/models/jobs/dorm_job.dart';
import 'package:dorm_client/src/models/jobs/dorm_read.dart';
import 'package:dorm_client/src/models/jobs/dorm_replace.dart';
import 'package:dorm_client/src/models/jobs/dorm_update.dart';
import 'package:dorm_client/src/models/jobs/queries/dorm_value.dart';
import 'package:dorm_client/src/models/jobs/queries/dorm_where.dart';
import 'package:equatable/equatable.dart';

class DORMRequest extends Equatable {
  final List<DORMJob> jobs = [];

  DORMRequest add(DORMJob job) {
    jobs.add(job);

    return this;
  }

  DORMRequest addRead<T>({
    String? from,
    List<DORMColumn>? columns,
    List<DORMWhere<T>>? where,
    List<DORMJoin>? join,
  }) {
    final DORMRead job = DORMRead(
      from: from,
      columns: columns,
      where: where,
      join: join,
    );

    return add(job);
  }

  DORMRequest addInsert({
    required String from,
    required final List<DORMValue> values,
    DORMBefore? before,
  }) {
    final DORMInsert job = DORMInsert(
      from: from,
      values: values,
      before: before,
    );

    return add(job);
  }

  DORMRequest addUpdate({
    required final String from,
    required final List<DORMValue> values,
    required final List<DORMWhere>? where,
  }) {
    final DORMUpdate job = DORMUpdate(
      from: from,
      values: values,
      where: where,
    );

    return add(job);
  }

  DORMRequest addReplace({
    required String from,
    required final List<DORMValue> values,
    required final List<DORMWhere>? where,
  }) {
    final DORMReplace job = DORMReplace(
      from: from,
      values: values,
      where: where,
    );

    return add(job);
  }

  DORMRequest();

  List<Map<String, dynamic>> toJson() =>
      jobs.map((job) => job.toJson()).toList();

  factory DORMRequest.fromJson(List<Map<String, dynamic>> json) {
    final DORMRequest request = DORMRequest();

    for (final Map<String, dynamic> job in json) {
      final String type = job['job'];

      switch (type) {
        case 'read':
          request.add(DORMRead.fromJson(job));
          break;
        case 'insert':
          request.add(DORMInsert.fromJson(job));
          break;
        case 'update':
          request.add(DORMUpdate.fromJson(job));
          break;
        case 'replace':
          request.add(DORMReplace.fromJson(job));
          break;
        default:
          throw Exception('Invalid job type');
      }
    }

    return request;
  }

  @override
  List<Object?> get props => [jobs];
}
