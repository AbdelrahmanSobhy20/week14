import 'package:flutter/material.dart';
import 'package:to_do_application/calender.dart';
import 'package:to_do_application/sqldb.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SqlDb sqlDb = SqlDb();
  TextEditingController notes = TextEditingController();
  Future<List<Map>> readData()async{
    List<Map> response = await sqlDb.readData("SELECT * FROM todo ");
    return response;
  }
  bool done = false;
  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
      FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  )),
              builder: ((context) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  height: 200,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: notes,
                        decoration: const InputDecoration(
                            hintText: "Task Title",
                            hintStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Due Date",
                            hintStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const Calender()));
                                });
                              },
                              icon: const Icon(Icons.calendar_today)),
                          const SizedBox(
                            width: 150,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                             int response = await sqlDb.insertData('''
                             INSERT INTO todo ('notes')
                             VALUES  ("${notes.text}")
                             ''');
                             if ( response >0){
                               Navigator.of(context).pop();
                             }
                             print(response);
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }));
        },
      ),
      appBar: AppBar(
        elevation: 0,
        leading: const Icon(
          Icons.list,
          size: 40,
        ),
        title: const Text("Tasker",
            style: TextStyle(
              fontSize: 35,
            )),
      ),
      body: 
      Column(children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: const ListTile(
            title: Text(
              "OCT",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "2023",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            leading: Text(
              "20",
              style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              "Friday",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        FutureBuilder(
          future: readData(),
            builder: (BuildContext context , AsyncSnapshot<List<Map>> snapshot){
              if ( snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context , i ) {
                      bool goo = false;
                      return Card(
                        child: CheckboxListTile(
                          value: done,
                          onChanged: (val) {
                            setState(() {
                              done = val!;
                            });
                          },
                          title: Text("${snapshot.data![i]['notes']}" , style: TextStyle(fontSize: 20,),),
                        ),
                      );
                    });
              }
              return const Center(child: CircularProgressIndicator(),);
            })
      ]),
    );
  }
}

/*
          future : readData(),
              builder:(BuildContext context , AsyncSnapshot<List<Map>> snapshot ) {

            notes.length
            ,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, i) {
            return CheckboxListTile(
            value: done,
            onChanged: (val) {
            setState(() {
            done = val!;
            });
            },
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
            "${notes[i]['notes']}",
            style: const TextStyle(
            fontSize: 25,
            color: Colors.black,
            ),
            ),
            );
          };}),
 */
