import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = "Click button to read";

  void _updateMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC demo, using nfc_in_flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              _message,
              textAlign: TextAlign.center,
              maxLines: 20,
            ),
            SizedBox(height: 50),
            InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () async {
                _updateMessage("reading ...");

                NDEFMessage message = await NFC.readNDEF(once: true).first;
                if (message.isEmpty) {
                  _updateMessage("Read empty NDEF message");
                  return;
                }

                var tempMessage = "${message.records.length} records found: \n";
                for (NDEFRecord record in message.records) {
                  tempMessage += "------------------------------------\n";
                  tempMessage +=
                      "type '${record.type}', \npayload '${record.payload}' and \ndata '${record.data}' \n";
                }
                _updateMessage(tempMessage);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(blurRadius: 10, offset: Offset(2, 3))
                        ],
                      ),
                    ),
                    Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/NFC_logo.svg/2000px-NFC_logo.svg.png',
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
