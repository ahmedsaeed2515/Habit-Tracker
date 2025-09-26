// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportDataAdapter extends TypeAdapter<ReportData> {
  @override
  final int typeId = 55;

  @override
  ReportData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportData(
      id: fields[0] as String,
      titleEn: fields[1] as String,
      titleAr: fields[2] as String,
      type: fields[3] as ReportType,
      createdAt: fields[4] as DateTime,
      startDate: fields[5] as DateTime,
      endDate: fields[6] as DateTime,
      data: (fields[7] as Map).cast<String, dynamic>(),
      insights: (fields[8] as List).cast<String>(),
      recommendations: (fields[9] as List).cast<String>(),
      overallScore: fields[10] as double,
      categoryScores: (fields[11] as Map).cast<String, double>(),
      status: fields[12] as ReportStatus,
      filePath: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReportData obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titleEn)
      ..writeByte(2)
      ..write(obj.titleAr)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.data)
      ..writeByte(8)
      ..write(obj.insights)
      ..writeByte(9)
      ..write(obj.recommendations)
      ..writeByte(10)
      ..write(obj.overallScore)
      ..writeByte(11)
      ..write(obj.categoryScores)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.filePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReportTemplateAdapter extends TypeAdapter<ReportTemplate> {
  @override
  final int typeId = 58;

  @override
  ReportTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportTemplate(
      id: fields[0] as String,
      nameEn: fields[1] as String,
      nameAr: fields[2] as String,
      descriptionEn: fields[3] as String,
      descriptionAr: fields[4] as String,
      type: fields[5] as ReportType,
      sections: (fields[6] as List).cast<String>(),
      charts: (fields[7] as List).cast<String>(),
      settings: (fields[8] as Map).cast<String, dynamic>(),
      isDefault: fields[9] as bool,
      createdAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ReportTemplate obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameEn)
      ..writeByte(2)
      ..write(obj.nameAr)
      ..writeByte(3)
      ..write(obj.descriptionEn)
      ..writeByte(4)
      ..write(obj.descriptionAr)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.sections)
      ..writeByte(7)
      ..write(obj.charts)
      ..writeByte(8)
      ..write(obj.settings)
      ..writeByte(9)
      ..write(obj.isDefault)
      ..writeByte(10)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InsightDataAdapter extends TypeAdapter<InsightData> {
  @override
  final int typeId = 59;

  @override
  InsightData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InsightData(
      id: fields[0] as String,
      titleEn: fields[1] as String,
      titleAr: fields[2] as String,
      descriptionEn: fields[3] as String,
      descriptionAr: fields[4] as String,
      type: fields[5] as InsightType,
      priority: fields[6] as InsightPriority,
      discoveredAt: fields[7] as DateTime,
      context: (fields[8] as Map).cast<String, dynamic>(),
      actionItems: (fields[9] as List).cast<String>(),
      isRead: fields[10] as bool,
      isActionTaken: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, InsightData obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titleEn)
      ..writeByte(2)
      ..write(obj.titleAr)
      ..writeByte(3)
      ..write(obj.descriptionEn)
      ..writeByte(4)
      ..write(obj.descriptionAr)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.priority)
      ..writeByte(7)
      ..write(obj.discoveredAt)
      ..writeByte(8)
      ..write(obj.context)
      ..writeByte(9)
      ..write(obj.actionItems)
      ..writeByte(10)
      ..write(obj.isRead)
      ..writeByte(11)
      ..write(obj.isActionTaken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MetricDataAdapter extends TypeAdapter<MetricData> {
  @override
  final int typeId = 62;

  @override
  MetricData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MetricData(
      id: fields[0] as String,
      name: fields[1] as String,
      value: fields[2] as double,
      unit: fields[3] as String,
      timestamp: fields[4] as DateTime,
      metadata: (fields[5] as Map).cast<String, dynamic>(),
      previousValue: fields[6] as double?,
      category: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MetricData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.value)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.metadata)
      ..writeByte(6)
      ..write(obj.previousValue)
      ..writeByte(7)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetricDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReportTypeAdapter extends TypeAdapter<ReportType> {
  @override
  final int typeId = 56;

  @override
  ReportType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReportType.daily;
      case 1:
        return ReportType.weekly;
      case 2:
        return ReportType.monthly;
      case 3:
        return ReportType.quarterly;
      case 4:
        return ReportType.yearly;
      case 5:
        return ReportType.custom;
      default:
        return ReportType.daily;
    }
  }

  @override
  void write(BinaryWriter writer, ReportType obj) {
    switch (obj) {
      case ReportType.daily:
        writer.writeByte(0);
        break;
      case ReportType.weekly:
        writer.writeByte(1);
        break;
      case ReportType.monthly:
        writer.writeByte(2);
        break;
      case ReportType.quarterly:
        writer.writeByte(3);
        break;
      case ReportType.yearly:
        writer.writeByte(4);
        break;
      case ReportType.custom:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReportStatusAdapter extends TypeAdapter<ReportStatus> {
  @override
  final int typeId = 57;

  @override
  ReportStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReportStatus.generating;
      case 1:
        return ReportStatus.ready;
      case 2:
        return ReportStatus.exported;
      case 3:
        return ReportStatus.shared;
      case 4:
        return ReportStatus.archived;
      default:
        return ReportStatus.generating;
    }
  }

  @override
  void write(BinaryWriter writer, ReportStatus obj) {
    switch (obj) {
      case ReportStatus.generating:
        writer.writeByte(0);
        break;
      case ReportStatus.ready:
        writer.writeByte(1);
        break;
      case ReportStatus.exported:
        writer.writeByte(2);
        break;
      case ReportStatus.shared:
        writer.writeByte(3);
        break;
      case ReportStatus.archived:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InsightTypeAdapter extends TypeAdapter<InsightType> {
  @override
  final int typeId = 60;

  @override
  InsightType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InsightType.trend;
      case 1:
        return InsightType.pattern;
      case 2:
        return InsightType.anomaly;
      case 3:
        return InsightType.achievement;
      case 4:
        return InsightType.opportunity;
      case 5:
        return InsightType.warning;
      default:
        return InsightType.trend;
    }
  }

  @override
  void write(BinaryWriter writer, InsightType obj) {
    switch (obj) {
      case InsightType.trend:
        writer.writeByte(0);
        break;
      case InsightType.pattern:
        writer.writeByte(1);
        break;
      case InsightType.anomaly:
        writer.writeByte(2);
        break;
      case InsightType.achievement:
        writer.writeByte(3);
        break;
      case InsightType.opportunity:
        writer.writeByte(4);
        break;
      case InsightType.warning:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InsightPriorityAdapter extends TypeAdapter<InsightPriority> {
  @override
  final int typeId = 61;

  @override
  InsightPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InsightPriority.low;
      case 1:
        return InsightPriority.medium;
      case 2:
        return InsightPriority.high;
      case 3:
        return InsightPriority.critical;
      default:
        return InsightPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, InsightPriority obj) {
    switch (obj) {
      case InsightPriority.low:
        writer.writeByte(0);
        break;
      case InsightPriority.medium:
        writer.writeByte(1);
        break;
      case InsightPriority.high:
        writer.writeByte(2);
        break;
      case InsightPriority.critical:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsightPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
