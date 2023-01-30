import 'package:dorm_client/src/configs/dorm_config.dart';

class DORMRequest {
  List<DORMJob> jobs = [];

  DORMRequest add(DORMJob job) {
    jobs.add(job);

    return this;
  }

  DORMRequest addRead({
    from,
    columns,
    where,
    join,
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

  Map<String, dynamic> toJson() => {
        'schema': DORMConfig.schema,
        'token': DORMConfig.token,
        'jobs': jobs.map((job) => job.toJson()).toList(),
      };
}

abstract class DORMJob {
  final String job;
  final String from;

  DORMJob({
    required this.job,
    required this.from,
  });

  Map<String, dynamic> toJson() => {
        'job': job,
        'from': from,
      };
}

class DORMRead extends DORMJob {
  final List<DORMColumn>? columns;
  late final List<DORMWhere>? where;
  DORMJoin? join;
  // TODO: add join property
  // TODO: add order property
  // TODO: add embed property
  // TODO: add limit property

  DORMRead({
    required from,
    this.columns,
    this.where,
    this.join,
  }) : super(
          job: 'read',
          from: from,
        );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();

    if (columns != null) {
      json['columns'] = columns!.map((column) => column.toJson()).toList();
    }

    if (where != null) {
      json['where'] = where!.map((whereElement) => whereElement.toJson()).toList();
    }

    if (join != null) {
      json['join'] = join!.toJson();
    }

    return json;
  }
}

class DORMInsert extends DORMJob {
  final List<DORMValue> values;
  final DORMBefore? before;

  DORMInsert({
    required from,
    required this.values,
    this.before,
  }) : super(
          job: 'insert',
          from: from,
        );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();

    Map<String, dynamic> insertValues = {};

    for (final value in values) {
      insertValues[value.columnName] = value.value.toString();
    }

    json["values"] = insertValues;

    if (before != null) {
      json["before"] = before!.toJson();
    }

    return json;
  }
}

class DORMUpdate extends DORMJob {
  final List<DORMValue> values;
  final List<DORMWhere>? where;

  DORMUpdate({
    required from,
    required this.values,
    this.where,
  }) : super(
          job: 'update',
          from: from,
        );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();

    Map<String, dynamic> updateValues = {};

    for (final value in values) {
      updateValues[value.columnName] = value.value.toString();
    }

    json["values"] = updateValues;

    if (where != null) {
      json['where'] = where!.map((whereElement) => whereElement.toJson()).toList();
    }

    return json;
  }
}

class DORMDelete extends DORMJob {
  final List<DORMWhere>? where;

  DORMDelete({
    required from,
    this.where,
  }) : super(
          job: 'delete',
          from: from,
        );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();

    if (where != null) {
      json['where'] = where!.map((whereElement) => whereElement.toJson()).toList();
    }

    return json;
  }
}

class DORMColumn {
  final String column;

  DORMColumn({
    required this.column,
  });

  Map<String, dynamic> toJson() => {
        'column': column,
      };
}

class DORMWhere<T> {
  final String column;
  final T value;
  final String condition;
  // TODO: add op property
  // TODO: add val1 property
  // TODO: add val2 property

  DORMWhere({
    required this.column,
    required this.value,
    required this.condition,
  });

  Map<String, dynamic> toJson() => {
        'column': column,
        'value': value,
        'condition': condition,
      };
}

class DORMValue<T> {
  final String columnName;
  final T value;

  DORMValue({
    required this.columnName,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
        "columnName": columnName,
        "value": value.toString(),
      };
}

class DORMBefore {
  final DORMLastInsertId lastInsertId;

  DORMBefore({
    required this.lastInsertId,
  });

  Map<String, dynamic> toJson() => {
        "lastInsertId": lastInsertId.toJson(),
      };
}

class DORMLastInsertId {
  final String fromTable;
  final String setColumn;

  DORMLastInsertId({
    required this.fromTable,
    required this.setColumn,
  });

  Map<String, dynamic> toJson() => {
        "fromtTable": fromTable,
        "setColumn": setColumn,
      };
}

class DORMJoin {
  final Map<String, String> jobsColumns;

  DORMJoin({required this.jobsColumns});

  Map<String, dynamic> toJson() => jobsColumns;
}