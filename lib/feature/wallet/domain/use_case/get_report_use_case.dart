import 'package:saving_trackings_flutter/feature/wallet/domain/entities/report_entity.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/repository/report_repository.dart';

class GetReportUseCase{
  final ReportRepository reportRepository;
  GetReportUseCase({required this.reportRepository});

  Future<List<ReportEntity>> getReports(String userId) async {
    return await reportRepository.getReport(userId);
  }
}