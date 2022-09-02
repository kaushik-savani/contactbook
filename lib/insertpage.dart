import 'dart:io';

import 'package:contactbook/baseclass.dart';
import 'package:contactbook/viewpage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqlite_api.dart';

class insertpage extends StatefulWidget {
  Map? m;
  int? a;

  insertpage({required this.a, this.m});

  @override
  State<insertpage> createState() => _insertpageState();
}

class _insertpageState extends State<insertpage> {
  Database? db;
  String path = '';
  String imagepath = '';
  final ImagePicker _picker = ImagePicker();
  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();

  @override
  void initState() {
    super.initState();
    baseclass().createdatabase().then((value) {
      db = value;
    });
    if (widget.a == 1) {
      name.text = widget.m!['name'];
      contact.text = widget.m!['contact'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    widget.a == 1
                        ? InkWell(
                            onTap: () {
                              showDialog(
                                  builder: (context) {
                                    return SimpleDialog(
                                      title: Text("Select Picture"),
                                      children: [
                                        ListTile(
                                          onTap: () async {
                                            final XFile? photo =
                                                await _picker.pickImage(
                                                    source: ImageSource.camera);
                                            if (photo != null) {
                                              path = photo.path;
                                              Navigator.pop(context);
                                              setState(() {});
                                            }
                                          },
                                          title: Text("Camera"),
                                        ),
                                        ListTile(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
                                            if (photo != null) {
                                              path = photo.path;
                                              setState(() {});
                                            }
                                          },
                                          title: Text("Gallery"),
                                        ),
                                      ],
                                    );
                                  },
                                  context: context);
                            },
                            child: (widget.m!['imagepath'] == ''|| path.isNotEmpty)
                                ? Container(
                                    height: 30,
                                    width: 30,
                                    child: (path.isEmpty?Image.asset("myimage/user.png"):Container(
                                      height: 30,
                                      width: 30,
                                      child: Image.file(
                                          File(path)),
                                    )),
                                  )
                                : Container(
                              height: 30,
                              width: 30,
                              child: Image.file(
                                  File(widget.m!['imagepath'])),
                            ),
                          )
                        : InkWell(
                            onTap: () async {
                              showDialog(
                                  builder: (context) {
                                    return SimpleDialog(
                                      title: Text("Select Picture"),
                                      children: [
                                        ListTile(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            final XFile? photo =
                                            await _picker.pickImage(
                                                source: ImageSource.camera);
                                            if (photo != null) {
                                              path = photo.path;
                                              setState(() {});
                                            }
                                          },
                                          title: Text("Camera"),
                                        ),
                                        ListTile(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
                                            if (photo != null) {
                                              path = photo.path;
                                              setState(() {});
                                            }
                                          },
                                          title: Text("Gallery"),
                                        ),
                                      ],
                                    );
                                  },
                                  context: context);
                            },
                            child: path.isEmpty
                                ? Container(
                                    height: 100,
                                    width: 100,
                                    child: Image.asset("myimage/user.png"),
                                  )
                                : Image.file(
                                    File(path),
                                    height: 100,
                                    width: 100,
                                  ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      controller: name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.person),
                        label: Text("Name"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      keyboardType: TextInputType.phone,
                      controller: contact,
                      maxLength: 10,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.call),
                        label: Text("Contact"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            String _name = name.text;
                            String _contact = contact.text;
                            if (widget.a == 0) {
                              String qry =
                                  "insert into Test(name,contact,imagepath) values('$_name','$_contact','$path')";
                              await db!.rawInsert(qry);
                            } else if (widget.a == 1) {
                              String imagepath =
                                  path.isEmpty ? widget.m!['imagepath'] : path;
                              String qry =
                                  "update Test set name='$_name', contact='$_contact',imagepath='$imagepath' where id='${widget.m!['id']}'";
                              await db!.rawUpdate(qry);
                            }
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return viewpage();
                              },
                            ));
                          },
                          child: Text("Save")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: goback);
  }

  Future<bool> goback() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return viewpage();
      },
    ));
    return Future.value();
  }
}
