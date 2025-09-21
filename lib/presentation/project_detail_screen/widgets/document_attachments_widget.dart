import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentAttachmentsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> documents;

  const DocumentAttachmentsWidget({
    Key? key,
    required this.documents,
  }) : super(key: key);

  String _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return 'picture_as_pdf';
      case 'doc':
      case 'docx':
        return 'description';
      case 'xls':
      case 'xlsx':
        return 'table_chart';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'image';
      default:
        return 'attach_file';
    }
  }

  Color _getFileColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return AppTheme.errorLight;
      case 'doc':
      case 'docx':
        return Color(0xFF2B579A);
      case 'xls':
      case 'xlsx':
        return Color(0xFF217346);
      case 'jpg':
      case 'jpeg':
      case 'png':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes} B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void _previewDocument(BuildContext context, Map<String, dynamic> document) {
    final String fileType = document['type'] as String;
    final String fileName = document['name'] as String;
    final String fileUrl = document['url'] as String;

    if (fileType.toLowerCase() == 'pdf') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _PDFPreviewScreen(
            fileName: fileName,
            fileUrl: fileUrl,
          ),
        ),
      );
    } else {
      // For other file types, show download dialog
      _showDownloadDialog(context, document);
    }
  }

  void _showDownloadDialog(
      BuildContext context, Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Download Document'),
          content: Text('Would you like to download ${document['name']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _downloadDocument(document);
              },
              child: Text('Download'),
            ),
          ],
        );
      },
    );
  }

  void _downloadDocument(Map<String, dynamic> document) {
    // Download functionality would be implemented here
    // For now, we'll show a success message
    print('Downloading: ${document['name']}');
  }

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Document Attachments',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        ...documents
            .map((document) => _buildDocumentItem(context, document))
            .toList(),
      ],
    );
  }

  Widget _buildDocumentItem(
      BuildContext context, Map<String, dynamic> document) {
    final String fileName = document['name'] as String;
    final String fileType = document['type'] as String;
    final int fileSize = document['size'] as int;
    final String uploadDate = document['uploadDate'] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _getFileColor(fileType).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _getFileIcon(fileType),
              size: 24,
              color: _getFileColor(fileType),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      fileType.toUpperCase(),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _getFileColor(fileType),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' • ${_formatFileSize(fileSize)}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      ' • $uploadDate',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _previewDocument(context, document),
                icon: CustomIconWidget(
                  iconName: fileType.toLowerCase() == 'pdf'
                      ? 'visibility'
                      : 'download',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                tooltip:
                    fileType.toLowerCase() == 'pdf' ? 'Preview' : 'Download',
              ),
              IconButton(
                onPressed: () {
                  // Share functionality would go here
                },
                icon: CustomIconWidget(
                  iconName: 'share',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                tooltip: 'Share',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'folder_open',
            size: 48,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 2.h),
          Text(
            'No documents attached',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Supporting documents will appear here when uploaded',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PDFPreviewScreen extends StatefulWidget {
  final String fileName;
  final String fileUrl;

  const _PDFPreviewScreen({
    Key? key,
    required this.fileName,
    required this.fileUrl,
  }) : super(key: key);

  @override
  State<_PDFPreviewScreen> createState() => _PDFPreviewScreenState();
}

class _PDFPreviewScreenState extends State<_PDFPreviewScreen> {
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fileName,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'download',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              // Download functionality would go here
            },
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              // Share functionality would go here
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.fileUrl,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            onRender: (pages) {
              setState(() {
                this.pages = pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
            },
            onViewCreated: (PDFViewController pdfViewController) {
              // PDF controller setup
            },
            onLinkHandler: (String? uri) {
              // Link handler
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                currentPage = page;
              });
            },
          ),
          if (errorMessage.isNotEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'error_outline',
                    size: 64,
                    color: AppTheme.errorLight,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Error loading PDF',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.errorLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    errorMessage,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          if (!isReady && errorMessage.isEmpty)
            Center(
              child: CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
        ],
      ),
      bottomNavigationBar: isReady && pages != null && pages! > 1
          ? Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Text(
                'Page ${(currentPage ?? 0) + 1} of $pages',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : null,
    );
  }
}
