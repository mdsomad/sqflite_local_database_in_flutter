import 'package:flutter/material.dart';
import 'package:sqflite_local_database_in_flutter/data/local/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///Controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;

  @override
  void initState() {
    //lifecycle event
    // TODO: implement initState
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    //👇 get all notes
    allNotes = await dbRef!.getAllNote();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sqflite Local Database'),
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text("${index + 1}"),
                  title: Text(allNotes[index][DBHelper.COLUME_NOTE_TITLE]),
                  subtitle: Text(allNotes[index][DBHelper.COLUME_NOTE_DESC]),
                  trailing: SizedBox(
                    width: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              //👇 Edit Note
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  titleController.text = allNotes[index]
                                      [DBHelper.COLUME_NOTE_TITLE];
                                  descController.text = allNotes[index]
                                      [DBHelper.COLUME_NOTE_DESC];
                                  return getBootomSheetWdget(
                                      isUpdate: true,
                                      son: allNotes[index]
                                          [DBHelper.COLUME_NOTE_SON]);
                                },
                              );
                            },
                            child: Icon(Icons.edit)),
                        InkWell(
                            onTap: () async {
                              //👇 Delete Note
                              bool check = await dbRef!.deleteNote(
                                  allNotes[index][DBHelper.COLUME_NOTE_SON]);
                              if (check) {
                                getNotes();
                              }
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text('No Notes yet'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              // titleController.clear();
              // descController.clear();
              return getBootomSheetWdget();
            },
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget getBootomSheetWdget({bool isUpdate = false, int son = 0}) {
    // if (isUpdate) {}
    return Container(
      height: MediaQuery.of(context).size.height * 0.5 +
          MediaQuery.of(context).viewInsets.bottom,
      padding: EdgeInsets.only(
          right: 11,
          left: 11,
          top: 11,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            isUpdate ? "Update Note" : "Add Note",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 21,
          ),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              hintText: "Enter title here",
              label: Text("Title"),
            ),
          ),
          SizedBox(
            height: 11,
          ),
          TextField(
            controller: descController,
            maxLines: 4,
            decoration: InputDecoration(
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
              hintText: "Enter Description here",
              label: Text("Description"),
            ),
          ),
          SizedBox(
            height: 11,
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  onPressed: () async {
                    var title = titleController.text;
                    var desc = descController.text;
                    if (title.isNotEmpty && desc.isNotEmpty) {
                      /// 👇 Add Note
                      bool check = isUpdate
                          ? await dbRef!
                              .updateNote(mTitle: title, mDesc: desc, son: son)
                          : await dbRef!.addNote(mTitle: title, mDesc: desc);

                      if (check) {
                        getNotes();
                      }
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please fill all fields"),
                      ));
                    }
                  },
                  child: Text(isUpdate ? "Update Note" : "Add Note"),
                ),
              ),
              SizedBox(
                width: 11,
              ),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
