import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_01/firebase_options.dart';
import 'package:project_01/scanner.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, //
  ).then((_) {
    print("Firebase Connected.");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
       colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 248, 248, 248)),
      ),
      home: const ApplicationPage(title: 'Application Page'),
    );
  }
}

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key, required this.title});

  final String title;

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> products = [];

  List<Map<String, dynamic>> search_products = [];

  TextEditingController controller_bar_code = TextEditingController();
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_country = TextEditingController();

  TextEditingController controller_search = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }
  
  void init() async{

    products.clear();

    await db //
    .collection("collection_products")
    .orderBy("created_at", descending: true)
    .get()
    .then((q) {
      for(var doc in q.docs){
        // print(doc.id);
        // print(doc.data());
        // print(doc.data()["barcoder"]);

        // ignore: unused_local_variable
        var data = {
          "id": doc.id,
          "barcode": doc.data()["barcode"] ?? "",
          "name": doc.data()["name"]  ?? "",
          "country": doc.data()["country"]  ?? "",
        };
        products.add(data);
      }
    });

    search();
  // print(products[0]["id"]);\
   setState(() {}); 
   // ignore: unused_element
  //  void searchProducts(){
  //   if(controller_search.text.isEmpty){}
  //  }

    // //create document
    // await db.collection("collection_credential").add({
    //  "created_at": DateTime.now(), //
    // });

    // // read document
    // await db //
    // .collection("collection_credential")
    // .get()
    // .then((q) {
    //   for(var doc in q.docs){
    //     print(doc.id + " " + doc.data().toString());
    //   }
    // })
    // .catchError((e){
    //   print(e);
    // });

    // // update document 
    // await db
    //      .collection("collection_credential")
    //      .doc("DFGXFDXCHGCbvgvgv")
    //      .update({
    //         "username": "admin",
    //         "passwords": "admin",
    //         "update_at": DateTime.now(),
    //      });

    // // delete document
    // await db
    //      .collection("collection_credential")
    //      .doc("DFGXFDXCHGC")
    //      .delete();
 
} 

 void search() {

  if(controller_search.text.isEmpty){
    search_products = List.from(products);

  } else{
    
    String keyword = controller_search.text.toLowerCase();
    search_products = products.where((element) {

      if(element["barcode"].toString().toLowerCase().contains(keyword)){
        return true;

      } else {
        return false;
      }
    }).toList();
  }
  setState(() {});
 }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Row(
              children: [
                SizedBox(
                  width: 300, 
                  child: TextField(
                    controller: controller_search,
                    onChanged: (value) {
                      //print(value);
                      search();
                    },
                  )
                  
                  ),
                IconButton(
                  onPressed: (){
                    Navigator.of(context)
                    .push(MaterialPageRoute(
                      builder: (context) {
                        return ScannerPage(title: "Scanner Page");
                      },
                      )
                      ).then((Value){
                        if(Value != null){
                          controller_search.text = Value;
                          search();

                        }
                      }); 
                  }, 
                  icon: Icon(Icons.barcode_reader)
                ),
              ],
            ),

            Expanded(child: ListView.builder(
              itemCount: search_products.length,
              itemBuilder: (context, index){
                //return ListTile(title: Text("Item $index"));
                return Row(
                  children: [
            
                    OutlinedButton(
                      onPressed: (){

                        showDialog(
                          context: context, 
                          builder: (context){
                            return AlertDialog(
                              title: Text("Edit Barcode:"),

                              content: TextField(controller: controller_bar_code),
                              actions: [
                                OutlinedButton(
                                  onPressed: () async {
                                    String new_barcode = controller_bar_code.text;

                                    await db
                                    .collection("collection_products")
                                    .doc(search_products[index]["id"])
                                    .update({
                                      "barcode": new_barcode,
                                    });

                                    init();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Save"),
                                ),
                              ],
                            );
                          }
                          );
                      }, 
                      child: Text(search_products[index]["barcode"])
                      ),

                    OutlinedButton(
                      onPressed: (){

                        showDialog(
                          context: context, 
                          builder: (context){
                            return AlertDialog(
                              title: Text("Edit Name:"),
                              content: TextField(controller: controller_name),
                              actions: [
                                OutlinedButton(
                                  onPressed: () async{
                                    String new_name = controller_name.text;

                                    await db
                                    .collection("collection_products")
                                    .doc(search_products[index]["id"])
                                    .update({
                                      "name": new_name,
                                    });

                                    init();

                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Save"),
                                ),
                              ],
                            );
                          }
                          );
                      }, 
                      child: Text(search_products[index]["name"])
                      ),

                    OutlinedButton(
                      onPressed: (){
                        
                        showDialog(
                          context: context, 
                          builder: (context){
                            return AlertDialog(
                              title: Text("Edit Country:"),
                              content: TextField(controller: controller_country),
                              actions: [
                                OutlinedButton(
                                  onPressed: () async{
                                    String new_country = controller_country.text;

                                    await db
                                    .collection("collection_products")
                                    .doc(search_products[index]["id"])
                                    .update({
                                      "country": new_country,
                                    });

                                    init();

                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Save"),
                                ),
                              ],
                            );
                          }
                          );
                      }, 
                      child: Text(search_products[index]["country"])
                      ),

                    IconButton(
                      onPressed: () async{
                        await db //
                        .collection("collection_products")
                        .doc(search_products[index]["id"])
                        .delete();

                      init();   
                      }, 
                      icon: Icon(Icons.delete),
                      ),

                  ]);
              } 
            )
            ),
     
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          
          await db
          .collection("collection_products")
          .add({
            "created_at": DateTime.now(), //
          });
          
        }, 
        child: Icon(Icons.add)),
    
    );
  }
 
}