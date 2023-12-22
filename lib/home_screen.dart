import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_database/models/notes_model.dart';
import 'package:hive_flutter/adapters.dart';

import 'boxes/boxes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Add Notes'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(

        valueListenable: Boxes.getData().listenable(),
        builder: (BuildContext context, box, Widget? child) {
          var data  =  box.values.toList().cast<NotesModel>();
          return ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: box.length,
              itemBuilder: (context, index){
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            children: [
                              const Text('Title: '),
                              Text(data[index].title.toString(),),
                              const Spacer(),
                              InkWell(
                                  onTap: (){
                                    delete(data[index]);
                                  },
                                  child: const Icon(Icons.delete_forever)),

                              const SizedBox(width: 15,),
                              InkWell(
                                  onTap: (){
                                    _editNotes(data[index], data[index].title.toString(), data[index].description.toString());
                                  },
                                  child: Icon(Icons.edit))
                            ]
                        ),
                        Text(data[index].description.toString()),
                      ],
                    ),
                  ),
                );
              });
      },),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.clear();
          descriptionController.clear();
          _showDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void delete(NotesModel notesModel){
    notesModel.delete();
  }

  Future <void> _showDialog()async{
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Add notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                      hintText: 'Enter title',
                      
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    maxLines: 3,
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: 'Enter Description',
                        contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                        border: OutlineInputBorder()
                    ),
                  )

                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                final data = NotesModel(
                    title: titleController.text,
                    description: descriptionController.text);
                final box = Boxes.getData();
                box.add(data);
                titleController.clear();
                descriptionController.clear();
                print(box);
                Navigator.pop(context);

              }, child: Text('Add')),

              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Cancel')),
            ],
          );
    });
  }

  Future <void> _editNotes(NotesModel notesModel, String title, String description)async{
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Edit notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                        hintText: 'Enter title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    maxLines: 3,
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: 'Enter Description',
                        contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                        border: OutlineInputBorder()
                    ),
                  )

                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    notesModel.title = titleController.text.toString();
                    notesModel.description = descriptionController.text.toString();
                    notesModel.save();
                Navigator.pop(context);
              }, child: Text('Edit')),

              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Cancel')),
            ],
          );
        });
  }

}
