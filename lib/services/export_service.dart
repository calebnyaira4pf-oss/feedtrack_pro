import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ExportService {

  Future<File> exportCSV(
      String content) async {

    final directory =
        await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/report.csv',
    );

    return file.writeAsString(
      content,
    );
  }
}