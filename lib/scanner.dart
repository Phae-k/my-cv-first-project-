import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ScannerPage(title: 'Scanner Page'),
    );
  }
}

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key, required this.title});

  final String title;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  MobileScannerController scanner = MobileScannerController();
  
  @override
  void initState() {
    super.initState();
    init();
  }
  
  void init() {}

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SizedBox(
              width: 400,
              height: 400,
              child: MobileScanner(
                onDetect: (result){
                  final barcodes = result.barcodes;
                  if(barcodes.isNotEmpty){
                    final raw = barcodes.first.rawValue;
                    if(raw != null && raw.isNotEmpty) {
                      Navigator.pop(context,raw);
                  }
                }
              },
            ),
            ),


          ],
        ),
      ), 
    );
  } 
}