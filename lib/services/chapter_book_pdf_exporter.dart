import 'dart:io';

import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/milestone_model.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ChapterBookPdfExporter {
  ChapterBookPdfExporter._();

  static Future<File> buildAndSave({
    required ChildModel childModel,
    required UserModel? userModel,
    required List<MilestoneModel> milestones,
  }) async {
    final String childName = childModel.childName ?? 'Your child';
    final String parentName = userModel?.parentName ?? 'Parent';
    final pw.Document document = pw.Document();

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Text(
                'LovingBrain — Chapter Book',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Text('$childName\'s milestone memories'),
            pw.SizedBox(height: 8),
            pw.Text('Prepared for $parentName'),
            pw.SizedBox(height: 20),
            ..._chapterSections(milestones),
          ];
        },
      ),
    );

    final Directory tempDir = await getTemporaryDirectory();
    final String safeName = childName.replaceAll(RegExp(r'[^\w\s-]'), '').trim();
    final String filePath =
        '${tempDir.path}/lovingbrain_chapter_book_${safeName}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final File file = File(filePath);
    await file.writeAsBytes(await document.save());
    return file;
  }

  static List<pw.Widget> _chapterSections(List<MilestoneModel> milestones) {
    final List<pw.Widget> widgets = <pw.Widget>[];
    for (int chapter = 1; chapter <= 5; chapter++) {
      final List<MilestoneModel> chapterItems = milestones
          .where((MilestoneModel m) => m.chapter == chapter)
          .toList();
      if (chapterItems.isEmpty) {
        continue;
      }
      widgets.add(
        pw.Header(
          level: 1,
          child: pw.Text('Chapter $chapter'),
        ),
      );
      for (final MilestoneModel milestone in chapterItems) {
        widgets.add(pw.SizedBox(height: 8));
        widgets.add(
          pw.Text(
            milestone.title,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        );
        widgets.add(
          pw.Text(
            _formatDate(milestone.timestamp),
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        );
        widgets.add(pw.SizedBox(height: 6));
        widgets.add(pw.Text(milestone.whatThisMeans));
        widgets.add(pw.SizedBox(height: 6));
        widgets.add(pw.Text(milestone.storyText));
        widgets.add(pw.SizedBox(height: 16));
      }
    }
    return widgets;
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
