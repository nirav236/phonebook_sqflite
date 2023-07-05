import 'package:flutter/material.dart';


import 'add_update.dart';
import 'db_handler.dart';
import 'model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  late Future<List<Contact>> dataList;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "Contact Book",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: dataList,
              builder: (context, AsyncSnapshot<List<Contact>> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.length == 0) {
                  return const Center(
                    child: Text(
                      "No Tasks Found",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      int contactid = snapshot.data![index].id!.toInt();
                      String contactname = snapshot.data![index].name.toString();
                      String contactnum = snapshot.data![index].contact.toString();
                    

                      return Dismissible(
                        key: ValueKey<int>(contactid),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            dbHelper!.delete(contactid);
                            dataList = dbHelper!.getDataList();
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              //color: Colors.grey,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(31, 0, 0, 0),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                )
                              ]),
                          child: Column(
                            children: [
                              Card(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(10),
                                  title: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      contactname,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  subtitle: Text(
                                    contactnum,
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.white,
                                thickness: 0.8,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                  
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddupdateTask(
                                                      contactid:contactid ,
                                                      contactname: contactname,
                                                      contactnum: contactnum,
                                                      
                                                      update: true,
                                                    )));
                                      },
                                      child: const Icon(
                                        Icons.edit_note,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: const Icon(
            Icons.add,
            size: 45,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddupdateTask(),
                ));
          }),
    );
  }
}
