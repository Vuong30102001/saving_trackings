import 'package:saving_trackings_flutter/feature/wallet/domain/entities/report_entity.dart';

abstract class ReportRepository{
  Future<List<ReportEntity>> getReport(String userId);
}