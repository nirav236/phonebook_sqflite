import 'package:flutter/material.dart';



import 'db_handler.dart';
import 'homepage.dart';
import 'model.dart';

// ignore: must_be_immutable
class AddupdateTask extends StatefulWidget {
  int? contactid;
  String? contactname;
  String? contactnum;
 
  bool? update;

  AddupdateTask({
    this.contactid,
    this.contactname,
    this.contactnum,
  
    this.update,
  });

  @override
  State<AddupdateTask> createState() => _AddupdateTaskState();
}

class _AddupdateTaskState extends State<AddupdateTask> {
  DBHelper? dbHelper;
  late Future<List<Contact>> dataList;

  final _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
  final  TextEditingController namecontroller = TextEditingController(text: widget.contactname);
 final TextEditingController contactcontroller = TextEditingController(text: widget.contactnum);
    String appTitle;
    if (widget.update == true) {
      appTitle = "Update Contact";
    } else {
      appTitle = "Add Contact";
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          appTitle,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _fromKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: namecontroller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Contact Name",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter some text";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                  maxLength: 10,
                        controller: contactcontroller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Contact Number",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter some text";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Material(
                        color: Colors.green[400],
                        child: InkWell(
                          onTap: () {
                            if (_fromKey.currentState!.validate()) {
                              if (widget.update == true) {
                                dbHelper!.update(Contact(
                                  id: widget.contactid,
                                  name: namecontroller.text,
                                  contact: contactcontroller.text,
                               
                                ));
                              } else {
                                dbHelper!.insert(Contact(
                          
                                    name: namecontroller.text,
                                    contact: contactcontroller.text,
                                    ));
                              }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()));

                              namecontroller.clear();
                              contactcontroller.clear();
                              print("data added");
                           }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 55,
                            width: 120,
                            decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(
                                //     blurRadius: 5,
                                //     color: Colors.black12,
                                //     spreadRadius: 1,
                                //   )
                                // ],
                                ),
                            child: const Text("Submit",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.red[400],
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              namecontroller.clear();
                              contactcontroller.clear();
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 55,
                            width: 120,
                            decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(
                                //     blurRadius: 5,
                                //     color: Colors.black12,
                                //     spreadRadius: 1,
                                //   )
                                // ],
                                ),
                            child: const Text("Clear",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
