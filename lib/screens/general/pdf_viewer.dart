import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

class PDFViewerScreen extends StatefulWidget {
  String url;
  String title;

  PDFViewerScreen({
    required this.url,
    this.title = "PDF",
  });

  @override
  State<PDFViewerScreen> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewerScreen> {
  bool _isLoading = false;
  // Load from assets
  PDFDocument? doc;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {
      _isLoading = true;
    });
    doc = await PDFDocument.fromURL(widget.url);

    setState(() {
      _isLoading = false;
    });
  }

  _share() async {
    ShareExtend.share(doc!.filePath!, "file");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _share();
            },
          )
        ],
      ),
      body: Center(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : PDFViewer(document: doc!),
      ),
    );
  }
}
