import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'constants.dart';

class HtmlView extends StatefulWidget {
  @override
  _HtmlViewState createState() => _HtmlViewState();
}

class _HtmlViewState extends State<HtmlView> {
  static final int _initialPage = 1;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  bool isSampleDoc = true;
  PdfController _pdfController;
  @override
  void initState() {
    _pdfController = PdfController(
      document: PdfDocument.openAsset('assets/TANDC.pdf'),
      initialPage: _initialPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Terms & Conditions'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () {
              _pdfController.previousPage(
                curve: Curves.ease,
                duration: Duration(milliseconds: 100),
              );
            },
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              '$_actualPageNumber/$_allPagesCount',
              style: TextStyle(fontSize: 22),
            ),
          ),
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              _pdfController.nextPage(
                curve: Curves.ease,
                duration: Duration(milliseconds: 100),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              if (isSampleDoc) {
                _pdfController
                    .loadDocument(PdfDocument.openAsset('assets/TANDC.pdf'));
              } else {
                _pdfController
                    .loadDocument(PdfDocument.openAsset('assets/TANDC.pdf'));
              }
              isSampleDoc = !isSampleDoc;
            },
          )
        ],
      ),
      body: PdfView(
        documentLoader: Center(child: CircularProgressIndicator()),
        pageLoader: Center(child: CircularProgressIndicator()),
        controller: _pdfController,
        onDocumentLoaded: (document) {
          setState(() {
            _allPagesCount = document.pagesCount;
          });
        },
        onPageChanged: (page) {
          setState(() {
            _actualPageNumber = page;
          });
        },
      ),
    );
    Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text('Terms and Conditions'),
        actions: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/icons/logo1024.png'),
          ),
        ],
      ),
      body: Center(
          child: PdfView(
        controller: _pdfController,
      )),
      // body: Center(
      //   child: ListView(
      //     children: [
      //       HtmlWidget(khtml),
      //     ],
      //   ),
      // ),
    );
  }
}
