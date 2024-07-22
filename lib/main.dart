// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "QR Code Scanner",
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: QRCodeWidget(),
        ); 
  }
}

class QRCodeWidget extends StatefulWidget {
  const QRCodeWidget({super.key});

  @override
  State<QRCodeWidget> createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  final GlobalKey qrkey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String result = ""; 

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }
   void _onQRViewCreated(QRViewController controller){
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) { 
    setState(() {
      result = scanData.code!;
    }); 
    });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('QR Code Scanner')),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(key: qrkey,
          onQRViewCreated: _onQRViewCreated,
          )),
          Expanded(
            flex: 1,
            child:
           Center(child: Text('Scan Result: $result',
           style: TextStyle(
            fontSize: 18
           ),),
           ),
           ),
           Expanded(
            flex: 1,
            child:  Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (){
                  if(result.isNotEmpty){
                    Clipboard.setData(ClipboardData(text: result)); 
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                     content:Text('Copied To Clipoboard')));
                  }
                }, 
                child: Text('Copy')
                ),
                      
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: ()async {
                      final Uri _url = Uri.parse(result);
                        
                      if(result.isNotEmpty) {
                        await launchUrl(_url);
                      }
                  }, child: Text(('OPen'))),
                )
              ],
            )) 
        ],
      ),
    );
  }
  
  launchUrl(Uri url) {}
}